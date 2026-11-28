import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/duration_badge.dart';

Color get librarySurface => RRColors.bgSurface;
Color get libraryHeader =>
    RRColors.isDark.value ? RRColors.bgDeep : const Color(0xFFF4FAFF);
Color get libraryTint =>
    RRColors.isDark.value ? const Color(0xFF172D40) : const Color(0xFFEAF6FB);
Color get libraryLine =>
    RRColors.isDark.value ? RRColors.divider : const Color(0xFFE1E9EF);
Color get libraryInk =>
    RRColors.isDark.value ? RRColors.textPrimary : RRColors.brandInk;
Color get libraryMuted =>
    RRColors.isDark.value ? RRColors.textSecond : RRColors.brandMutedInk;
Color get libraryAccent =>
    RRColors.isDark.value ? const Color(0xFFA7DEFF) : RRColors.brandBlue;
Color get libraryOnAccent =>
    RRColors.isDark.value ? RRColors.brandInk : Colors.white;
Color get libraryDanger =>
    RRColors.isDark.value ? const Color(0xFFFFADB8) : const Color(0xFFB32A43);

TextStyle get libraryBody => RRTypography.body.copyWith(color: libraryInk);
TextStyle get libraryNote => RRTypography.caption.copyWith(color: libraryMuted);
TextStyle get libraryHeading => RRTypography.title2.copyWith(
  color: libraryInk,
  fontWeight: FontWeight.w700,
);

String libraryPeriodLabel(AppLocalizations l10n, VideoTimePeriod period) =>
    switch (period) {
      VideoTimePeriod.all => l10n.filterAll,
      VideoTimePeriod.today => l10n.filterToday,
      VideoTimePeriod.thisWeek => l10n.thisWeek,
      VideoTimePeriod.thisMonth => l10n.thisMonth,
      VideoTimePeriod.y2026 => '2026',
      VideoTimePeriod.y2025 => '2025',
      VideoTimePeriod.y2024 => '2024',
    };

String libraryDurationLabel(
  AppLocalizations l10n,
  VideoDurationFilter length,
) => switch (length) {
  VideoDurationFilter.any => l10n.any,
  VideoDurationFilter.short => l10n.durationShort,
  VideoDurationFilter.medium => l10n.durationMedium,
  VideoDurationFilter.long => l10n.durationLong,
};

String librarySortLabel(AppLocalizations l10n, VideoSortOrder sort) =>
    switch (sort) {
      VideoSortOrder.newest => l10n.newestFirst,
      VideoSortOrder.oldest => l10n.oldestFirst,
      VideoSortOrder.shortest => l10n.shortestFirst,
      VideoSortOrder.longest => l10n.longestFirst,
    };

Future<T?> showLibrarySheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: librarySurface,
      barrierColor: const Color(0x6B0C2337),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 7),
              width: 34,
              height: 4,
              decoration: BoxDecoration(
                color: RRColors.isDark.value
                    ? const Color(0xFF61758B)
                    : const Color(0xFFC5D6E2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Flexible(child: builder(sheetContext)),
        ],
      ),
    );

class LibraryChip extends StatelessWidget {
  const LibraryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.inSheet = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final bool inSheet;

  @override
  Widget build(BuildContext context) {
    final solid = selected && !inSheet;
    return Semantics(
      selected: selected,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(44, 38),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          visualDensity: VisualDensity.standard,
          backgroundColor: solid
              ? libraryAccent
              : inSheet
              ? libraryTint
              : librarySurface,
          foregroundColor: solid
              ? libraryOnAccent
              : selected
              ? libraryAccent
              : libraryMuted,
          side: BorderSide(color: selected ? libraryAccent : libraryLine),
          textStyle: RRTypography.subheadline.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (inSheet && selected) ...[
              const Icon(CupertinoIcons.check_mark, size: 11),
              const SizedBox(width: 4),
            ],
            Flexible(child: Text(label)),
          ],
        ),
      ),
    );
  }
}

