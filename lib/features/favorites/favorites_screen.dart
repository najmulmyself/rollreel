import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/vault/vault_provider.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import '../browse/library_widgets.dart';

const _thumbnailAspectRatio = 1.05;

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key, this.onPlayAt, this.onOpenLibrary});

  final ValueChanged<String>? onPlayAt;
  final VoidCallback? onOpenLibrary;

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  final _pendingRemovals = <String>{};

  void _showFeedback(String text, {SnackBarAction? action}) {
    _messenger.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: RRColors.brandInk,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 8),
          content: Text(
            text,
            style: RRTypography.subheadline.copyWith(color: Colors.white),
          ),
          action: action,
        ),
      );
  }

  Future<void> _remove(String id) async {
    final index = ref.read(favoritesIdsProvider).toList().indexOf(id);
    if (index < 0 || !_pendingRemovals.add(id)) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      HapticFeedback.selectionClick();
      await ref.read(favoritesIdsProvider.notifier).setFavorite(id, false);
      if (!mounted) return;
      _showFeedback(
        l10n.favoritesRemoved,
        action: SnackBarAction(
          label: l10n.favoritesUndo,
          textColor: const Color(0xFFB8E7FF),
          onPressed: () => _restore(id, index),
        ),
      );
    } catch (_) {
      if (mounted) _showFeedback(l10n.favoritesUpdateFailed);
    } finally {
      _pendingRemovals.remove(id);
    }
  }

  Future<void> _restore(String id, int index) async {
    try {
      HapticFeedback.selectionClick();
      await ref
          .read(favoritesIdsProvider.notifier)
          .setFavorite(id, true, index: index);
    } catch (_) {
      if (mounted) {
        _showFeedback(AppLocalizations.of(context)!.favoritesUpdateFailed);
      }
    }
  }

  Future<void> _requestAccess() async {
    try {
      final result = await ref.read(permissionProvider.notifier).request();
      if (mounted && result.hasAccess) ref.invalidate(videoLibraryProvider);
    } on Exception {
      // The permission provider reports failures to the recovery state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permission = ref.watch(permissionProvider);
    final ids = ref.watch(favoritesIdsProvider);
    final vaulted = ref.watch(vaultIdsProvider);
    final hasAccess = permission.valueOrNull?.hasAccess == true;
    final assets = hasAccess ? ref.watch(favoriteAssetsProvider) : null;
    final videos = assets?.valueOrNull
        ?.where(
          (video) => ids.contains(video.id) && !vaulted.contains(video.id),
        )
        .toList();
    return AnnotatedRegion(
      value:
          (RRColors.isDark.value
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
      child: ScaffoldMessenger(
        key: _messenger,
        child: Scaffold(
          backgroundColor: libraryHeader,
          bottomNavigationBar: ColoredBox(
            color: librarySurface,
            child: const SafeArea(top: false, child: SizedBox.shrink()),
          ),
          body: SafeArea(
            bottom: false,
            child: ColoredBox(
              color: librarySurface,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FavoritesHeader(
                        count:
                            permission.hasError ||
                                permission.isLoading ||
                                assets?.hasError == true
                            ? null
                            : videos?.length,
                      ),
                      Expanded(child: _body(l10n, permission, assets, videos)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(
    AppLocalizations l10n,
    AsyncValue<PermissionState> permission,
    AsyncValue<List<AssetEntity>>? assets,
    List<AssetEntity>? videos,
  ) {
    if (permission.hasError || assets?.hasError == true) {
      return _FavoritesMessage(
        title: l10n.favoritesLoadFailed,
        body: l10n.favoritesRetryBody,
        label: l10n.retry,
        icon: CupertinoIcons.exclamationmark_circle,
        action: () {
          if (permission.hasError) ref.invalidate(permissionProvider);
          if (assets?.hasError == true) {
            ref.invalidate(favoritesIdsProvider);
            ref.invalidate(favoriteAssetsProvider);
          }
        },
      );
    }

    if (!permission.isLoading && permission.valueOrNull?.hasAccess != true) {
      final canRequest =
          permission.valueOrNull == PermissionState.notDetermined;
      return _FavoritesMessage(
        title: canRequest ? l10n.homeAccessTitle : l10n.libraryAccessOff,
        body: canRequest
            ? l10n.onboardingPermissionBody
            : l10n.favoritesAccessBody,
        label: canRequest ? l10n.allowAccess : l10n.openSettings,
        icon: CupertinoIcons.photo_on_rectangle,
        action: canRequest ? _requestAccess : PhotoManager.openSetting,
      );
    }

    if (permission.isLoading || videos == null) {
      return const _FavoritesGrid(loading: true);
    }

    if (videos.isEmpty) {
      return _FavoritesMessage(
        title: l10n.favoritesEmptyTitle,
        body: l10n.favoritesEmptyBody,
        label: l10n.goToLibrary,
        action: widget.onOpenLibrary,
      );
    }

    return _FavoritesGrid(
      videos: videos,
      onPlayAt: widget.onPlayAt,
      onRemove: _remove,
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  const _FavoritesHeader({required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: libraryHeader,
        border: Border(bottom: BorderSide(color: libraryLine)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 17, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Semantics(
                header: true,
                child: Text(
                  l10n.favorites,
                  style: RRTypography.title1.copyWith(
                    fontSize: MediaQuery.sizeOf(context).width < 345 ? 33 : 38,
                    color: libraryInk,
                    letterSpacing: -1.5,
                    height: 1.05,
                  ),
                ),
              ),
            ),
            if (count case final saved? when saved > 0)
              Flexible(
                child: Text(
                  l10n.favoritesSavedCount(saved),
                  textAlign: TextAlign.end,
                  style: libraryNote.copyWith(fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({
    this.videos = const [],
    this.onPlayAt,
    this.onRemove,
    this.loading = false,
  });

  final List<AssetEntity> videos;
  final ValueChanged<String>? onPlayAt;
  final ValueChanged<String>? onRemove;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        const padding = 20.0;
        final columns = constraints.maxWidth >= 570 ? 3 : 2;
        final tileWidth = math.max(
          0.0,
          (constraints.maxWidth - 2 * padding - (columns - 1) * gap) / columns,
        );
        final scaler = MediaQuery.textScalerOf(context);
        final tileHeight =
            tileWidth / _thumbnailAspectRatio +
            scaler.scale(15) * 1.25 +
            scaler.scale(12) * 1.35 +
            12;
        final grid = GridView.builder(
          key: const PageStorageKey('favorites-grid'),
          padding: const EdgeInsets.fromLTRB(padding, 18, padding, 14),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: gap,
            mainAxisSpacing: 19,
            mainAxisExtent: tileHeight,
          ),
          itemCount: loading ? 6 : videos.length,
          itemBuilder: (context, index) {
            if (loading) return const _FavoriteSkeleton();
            final video = videos[index];
            return _FavoriteTile(
              key: ValueKey(video.id),
              asset: video,
              onPlay: onPlayAt == null ? null : () => onPlayAt!(video.id),
              onRemove: () => onRemove?.call(video.id),
            );
          },
        );
        if (!loading) return grid;
        return Semantics(
          label: AppLocalizations.of(context)!.loadingLibrary,
          child: ExcludeSemantics(child: grid),
        );
      },
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({
    super.key,
    required this.asset,
    required this.onPlay,
    required this.onRemove,
  });

  final AssetEntity asset;
  final VoidCallback? onPlay;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        ref.watch(libraryTitleProvider(asset)).valueOrNull ?? asset.title;
    final name = title == null || title.trim().isEmpty
        ? l10n.videoFallbackTitle
        : title;
    final locale = Localizations.localeOf(context).toString();
    final date = asset.createDateSecond == null
        ? l10n.libraryUnknownDate
        : DateFormat.yMMMd(locale).format(asset.createDateTime);
    final minutes = asset.duration ~/ 60;
    final seconds = (asset.duration % 60).toString().padLeft(2, '0');
    return Stack(
      children: [
        InkWell(
          onTap: onPlay,
          borderRadius: BorderRadius.circular(13),
          child: Semantics(
            label: l10n.libraryVideoRow(name, date, '$minutes:$seconds'),
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: _thumbnailAspectRatio,
                  child: LibraryThumbnail(
                    asset: asset,
                    showDuration: true,
                    radius: 13,
                    thumbnailSize: const ThumbnailSize.square(480),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: RRTypography.headline.copyWith(
                    color: libraryInk,
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: libraryNote.copyWith(height: 1.35),
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          top: 2,
          end: 2,
          child: IconButton(
            onPressed: onRemove,
            tooltip: l10n.favoritesRemoveVideo(name),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: librarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.heart_fill,
                color: libraryAccent,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteSkeleton extends StatelessWidget {
  const _FavoriteSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AspectRatio(
        aspectRatio: _thumbnailAspectRatio,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: libraryTint,
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      const SizedBox(height: 10),
      FractionallySizedBox(
        widthFactor: .72,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: libraryTint,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ],
  );
}

class _FavoritesMessage extends StatelessWidget {
  const _FavoritesMessage({
    required this.title,
    required this.body,
    required this.label,
    required this.action,
    this.icon,
  });

  final String title;
  final String body;
  final String label;
  final VoidCallback? action;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.sizeOf(context).height < 690 ? 38 : 60,
        20,
        22,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 305),
          child: Column(
            children: [
              if (icon case final glyph?)
                ExcludeSemantics(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: libraryTint,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(glyph, size: 25, color: libraryAccent),
                  ),
                )
              else
                const _FavoritesMascot(),
              SizedBox(height: icon == null ? 22 : 18),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: libraryHeading.copyWith(
                    fontSize: 28,
                    letterSpacing: -.75,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 254),
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: libraryBody.copyWith(
                    color: libraryMuted,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: action,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(44, 49),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 23,
                      vertical: 9,
                    ),
                    foregroundColor: libraryOnAccent,
                    backgroundColor: libraryAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: RRTypography.headline.copyWith(fontSize: 15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon == null) ...[
                        const Icon(CupertinoIcons.folder, size: 15),
                        const SizedBox(width: 9),
                      ],
                      Flexible(child: Text(label, textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritesMascot extends StatelessWidget {
  const _FavoritesMascot();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: 222,
      height: 193,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 2,
            child: Transform.rotate(
              angle: -.14,
              child: Container(
                width: 200,
                height: 124,
                decoration: BoxDecoration(
                  color: libraryTint,
                  borderRadius: const BorderRadius.all(
                    Radius.elliptical(100, 62),
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 19,
            top: 63,
            child: Icon(CupertinoIcons.heart, size: 27, color: libraryAccent),
          ),
          PositionedDirectional(
            end: 36,
            bottom: 0,
            child: Image.asset(
              'assets/images/home_kingfisher.webp',
              height: 184,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
  );
}
