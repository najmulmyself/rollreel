import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/memories/on_this_day_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/capture_video.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import 'home_clip_player.dart';

final _homeThumbnailProvider = FutureProvider.autoDispose
    .family<Uint8List?, AssetEntity>((ref, asset) async {
      try {
        return await asset.thumbnailDataWithSize(const ThumbnailSize(760, 520));
      } on Exception {
        return null;
      }
    });

final homeTitleProvider = FutureProvider.autoDispose
    .family<String?, AssetEntity>((ref, asset) async {
      final title = asset.title?.trim();
      if (title != null && title.isNotEmpty) return title;
      try {
        final loadedTitle = (await asset.titleAsync).trim();
        return loadedTitle.isEmpty ? null : loadedTitle;
      } on Exception {
        return null;
      }
    });

class HomeVideoSections extends ConsumerStatefulWidget {
  const HomeVideoSections({
    super.key,
    required this.onOpenLibrary,
    required this.onOpenMemories,
  });

  final VoidCallback onOpenLibrary;
  final ValueChanged<String?> onOpenMemories;

  @override
  ConsumerState<HomeVideoSections> createState() => _HomeVideoSectionsState();
}

class _HomeVideoSectionsState extends ConsumerState<HomeVideoSections> {
  bool _openingCamera = false;

