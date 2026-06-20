import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../settings/settings_provider.dart';
import '../vault/vault_provider.dart';

// ─── Filter enums & model ────────────────────────────────────────────────────

enum VideoTimePeriod { all, today, thisWeek, thisMonth, y2026, y2025, y2024 }

enum VideoDurationFilter {
  any,
  short,   // < 60 s
  medium,  // 60 – 300 s
  long,    // > 300 s
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
  }) =>
      BrowseFilter(
        period: period ?? this.period,
        duration: duration ?? this.duration,
        sort: sort ?? this.sort,
      );
}

// ─── Providers ───────────────────────────────────────────────────────────────

final browseFilterProvider =
    StateProvider<BrowseFilter>((ref) => const BrowseFilter());

Future<List<AssetEntity>> _fetchVideos() async {
  final paths = await PhotoManager.getAssetPathList(
    type: RequestType.video,
    onlyAll: true,
  );
  if (paths.isEmpty) return [];
  return paths.first.getAssetListRange(start: 0, end: 9999);
}

/// Returns ALL videos from the device library (no filter applied).
final videoLibraryProvider = FutureProvider<List<AssetEntity>>((ref) async {
  try {
    final result = await _fetchVideos();
    // Right after the OS permission dialog is granted on a fresh install,
    // PhotoManager's asset fetch can momentarily return an empty list
    // before the Photos library finishes syncing internally — retry once
    // after a short delay rather than showing "no videos" until restart.
    if (result.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 800));
      return _fetchVideos();
    }
    return result;
  } catch (e) {
    debugPrint('Video library error: $e');
    return [];
  }
});

/// Drives cross-tab Browse → Feed navigation. Set to an asset ID to jump there.
final feedJumpToAssetProvider = StateProvider<String?>((ref) => null);

/// Active quick-filter for the feed screen.
final feedFilterProvider = StateProvider<FeedFilter>((ref) => FeedFilter.all);

/// Returns all videos excluding those in the vault, filtered by [feedFilterProvider].
final feedVideosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final all = await ref.watch(videoLibraryProvider.future);
  final vaultIds = ref.watch(vaultIdsProvider);
  final feedFilter = ref.watch(feedFilterProvider);

  Iterable<AssetEntity> result =
      vaultIds.isEmpty ? all : all.where((a) => !vaultIds.contains(a.id));

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  switch (feedFilter) {
    case FeedFilter.all:
      break;
    case FeedFilter.today:
      result = result.where((a) {
        final d = DateTime(
            a.createDateTime.year, a.createDateTime.month, a.createDateTime.day);
        return d == todayStart;
      });
    case FeedFilter.shorts:
      result = result.where((a) => a.duration < 60);
    case FeedFilter.long:
      result = result.where((a) => a.duration >= 60);
  }

  return result.toList();
});

/// Returns the filtered + sorted subset of [videoLibraryProvider] excluding vault.
final browseVideosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  try {
    final all = await ref.watch(videoLibraryProvider.future);
    final filter = ref.watch(browseFilterProvider);
    final vaultIds = ref.watch(vaultIdsProvider);

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // ── Vault filter ─────────────────────────────────────────────────────────
    Iterable<AssetEntity> result =
        vaultIds.isEmpty ? all : all.where((a) => !vaultIds.contains(a.id));

    // ── Period filter ────────────────────────────────────────────────────────

    switch (filter.period) {
      case VideoTimePeriod.all:
        break;
      case VideoTimePeriod.today:
        result = result.where((a) {
          final d = DateTime(
              a.createDateTime.year, a.createDateTime.month, a.createDateTime.day);
          return d == todayStart;
        });
      case VideoTimePeriod.thisWeek:
        final weekAgo = now.subtract(const Duration(days: 7));
        result = result.where((a) => a.createDateTime.isAfter(weekAgo));
      case VideoTimePeriod.thisMonth:
        result = result.where((a) =>
            a.createDateTime.year == now.year &&
            a.createDateTime.month == now.month);
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
    return [];
  }
});

// ─── Thumbnail ───────────────────────────────────────────────────────────────

final thumbnailProvider =
    FutureProvider.family<Uint8List?, String>((ref, assetId) async {
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
