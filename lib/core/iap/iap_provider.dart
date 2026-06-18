import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kProductLifetime = 'com.rollreel.pro.lifetime';
const kProductMonthly = 'com.rollreel.plus.monthly';

// ─── is-pro provider ──────────────────────────────────────────────────────────

class _IsProNotifier extends StateNotifier<bool> {
  _IsProNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('is_pro') ?? false;
  }

  Future<void> setPro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro', value);
    state = value;
  }
}

final isProProvider =
    StateNotifierProvider<_IsProNotifier, bool>((ref) => _IsProNotifier());

// ─── IAP state ────────────────────────────────────────────────────────────────

class IAPState {
  const IAPState({
    this.available = false,
    this.loading = false,
    this.products = const {},
    this.error,
  });

  final bool available;
  final bool loading;
  final Map<String, ProductDetails> products;
  final String? error;

  IAPState copyWith({
    bool? available,
    bool? loading,
    Map<String, ProductDetails>? products,
    String? error,
    bool clearError = false,
  }) =>
      IAPState(
        available: available ?? this.available,
        loading: loading ?? this.loading,
        products: products ?? this.products,
        error: clearError ? null : (error ?? this.error),
      );
}

// ─── IAP notifier ─────────────────────────────────────────────────────────────

class IAPNotifier extends StateNotifier<IAPState> {
  IAPNotifier(this._ref) : super(const IAPState()) {
    _init();
  }

  final Ref _ref;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<void> _init() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      state = const IAPState(available: false);
      return;
    }

    _sub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object e) =>
          state = state.copyWith(loading: false, error: e.toString()),
    );

    final response = await InAppPurchase.instance
        .queryProductDetails({kProductLifetime, kProductMonthly});

    debugPrint(
        '[RollReel] IAP products found: ${response.productDetails.map((p) => p.id).toList()}, '
        'not found: ${response.notFoundIDs}, error: ${response.error}');

    state = IAPState(
      available: true,
      products: {for (final p in response.productDetails) p.id: p},
    );
  }

  Future<void> purchase(String productId) async {
    final product = state.products[productId];
    if (product == null) {
      debugPrint('[RollReel] purchase() called for $productId but product not found');
      return;
    }
    state = state.copyWith(loading: true, clearError: true);
    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restore() async {
    state = state.copyWith(loading: true, clearError: true);
    await InAppPurchase.instance.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _ref.read(isProProvider.notifier).setPro(true);
          await InAppPurchase.instance.completePurchase(purchase);
        case PurchaseStatus.error:
          state = state.copyWith(
            loading: false,
            error: purchase.error?.message ?? 'Purchase failed',
          );
        case PurchaseStatus.canceled:
          state = state.copyWith(loading: false, clearError: true);
        case PurchaseStatus.pending:
          break;
      }
    }
    if (purchases.every((p) =>
        p.status == PurchaseStatus.purchased ||
        p.status == PurchaseStatus.restored ||
        p.status == PurchaseStatus.canceled ||
        p.status == PurchaseStatus.error)) {
      state = state.copyWith(loading: false);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final iapProvider =
    StateNotifierProvider<IAPNotifier, IAPState>((ref) => IAPNotifier(ref));