  @override
  void initState() {
    super.initState();
    // Android can recreate RollReel while the camera activity is on top.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _saveCameraResult(() async {
          final result = await ImagePicker().retrieveLostData();
          if (result.exception case final error?) throw error;
          return result.files?.firstOrNull;
        });
      });
    }
  }

  Future<void> _openCamera() => _saveCameraResult(recordVideo);

  Future<void> _saveCameraResult(Future<XFile?> Function() loadClip) async {
    if (_openingCamera) return;
    setState(() => _openingCamera = true);
    try {
      final clip = await loadClip();
      if (clip == null) return;
      await saveRecordedVideo(clip);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ref.invalidate(videoLibraryProvider);
    } catch (error) {
      debugPrint('Could not capture or save a video: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.homeCaptureFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _openingCamera = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permission = ref.watch(permissionProvider);
    if (permission.isLoading) return const _WatchSkeleton();
    if (permission.hasError) {
      return HomeLibraryError(
        onRetry: () => ref.invalidate(permissionProvider),
      );
    }
    if (permission.valueOrNull?.hasAccess != true) {
      return const HomePhotosAccess();
    }

    final videos = ref.watch(visibleVideosProvider);
    if (videos.isLoading) return const _WatchSkeleton();
    if (videos.hasError) {
      return HomeLibraryError(
        onRetry: () => ref.invalidate(videoLibraryProvider),
      );
    }
    AssetEntity? latest;
    for (final video in videos.requireValue) {
      if (latest == null ||
          video.createDateTime.isAfter(latest.createDateTime)) {
        latest = video;
      }
    }
    if (latest == null) {
      return _LibraryMessage(
        icon: CupertinoIcons.photo,
        title: l10n.homeEmptyTitle,
        body: l10n.homeEmptyBody,
        action: canRecordVideo ? l10n.homeOpenCamera : l10n.library,
        onPressed: canRecordVideo
            ? (_openingCamera ? null : _openCamera)
            : widget.onOpenLibrary,
      );
    }

    final memories = ref.watch(onThisDayProvider);
    final previews = (memories.valueOrNull ?? const <AssetEntity>[])
        .take(2)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeading(
          title: l10n.watchNext,
          action: l10n.library,
          onPressed: widget.onOpenLibrary,
        ),
        _FeaturedVideo(asset: latest),
        const SizedBox(height: 19),
        if (memories.isLoading) ...[
          _SectionHeading(title: l10n.onThisDay),
          const _MemorySkeletons(),
        ] else if (previews.isNotEmpty) ...[
          _SectionHeading(
            title: l10n.onThisDay,
            action: l10n.seeAll,
            onPressed: () => widget.onOpenMemories(null),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MemoryPreview(
                  asset: previews.first,
                  onTap: () => widget.onOpenMemories(previews.first.id),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: previews.length == 2
                    ? _MemoryPreview(
                        asset: previews.last,
                        onTap: () => widget.onOpenMemories(previews.last.id),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ] else ...[
          _SectionHeading(title: l10n.onThisDay),
          Text(l10n.homeNoMemories, style: _homeCaption),
        ],
      ],
    );
  }
}

Color get homeInk =>
    RRColors.isDark.value ? RRColors.textPrimary : RRColors.brandInk;
Color get homeAccent =>
    RRColors.isDark.value ? RRColors.accentCyan : RRColors.brandBlue;
Color get homeRule =>
    RRColors.isDark.value ? RRColors.divider : const Color(0xFFE5EDF2);
TextStyle get _homeCaption => RRTypography.caption.copyWith(
  color: RRColors.isDark.value ? RRColors.textSecond : RRColors.brandMutedInk,
);
TextStyle get homeHeading => RRTypography.title2.copyWith(
  color: homeInk,
  fontSize: 24,
  letterSpacing: -.7,
  fontWeight: FontWeight.w700,
);

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.action, this.onPressed});

  final String title;
  final String? action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: homeHeading),
            ),
          ),
          if (action case final label?)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: homeAccent,
                minimumSize: const Size(44, 44),
                padding: const EdgeInsetsDirectional.only(start: 8),
                textStyle: RRTypography.headline.copyWith(fontSize: 13),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? CupertinoIcons.chevron_left
                        : CupertinoIcons.chevron_right,
                    size: 11,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class HomePhotosAccess extends ConsumerWidget {
  const HomePhotosAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final canRequest =
        ref.watch(permissionProvider).valueOrNull ==
        PermissionState.notDetermined;
    return _LibraryMessage(
      icon: CupertinoIcons.photo,
      title: l10n.homeAccessTitle,
      body: canRequest ? l10n.onboardingPermissionBody : l10n.homeAccessBody,
      action: canRequest ? l10n.allowAccess : l10n.openSettings,
      onPressed: canRequest
          ? () async {
              try {
                final container = ProviderScope.containerOf(
                  context,
                  listen: false,
                );
                final permission = await ref
                    .read(permissionProvider.notifier)
                    .request();
                if (permission.hasAccess) {
                  container.invalidate(videoLibraryProvider);
                }
              } on Exception {
                // The permission provider supplies the retry state.
              }
            }
          : PhotoManager.openSetting,
    );
  }
}

class HomeLibraryError extends StatelessWidget {
  const HomeLibraryError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _LibraryMessage(
      icon: CupertinoIcons.photo,
      title: l10n.homeLoadFailed,
      body: l10n.homeLoadFailedBody,
      action: l10n.retry,
      onPressed: onRetry,
    );
  }
}

class _LibraryMessage extends StatelessWidget {
  const _LibraryMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String body;
  final String action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 27),
      decoration: BoxDecoration(
        color: RRColors.isDark.value
            ? RRColors.bgElevated
            : const Color(0xFFEEF7FB),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: homeAccent, size: 30),
          const SizedBox(height: 18),
          Text(title, style: homeHeading),
          const SizedBox(height: 7),
          Text(body, style: _homeCaption.copyWith(fontSize: 14, height: 1.5)),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onPressed == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  },
            style: FilledButton.styleFrom(
              backgroundColor: homeAccent,
              foregroundColor: RRColors.isDark.value
                  ? RRColors.brandInk
                  : Colors.white,
              minimumSize: const Size(44, 46),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}

