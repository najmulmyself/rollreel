import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kVaultIds = 'vault_ids';

class VaultNotifier extends StateNotifier<Set<String>> {
  VaultNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getStringList(_kVaultIds) ?? []).toSet();
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
    await prefs.setStringList(_kVaultIds, state.toList());
  }
}

final vaultIdsProvider =
    StateNotifierProvider<VaultNotifier, Set<String>>((ref) => VaultNotifier());

/// Resolves vaulted asset IDs to actual AssetEntities for display in the vault.
final vaultAssetsProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final ids = ref.watch(vaultIdsProvider);
  if (ids.isEmpty) return [];
  final results = await Future.wait(ids.map(AssetEntity.fromId));
  return results.whereType<AssetEntity>().toList();
});
