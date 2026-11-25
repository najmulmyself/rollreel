import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../settings/settings_provider.dart';
import '../vault/vault_provider.dart';

// ─── Filter enums & model ────────────────────────────────────────────────────

enum VideoTimePeriod { all, today, thisWeek, thisMonth, y2026, y2025, y2024 }

enum VideoDurationFilter {
  any,
  short, // < 60 s
  medium, // 60 – 300 s
  long, // > 300 s
}

enum VideoSortOrder { newest, oldest, shortest, longest }

class BrowseFilter {
  final VideoTimePeriod period;
  final VideoDurationFilter duration;
  final VideoSortOrder sort;

  const BrowseFilter({
    this.period = VideoTimePeriod.all,
    this.duration = VideoDurationFilter.any,
    this.sort = VideoSortOrder.newest,
  });

  BrowseFilter copyWith({
    VideoTimePeriod? period,
    VideoDurationFilter? duration,
    VideoSortOrder? sort,
  }) => BrowseFilter(
    period: period ?? this.period,
    duration: duration ?? this.duration,
    sort: sort ?? this.sort,
  );
}

// ─── Providers ───────────────────────────────────────────────────────────────

final browseFilterProvider = StateProvider<BrowseFilter>(
  (ref) => const BrowseFilter(),
);

Future<List<AssetEntity>> _fetchVideos({bool loadTitles = false}) async {
  final paths = await PhotoManager.getAssetPathList(
    type: RequestType.video,
    onlyAll: true,
    filterOption: loadTitles
        ? FilterOptionGroup(videoOption: const FilterOption(needTitle: true))
        : null,
  );
  if (paths.isEmpty) return [];
  return paths.first.getAssetListRange(start: 0, end: 9999);
}

/// Returns ALL videos from the device library (no filter applied).
final videoLibraryProvider = FutureProvider<List<AssetEntity>>((ref) async {
  try {
    // Right after the OS permission dialog is granted on a fresh install,
    // PhotoManager's asset fetch can keep returning an empty list for a
    // few seconds while the Photos library finishes syncing/indexing
    // internally — poll a few times with backoff instead of giving up
    // and showing "no videos" until the app is restarted.
    const delays = [
      Duration(milliseconds: 500),
      Duration(milliseconds: 1000),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ];
    var result = await _fetchVideos();
    for (final delay in delays) {
      if (result.isNotEmpty) break;
      await Future.delayed(delay);
      await PhotoManager.clearFileCache();
      result = await _fetchVideos();
    }
    return result;
  } catch (e) {
    debugPrint('Video library error: $e');
    rethrow;
  }
});

/// Drives cross-tab Browse → Feed navigation. Set to an asset ID to jump there.
final feedJumpToAssetProvider = StateProvider<String?>((ref) => null);

/// Share the same vault exclusion across public video surfaces.
final visibleVideosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final library = ref.watch(videoLibraryProvider.future);
  final vault = ref.watch(vaultIdsProvider.notifier);
  ref.watch(vaultIdsProvider);
  await vault.ready;
  return (await library).where((asset) => !vault.contains(asset.id)).toList();
});

/// Active quick-filter for the feed screen.
final feedFilterProvider = StateProvider<FeedFilter>((ref) => FeedFilter.all);

/// Returns all videos excluding those in the vault, filtered by [feedFilterProvider].
final feedVideosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final feedFilter = ref.watch(feedFilterProvider);
  Iterable<AssetEntity> result = await ref.watch(visibleVideosProvider.future);

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  switch (feedFilter) {
    case FeedFilter.all:
      break;
    case FeedFilter.today:
      result = result.where((a) {
        final d = DateTime(
          a.createDateTime.year,
          a.createDateTime.month,
          a.createDateTime.day,
        );
        return d == todayStart;
      });
    case FeedFilter.shorts:
      result = result.where((a) => a.duration < 60);
    case FeedFilter.long:
      result = result.where((a) => a.duration >= 60);
  }

  return result.toList();
});

/// Apple Photos omits filenames from its ordinary library query. Load them
/// together when a search needs them, keeping the first library load lightweight.
final browseVideoTitlesProvider =
    FutureProvider.autoDispose<Map<String, String>>((ref) async {
      final visible = await ref.watch(visibleVideosProvider.future);
      final visibleIds = visible.map((video) => video.id).toSet();
      final titled = await _fetchVideos(loadTitles: true);
      return {
        for (final video in titled)
          if (visibleIds.contains(video.id))
            if (video.title case final title?) video.id: title,
      };
    });

/// Returns the filtered + sorted subset of [videoLibraryProvider] excluding vault.
final browseVideosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  try {
    final filter = ref.watch(browseFilterProvider);
    Iterable<AssetEntity> result = await ref.watch(
      visibleVideosProvider.future,
    );

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // ── Period filter ────────────────────────────────────────────────────────

    switch (filter.period) {
      case VideoTimePeriod.all:
        break;
      case VideoTimePeriod.today:
        result = result.where((a) {
          final d = DateTime(
            a.createDateTime.year,
            a.createDateTime.month,
            a.createDateTime.day,
          );
          return d == todayStart;
        });
      case VideoTimePeriod.thisWeek:
        final weekAgo = now.subtract(const Duration(days: 7));
        result = result.where((a) => a.createDateTime.isAfter(weekAgo));
      case VideoTimePeriod.thisMonth:
        result = result.where(
          (a) =>
              a.createDateTime.year == now.year &&
              a.createDateTime.month == now.month,
        );
      case VideoTimePeriod.y2026:
        result = result.where((a) => a.createDateTime.year == 2026);
      case VideoTimePeriod.y2025:
        result = result.where((a) => a.createDateTime.year == 2025);
      case VideoTimePeriod.y2024:
        result = result.where((a) => a.createDateTime.year == 2024);
    }

    // ── Duration filter ──────────────────────────────────────────────────────
    switch (filter.duration) {
      case VideoDurationFilter.any:
        break;
      case VideoDurationFilter.short:
        result = result.where((a) => a.duration < 60);
      case VideoDurationFilter.medium:
        result = result.where((a) => a.duration >= 60 && a.duration <= 300);
      case VideoDurationFilter.long:
        result = result.where((a) => a.duration > 300);
    }

    // ── Sort ─────────────────────────────────────────────────────────────────
    final list = result.toList();

    switch (filter.sort) {
      case VideoSortOrder.newest:
        list.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
      case VideoSortOrder.oldest:
        list.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
      case VideoSortOrder.shortest:
        list.sort((a, b) => a.duration.compareTo(b.duration));
      case VideoSortOrder.longest:
        list.sort((a, b) => b.duration.compareTo(a.duration));
    }

    return list;
  } catch (e) {
    debugPrint('Browse videos error: $e');
    rethrow;
  }
});

// ─── Thumbnail ───────────────────────────────────────────────────────────────

final thumbnailProvider = FutureProvider.family<Uint8List?, String>((
  ref,
  assetId,
) async {
  try {
    final assets = await ref.watch(videoLibraryProvider.future);
    final asset = assets.where((a) => a.id == assetId).firstOrNull;
    if (asset == null) return null;
    return asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
  } catch (e) {
    debugPrint('Thumbnail load error: $e');
    return null;
  }
});
