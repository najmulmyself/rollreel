import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

enum VideoFilter { all, today, shorts, long, recent }

final videoFilterProvider = StateProvider<VideoFilter>((ref) => VideoFilter.all);

final videoLibraryProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final filter = ref.watch(videoFilterProvider);

  try {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      onlyAll: true,
    );

    if (paths.isEmpty) return [];

    final all = await paths.first.getAssetListRange(start: 0, end: 9999);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  switch (filter) {
    case VideoFilter.all:
      return all;
    case VideoFilter.today:
      return all.where((a) {
        final d = DateTime(a.createDateTime.year, a.createDateTime.month, a.createDateTime.day);
        return d == today;
      }).toList();
    case VideoFilter.shorts:
      return all.where((a) => a.duration < 60).toList();
    case VideoFilter.long:
      return all.where((a) => a.duration >= 60).toList();
    case VideoFilter.recent:
      final weekAgo = now.subtract(const Duration(days: 7));
      return all.where((a) => a.createDateTime.isAfter(weekAgo)).toList();
  }
  } catch (e) {
    debugPrint('Video library error: $e');
    return [];
  }
});

final thumbnailProvider = FutureProvider.family<Uint8List?, String>((ref, assetId) async {
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
