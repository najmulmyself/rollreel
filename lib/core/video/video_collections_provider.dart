import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../vault/vault_provider.dart';
import 'video_library_provider.dart';

typedef VideoCollection = ({String name, int count});

final topVideoCollectionsProvider =
    FutureProvider.autoDispose<List<VideoCollection>>((ref) async {
      final library = ref.watch(videoLibraryProvider.future);
      final vault = ref.watch(vaultIdsProvider.notifier);
      final hiddenIds = ref.watch(vaultIdsProvider);
      await vault.ready;
      await library;

      final paths = await PhotoManager.getAssetPathList(
        hasAll: false,
        type: RequestType.video,
        pathFilterOption: const PMPathFilter(
          darwin: PMDarwinPathFilter(
            subType: [
              PMDarwinAssetCollectionSubtype.albumRegular,
              PMDarwinAssetCollectionSubtype.albumSyncedAlbum,
              PMDarwinAssetCollectionSubtype.albumImported,
              PMDarwinAssetCollectionSubtype.albumCloudShared,
              PMDarwinAssetCollectionSubtype.smartAlbumVideos,
            ],
          ),
        ),
      );

      final ranked = <VideoCollection>[];
      AssetPathEntity? videosAlbum;
      for (final path in paths) {
        if (path.isAll || path.albumType != 1) continue;
        if (path.albumTypeEx?.darwin?.subtype ==
            PMDarwinAssetCollectionSubtype.smartAlbumVideos) {
          videosAlbum = path;
          continue;
        }
        final count = await _visibleCount(path, hiddenIds);
        if (count > 0) ranked.add((name: path.name, count: count));
      }
      // Use Photos' own Videos album when no smaller albums contain visible clips.
      if (ranked.isEmpty && videosAlbum != null) {
        final count = await _visibleCount(videosAlbum, hiddenIds);
        if (count > 0) ranked.add((name: videosAlbum.name, count: count));
      }

      ranked.sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.name.compareTo(b.name);
      });
      return ranked.take(3).toList();
    });

Future<int> _visibleCount(AssetPathEntity path, Set<String> hiddenIds) async {
  final count = await path.assetCountAsync;
  if (hiddenIds.isEmpty) return count;

  const pageSize = 500;
  var visible = 0;
  for (var page = 0; page * pageSize < count; page++) {
    final assets = await path.getAssetListPaged(page: page, size: pageSize);
    visible += assets.where((video) => !hiddenIds.contains(video.id)).length;
  }
  return visible;
}
