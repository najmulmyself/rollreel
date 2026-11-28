import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../permissions/permission_provider.dart';
import '../vault/vault_provider.dart';
import '../video/video_library_provider.dart';

const _kFavoritesIds = 'favorites_ids';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {}) {
    ready = _load();
  }

  late final Future<void> ready;
  Future<void> _writes = Future.value();

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) state = (prefs.getStringList(_kFavoritesIds) ?? []).toSet();
  }

  Future<void> toggle(String assetId) async {
    try {
      await _update((ids) {
        if (!ids.remove(assetId)) ids.add(assetId);
      });
    } catch (error) {
      debugPrint('Could not update Favorites: $error');
    }
  }

  Future<void> setFavorite(String assetId, bool favorite, {int? index}) =>
      _update((ids) {
        if (!favorite) {
          ids.remove(assetId);
        } else if (index == null || ids.contains(assetId)) {
          ids.add(assetId);
        } else {
          final ordered = ids.toList();
          ordered.insert(index.clamp(0, ordered.length), assetId);
          ids
            ..clear()
            ..addAll(ordered);
        }
      });

  bool contains(String assetId) => state.contains(assetId);

  Future<void> _update(void Function(Set<String>) change) {
    // One write at a time keeps quick taps and Undo in order.
    final write = _writes.then((_) async {
      await ready;
      if (!mounted) return;
      final previous = state;
      final next = {...previous};
      change(next);
      if (setEquals(previous, next)) return;
      state = next;
      try {
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setStringList(_kFavoritesIds, next.toList())) {
          throw StateError('Could not save Favorites');
        }
      } catch (_) {
        if (mounted) state = previous;
        rethrow;
      }
    });
    _writes = write.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return write;
  }
}

final favoritesIdsProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
      (ref) => FavoritesNotifier(),
    );

final favoriteAssetsProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final favorites = ref.watch(favoritesIdsProvider.notifier);
  final ids = ref.watch(favoritesIdsProvider);
  final permission = ref.watch(permissionProvider).valueOrNull;
  final vault = ref.watch(vaultIdsProvider.notifier);
  ref.watch(vaultIdsProvider);
  final library = ids.isNotEmpty && permission?.hasAccess == true
      ? ref.watch(videoLibraryProvider).valueOrNull
      : null;
  await favorites.ready;
  if (ids.isEmpty || permission?.hasAccess != true) return [];
  await vault.ready;

  final known = {
    for (final asset in library ?? const <AssetEntity>[])
      if (ids.contains(asset.id)) asset.id: asset,
  };
  // Saved videos outside the current library page remain available by ID.
  final assets = await Future.wait(
    ids
        .where((id) => !vault.contains(id))
        .map((id) async => known[id] ?? await AssetEntity.fromId(id)),
  );
  return assets.whereType<AssetEntity>().toList();
});
