import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kProductLifetime = 'com.rollreel.pro.lifetime';
const kProductMonthly = 'com.rollreel.plus.monthly';

const _legacyKey = 'is_pro';
const _snapshotKey = 'storekit_pro_entitlements';
const _retryInterval = Duration(minutes: 1);
const _channel = MethodChannel('rollreel/storekit_entitlements');

class _StoreKitSnapshot {
  const _StoreKitSnapshot({
    this.lifetime = false,
    this.monthlyActive = false,
    this.monthlyExpiresAt,
  });

  factory _StoreKitSnapshot.fromMap(Map<Object?, Object?> map) {
    final expiration = map['monthlyExpirationMs'] as int?;
    return _StoreKitSnapshot(
      lifetime: map['lifetime'] as bool,
      monthlyActive: map['monthlyActive'] as bool,
      monthlyExpiresAt: expiration == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(expiration, isUtc: true),
    );
  }

  final bool lifetime;
  final bool monthlyActive;
  final DateTime? monthlyExpiresAt;

  bool isActiveInCache(DateTime now) =>
      lifetime || (monthlyActive && (monthlyExpiresAt?.isAfter(now) ?? false));

  Map<String, Object?> toMap() => {
    'lifetime': lifetime,
    'monthlyActive': monthlyActive,
    'monthlyExpirationMs': monthlyExpiresAt?.millisecondsSinceEpoch,
  };
}

bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

class ProEntitlementNotifier extends StateNotifier<bool> {
  ProEntitlementNotifier() : super(false) {
    ready = _loadCache();
  }

  late final Future<void> ready;
  Future<bool>? _storeKit2Support;

  _StoreKitSnapshot _snapshot = const _StoreKitSnapshot();
  Timer? _nextCheck;
  Future<void>? _refreshInFlight;

  Future<bool> get canSellMonthly async {
    if (!_isIOS) return true;
    try {
      return await _supportsStoreKit2();
    } on PlatformException catch (error) {
      debugPrint('[RollReel] StoreKit capability unavailable: $error');
      return false;
    } on MissingPluginException {
      debugPrint('[RollReel] Native StoreKit entitlement channel is missing.');
      return false;
    }
  }

  Future<bool> _supportsStoreKit2() {
    if (!_isIOS) return Future.value(false);
    return _storeKit2Support ??= _probeStoreKit2();
  }

  Future<bool> _probeStoreKit2() async {
    try {
      final supported = await _channel.invokeMethod<bool>('isSupported');
      if (supported == null) {
        throw PlatformException(code: 'storekit_capability_unavailable');
      }
      return supported;
    } catch (_) {
      // Retry transient channel failures. A real unsupported OS can be cached.
      _storeKit2Support = null;
      rethrow;
    }
  }

  Future<void> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cache = prefs.getString(_snapshotKey);
      if (cache != null && _isIOS) {
        _snapshot = _StoreKitSnapshot.fromMap(
          jsonDecode(cache) as Map<String, dynamic>,
        );
      }
      final legacy = prefs.getBool(_legacyKey) ?? false;
      if (mounted)
        state = _isIOS ? _snapshot.isActiveInCache(DateTime.now()) : legacy;
      // StoreKit 1 on older iOS versions cannot supply a verified snapshot.
      if (_isIOS && !await _supportsStoreKit2() && mounted) {
        state = _snapshot.isActiveInCache(DateTime.now()) || legacy;
      }
    } catch (error) {
      debugPrint('[RollReel] Pro cache could not load: $error');
    }
  }

  Future<void> refresh() async {
    try {
      await _readCurrentEntitlements();
    } catch (error) {
      debugPrint('[RollReel] StoreKit entitlement refresh failed: $error');
    }
  }

  Future<bool> restoreFromStoreKit() async {
    if (!await _supportsStoreKit2()) return false;
    await _channel.invokeMethod<void>('sync');
    await _readAfterStoreChange();
    return true;
  }

  Future<void> _readAfterStoreChange() async {
    final earlier = _refreshInFlight;
    if (earlier != null) {
      try {
        await earlier;
      } catch (_) {
        // A fresh lookup can recover a failed background lookup.
      }
    }
    await _readCurrentEntitlements();
  }

  Future<void> applyPurchase(String productId) async {
    await ready;
    if (await _supportsStoreKit2()) {
      // A StoreKit update also arrives for revocations. Re-read the current
      // entitlements instead of treating the transaction as a new grant.
      await _readAfterStoreChange();
    } else if (productId == kProductLifetime || !_isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_legacyKey, true);
      if (mounted) state = true;
    }
  }

  Future<void> _readCurrentEntitlements() {
    return _refreshInFlight ??= _reconcile().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _reconcile() async {
    await ready;
    if (!mounted) return;
    try {
      if (!await _supportsStoreKit2()) return;
      final values = await _channel.invokeMapMethod<Object?, Object?>(
        'currentEntitlements',
      );
      if (values == null)
        throw StateError('StoreKit returned no entitlement snapshot');
      final snapshot = _StoreKitSnapshot.fromMap(values);
      if (!mounted) return;
      _snapshot = snapshot;
      state = snapshot.lifetime || snapshot.monthlyActive;
      final expiry = snapshot.monthlyExpiresAt;
      final untilExpiry = expiry?.difference(DateTime.now());
      _nextCheck?.cancel();
      if (snapshot.monthlyActive) {
        // StoreKit can continue to report access in a billing grace period.
        _schedule(
          untilExpiry != null && untilExpiry > Duration.zero
              ? untilExpiry
              : _retryInterval,
        );
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_snapshotKey, jsonEncode(snapshot.toMap()));
      } catch (error) {
        debugPrint('[RollReel] Pro snapshot could not be saved: $error');
      }
    } catch (_) {
      if (mounted) {
        final now = DateTime.now();
        state = _snapshot.isActiveInCache(now);
        final untilExpiry = _snapshot.monthlyExpiresAt?.difference(now);
        _schedule(
          untilExpiry != null &&
                  untilExpiry > Duration.zero &&
                  untilExpiry < _retryInterval
              ? untilExpiry
              : _retryInterval,
        );
      }
      rethrow;
    }
  }

  void _schedule(Duration delay) {
    _nextCheck?.cancel();
    _nextCheck = Timer(delay, () async {
      final earlier = _refreshInFlight;
      if (earlier != null) {
        try {
          await earlier;
        } catch (_) {
          // The timer retries after any in-flight request has settled.
        }
      }
      if (mounted) await refresh();
    });
  }

  @override
  void dispose() {
    _nextCheck?.cancel();
    super.dispose();
  }
}

final isProProvider = StateNotifierProvider<ProEntitlementNotifier, bool>(
  (_) => ProEntitlementNotifier(),
);
