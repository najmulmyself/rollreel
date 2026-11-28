import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../iap/pro_entitlement.dart';

const _kVaultIds = 'vault_ids';

class VaultNotifier extends StateNotifier<Set<String>> {
  VaultNotifier(this._ref) : super(const {}) {
    ready = _load();
  }

  final Ref _ref;
  late final Future<void> ready;
  Future<void> _pending = Future.value();

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) state = (prefs.getStringList(_kVaultIds) ?? []).toSet();
  }

  /// False means adding the clip requires an active Pro entitlement.
  Future<bool> add(String assetId) async {
    await _ref.read(isProProvider.notifier).ready;
    return _change((ids) {
      if (!_ref.read(isProProvider)) return null;
      return ids.contains(assetId) ? ids : {...ids, assetId};
    });
  }

  Future<void> remove(String assetId) async {
    await _change(
      (ids) => ids.contains(assetId) ? ({...ids}..remove(assetId)) : ids,
    );
  }

  Future<void> restoreAll() async {
    await _change((ids) => ids.isEmpty ? ids : const {});
  }

  bool contains(String assetId) => state.contains(assetId);

  Future<bool> _change(Set<String>? Function(Set<String>) update) {
    final operation = _pending.then((_) async {
      await ready;
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return false;
      final next = update(state);
      if (next == null) return false;
      if (identical(next, state)) return true;
      if (!await prefs.setStringList(_kVaultIds, next.toList())) {
        throw StateError('Vault changes could not be saved');
      }
      if (mounted) state = next;
      return true;
    });
    _pending = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }
}

final vaultIdsProvider = StateNotifierProvider<VaultNotifier, Set<String>>(
  (ref) => VaultNotifier(ref),
);

/// Resolves vaulted asset IDs to actual AssetEntities for display in the vault.
final vaultAssetsProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final ids = ref.watch(vaultIdsProvider);
  if (ids.isEmpty) return [];
  final results = await Future.wait(ids.map(AssetEntity.fromId));
  return results.whereType<AssetEntity>().toList();
});
