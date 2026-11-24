import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/memories/on_this_day_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/duration_badge.dart';

final _homeThumbnailProvider = FutureProvider.autoDispose
    .family<Uint8List?, AssetEntity>((ref, asset) async {
      try {
        return await asset.thumbnailDataWithSize(const ThumbnailSize(760, 520));
      } on Exception {
        return null;
      }
    });

final _homeTitleProvider = FutureProvider.autoDispose
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

class HomeVideoSections extends ConsumerWidget {
  const HomeVideoSections({
    super.key,
    required this.onOpenLibrary,
    required this.onPlayAt,
    required this.onOpenMemories,
  });

  final VoidCallback onOpenLibrary;
  final ValueChanged<String> onPlayAt;
  final ValueChanged<String?> onOpenMemories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final videos = ref.watch(visibleVideosProvider);
    final memories = ref.watch(onThisDayProvider);
    final memoryPreviews = memories.isLoading
        ? const <AssetEntity>[]
        : (memories.valueOrNull ?? const <AssetEntity>[]).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeading(
          title: l10n.watchNext,
          action: l10n.library,
          onPressed: onOpenLibrary,
        ),
        const SizedBox(height: 8),
        videos.when(
          skipLoadingOnRefresh: false,
          loading: () => _LibraryStatus(
            child: Semantics(
              label: l10n.loadingLibrary,
              child: const CupertinoActivityIndicator(),
            ),
          ),
          error: (_, _) => _LibraryStatus(
            child: TextButton(
              onPressed: () {
                ref.invalidate(videoLibraryProvider);
                ref.invalidate(visibleVideosProvider);
              },
              child: Text(l10n.retry),
            ),
          ),
          data: (videos) {
            AssetEntity? latest;
            for (final video in videos) {
              if (latest == null ||
                  video.createDateTime.isAfter(latest.createDateTime)) {
                latest = video;
              }
            }
            final video = latest;
            return video == null
                ? _LibraryStatus(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.film,
                          color: _homeTextColor,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noVideosYetTitle,
                          textAlign: TextAlign.center,
                          style: RRTypography.headline.copyWith(
                            color: _homeTextColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.noVideosYetBody,
                          textAlign: TextAlign.center,
                          style: _homeCaption,
                        ),
                      ],
                    ),
                  )
                : _FeaturedVideo(asset: video, onTap: () => onPlayAt(video.id));
          },
        ),
        if (memoryPreviews.isNotEmpty) ...[
          const SizedBox(height: 26),
          _SectionHeading(
            title: l10n.onThisDay,
            action: l10n.seeAll,
            onPressed: () => onOpenMemories(null),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < memoryPreviews.length; index++) ...[
                if (index > 0) const SizedBox(width: 10),
                Expanded(
                  child: _MemoryPreview(
                    asset: memoryPreviews[index],
                    onTap: () => onOpenMemories(memoryPreviews[index].id),
                  ),
                ),
              ],
              if (memoryPreviews.length == 1) const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }
}

Color get _homeTextColor =>
    RRColors.isDark.value ? RRColors.textPrimary : RRColors.brandInk;

TextStyle get _homeCaption => RRTypography.subheadline.copyWith(
  color: RRColors.isDark.value ? RRColors.textSecond : RRColors.brandMutedInk,
);

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onPressed,
  });

  final String title;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: RRTypography.title2.copyWith(
                color: _homeTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: RRColors.isDark.value
                ? RRColors.accentCyan
                : RRColors.brandBlue,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsetsDirectional.only(start: 8),
            textStyle: RRTypography.headline.copyWith(fontSize: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(action),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _LibraryStatus extends StatelessWidget {
  const _LibraryStatus({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RRColors.bgSurface,
        border: Border.all(
          color: RRColors.isDark.value
              ? RRColors.divider
              : RRColors.brandOutline,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 148),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _FeaturedVideo extends ConsumerWidget {
  const _FeaturedVideo({required this.asset, required this.onTap});

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        ref.watch(_homeTitleProvider(asset)).valueOrNull ??
        l10n.videoFallbackTitle;
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.MMMd(locale).format(asset.createDateTime);

    return Material(
      color: RRColors.brandInk,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1.47,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _VideoCover(asset: asset),
              const DecoratedBox(
                decoration: BoxDecoration(gradient: RRColors.gradFeedOverlay),
              ),
              PositionedDirectional(
                bottom: 14,
                start: 14,
                end: 14,
                child: Row(
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(
                        dimension: 38,
                        child: Icon(
                          CupertinoIcons.play_fill,
                          color: RRColors.brandInk,
                          size: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: RRTypography.headline.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: RRTypography.caption.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    DurationBadge(seconds: asset.duration),
                  ],
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
        ref.watch(_homeTitleProvider(asset)).valueOrNull ??
        l10n.videoFallbackTitle;
    final locale = Localizations.localeOf(context).toString();

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _VideoCover(asset: asset),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: RRTypography.headline.copyWith(
                color: _homeTextColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat.yMMMd(locale).format(asset.createDateTime),
              style: _homeCaption,
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoCover extends ConsumerWidget {
  const _VideoCover({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(_homeThumbnailProvider(asset)).valueOrNull;
    const placeholder = ColoredBox(
      color: RRColors.brandInk,
      child: Center(
        child: Icon(CupertinoIcons.film, size: 28, color: Colors.white54),
      ),
    );

    return image == null
        ? placeholder
        : Image.memory(
            image,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            errorBuilder: (_, _, _) => placeholder,
          );
  }
}