final libraryTitleProvider = FutureProvider.autoDispose
    .family<String?, AssetEntity>((ref, asset) async {
      final name = asset.title?.trim();
      if (name != null && name.isNotEmpty) return name;
      try {
        final loaded = (await asset.titleAsync).trim();
        return loaded.isEmpty ? null : loaded;
      } on Exception {
        return null;
      }
    });

final _libraryThumbnailProvider = FutureProvider.autoDispose
    .family<Uint8List?, (AssetEntity, ThumbnailSize)>((ref, request) async {
      final (asset, size) = request;
      try {
        return await asset.thumbnailDataWithSize(size);
      } on Exception {
        return null;
      }
    });

class LibraryThumbnail extends ConsumerWidget {
  const LibraryThumbnail({
    super.key,
    required this.asset,
    this.width = 94,
    this.height = 59,
    this.showDuration = false,
    this.radius = 9,
    this.thumbnailSize = const ThumbnailSize(282, 177),
  });

  final AssetEntity asset;
  final double width;
  final double height;
  final bool showDuration;
  final double radius;
  final ThumbnailSize thumbnailSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytes = ref
        .watch(_libraryThumbnailProvider((asset, thumbnailSize)))
        .valueOrNull;
    final placeholder = ColoredBox(
      color: libraryTint,
      child: Icon(CupertinoIcons.film, size: 18, color: libraryMuted),
    );
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (bytes != null)
                Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                )
              else
                placeholder,
              if (showDuration)
                PositionedDirectional(
                  bottom: 3,
                  end: 3,
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.4,
                    child: DurationBadge(seconds: asset.duration),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryVideoRow extends ConsumerWidget {
  const LibraryVideoRow({
    super.key,
    required this.asset,
    required this.dateLabel,
    required this.onOptions,
    required this.onPlay,
    required this.showDivider,
  });

  final AssetEntity asset;
  final String dateLabel;
  final ValueChanged<String> onOptions;
  final VoidCallback? onPlay;
  final bool showDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        ref.watch(libraryTitleProvider(asset)).valueOrNull ??
        asset.title ??
        l10n.videoFallbackTitle;
    final name = title.trim().isEmpty ? l10n.videoFallbackTitle : title;
    final minutes = asset.duration ~/ 60;
    final seconds = (asset.duration % 60).toString().padLeft(2, '0');
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: libraryLine))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPlay,
              onLongPress: () => onOptions(name),
              borderRadius: BorderRadius.circular(9),
              child: Semantics(
                label: l10n.libraryVideoRow(
                  name,
                  dateLabel,
                  '$minutes:$seconds',
                ),
                excludeSemantics: true,
                button: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      LibraryThumbnail(asset: asset, showDuration: true),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: RRTypography.headline.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: libraryInk,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(dateLabel, style: libraryNote),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.libraryVideoOptions(name),
            onPressed: () => onOptions(name),
            color: libraryAccent,
            iconSize: 18,
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            icon: const Icon(CupertinoIcons.ellipsis),
          ),
        ],
      ),
    );
  }
}

class LibraryMessage extends StatelessWidget {
  const LibraryMessage({
    super.key,
    required this.title,
    required this.description,
    this.action,
    this.onPressed,
    this.icon,
  });

  final String title;
  final String description;
  final String? action;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topStart,
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(11, 31, 11, 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon case final symbol?)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: libraryTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(symbol, size: 24, color: libraryAccent),
              )
            else
              Image.asset(
                'assets/images/home_kingfisher.webp',
                width: 70,
                excludeFromSemantics: true,
              ),
            const SizedBox(height: 14),
            Semantics(
              header: true,
              child: Text(title, style: libraryHeading.copyWith(fontSize: 25)),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: libraryBody.copyWith(color: libraryMuted, fontSize: 15),
            ),
            if (action case final label?) ...[
              const SizedBox(height: 5),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: libraryAccent,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  alignment: AlignmentDirectional.centerStart,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
