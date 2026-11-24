import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../video/video_library_provider.dart';

/// Videos taken on today's month/day in previous years, newest year first.
/// Vault-hidden videos are excluded, same as the feed.
final onThisDayProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final all = await ref.watch(visibleVideosProvider.future);
  final now = DateTime.now();

  final matches = all.where((a) {
    if (a.createDateSecond == null) return false;
    final d = a.createDateTime;
    return d.month == now.month && d.day == now.day && d.year < now.year;
  }).toList()..sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

  return matches;
});
