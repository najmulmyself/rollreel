import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../vault/vault_provider.dart';
import '../video/video_library_provider.dart';

/// Videos taken on today's month/day in previous years, newest year first.
/// Vault-hidden videos are excluded, same as the feed.
final onThisDayProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final all = await ref.watch(videoLibraryProvider.future);
  final vaultIds = ref.watch(vaultIdsProvider);
  final now = DateTime.now();

  final matches = all.where((a) {
    final d = a.createDateTime;
    return d.month == now.month &&
        d.day == now.day &&
        d.year < now.year &&
        !vaultIds.contains(a.id);
  }).toList()
    ..sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

  return matches;
});
