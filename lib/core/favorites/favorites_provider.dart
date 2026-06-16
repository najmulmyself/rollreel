import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFavoritesIds = 'favorites_ids';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getStringList(_kFavoritesIds) ?? []).toSet();
  }

  Future<void> toggle(String assetId) async {
    if (state.contains(assetId)) {
      state = {...state}..remove(assetId);
    } else {
      state = {...state, assetId};
    }
    await _persist();
  }

  bool contains(String assetId) => state.contains(assetId);

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesIds, state.toList());
  }
}

final favoritesIdsProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
        (ref) => FavoritesNotifier());

final favoriteAssetsProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final ids = ref.watch(favoritesIdsProvider);
  if (ids.isEmpty) return [];
  final results = await Future.wait(ids.map(AssetEntity.fromId));
  return results.whereType<AssetEntity>().toList();
});
