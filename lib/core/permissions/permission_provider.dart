import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final permissionProvider = StateNotifierProvider<PermissionNotifier, AsyncValue<PermissionState>>((ref) {
  return PermissionNotifier();
});

class PermissionNotifier extends StateNotifier<AsyncValue<PermissionState>> {
  PermissionNotifier() : super(const AsyncValue.loading()) {
    _check();
  }

  Future<void> _check() async {
    try {
      // Check current state without prompting
      final result = await PhotoManager.requestPermissionExtend();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<PermissionState> request() async {
    state = const AsyncValue.loading();
    try {
      final result = await PhotoManager.requestPermissionExtend();
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