class _WatchSkeleton extends StatelessWidget {
  const _WatchSkeleton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.loadingLibrary,
      child: ExcludeSemantics(
        child: Column(
          children: [
            _SectionHeading(title: l10n.watchNext),
            const AspectRatio(
              aspectRatio: 350 / 195,
              child: _Skeleton(radius: 17),
            ),
            const SizedBox(height: 19),
            _SectionHeading(title: l10n.onThisDay),
            const _MemorySkeletons(),
          ],
        ),
      ),
    );
  }
}

class _MemorySkeletons extends StatelessWidget {
  const _MemorySkeletons();

  @override
  Widget build(BuildContext context) {
    const tile = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1.7, child: _Skeleton(radius: 12)),
        SizedBox(height: 9),
        FractionallySizedBox(
          widthFactor: .64,
          child: SizedBox(height: 13, child: _Skeleton(radius: 5)),
        ),
      ],
    );
    return const Row(
      children: [
        Expanded(child: tile),
        SizedBox(width: 10),
        Expanded(child: tile),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RRColors.isDark.value
            ? RRColors.bgElevated
            : const Color(0xFFE4EDF1),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _FeaturedVideo extends ConsumerStatefulWidget {
  const _FeaturedVideo({required this.asset});

  final AssetEntity asset;

  @override
  ConsumerState<_FeaturedVideo> createState() => _FeaturedVideoState();
}

class _FeaturedVideoState extends ConsumerState<_FeaturedVideo> {
  bool _opening = false;
  bool _pressed = false;

  Future<void> _open(String title, Uint8List? poster) async {
    if (_opening) return;
    _opening = true;
    final asset = widget.asset;
    HapticFeedback.selectionClick();
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 310);
    try {
      await Navigator.of(context).push<void>(
        PageRouteBuilder(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (_, _, _) =>
              HomeClipPlayer(asset: asset, title: title, poster: poster),
          transitionsBuilder: (_, animation, _, child) => FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
            child: child,
          ),
        ),
      );
    } finally {
      _opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final l10n = AppLocalizations.of(context)!;
    final title =
        ref.watch(homeTitleProvider(asset)).valueOrNull ??
        l10n.videoFallbackTitle;
    final poster = ref.watch(_homeThumbnailProvider(asset)).valueOrNull;
    final duration = Duration(seconds: asset.duration);
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return AnimatedScale(
      scale: _pressed ? .983 : 1,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 100),
      child: Material(
        color: RRColors.brandInk,
        borderRadius: BorderRadius.circular(17),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 350 / 195,
          child: Stack(
            fit: StackFit.expand,
            children: [
              HeroMode(
                enabled: !MediaQuery.disableAnimationsOf(context),
                child: Hero(
                  tag: homeClipHeroTag(asset.id),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: HomeClipPoster(bytes: poster, fit: BoxFit.cover),
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(gradient: RRColors.gradFeedOverlay),
              ),
              PositionedDirectional(
                start: 16,
                end: 15,
                bottom: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${duration.inMinutes}:$seconds',
                            style: RRTypography.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: RRTypography.title2.copyWith(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(
                        dimension: 47,
                        child: Icon(
                          CupertinoIcons.play_fill,
                          color: RRColors.brandInk,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: l10n.homePlayClip(title),
                button: true,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onHighlightChanged: (pressed) =>
                        setState(() => _pressed = pressed),
                    onTap: () => _open(title, poster),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoryPreview extends ConsumerWidget {
  const _MemoryPreview({required this.asset, required this.onTap});

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        ref.watch(homeTitleProvider(asset)).valueOrNull ??
        l10n.videoFallbackTitle;
    final poster = ref.watch(_homeThumbnailProvider(asset)).valueOrNull;
    final years = DateTime.now().year - asset.createDateTime.year;
    final age = years == 1 ? l10n.yearsAgoOne : l10n.yearsAgoMany(years);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.7,
                child: HomeClipPoster(bytes: poster, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              age,
              style: RRTypography.subheadline.copyWith(
                color: homeInk,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _homeCaption,
            ),
          ],
        ),
      ),
    );
  }
}
