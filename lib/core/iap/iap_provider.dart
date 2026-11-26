import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'pro_entitlement.dart';

export 'pro_entitlement.dart'
    show isProProvider, kProductLifetime, kProductMonthly;

const _productIds = {kProductLifetime, kProductMonthly};

class IAPState {
  const IAPState({
    this.available = false,
    this.catalogLoading = false,
    this.loading = false,
    this.products = const {},
    this.error,
  });

  final bool available;
  final bool catalogLoading;
  final bool loading;
  final Map<String, ProductDetails> products;
  final String? error;

  IAPState copyWith({
    bool? available,
    bool? catalogLoading,
    bool? loading,
    Map<String, ProductDetails>? products,
    String? error,
    bool clearError = false,
  }) => IAPState(
    available: available ?? this.available,
    catalogLoading: catalogLoading ?? this.catalogLoading,
    loading: loading ?? this.loading,
    products: products ?? this.products,
    error: clearError ? null : (error ?? this.error),
  );
}

// ─── IAP notifier ─────────────────────────────────────────────────────────────

class IAPNotifier extends StateNotifier<IAPState> {
  IAPNotifier(this._ref) : super(const IAPState(catalogLoading: true)) {
    unawaited(refreshCatalog());
    unawaited(refreshEntitlements());
  }

  final Ref _ref;
  Future<void>? _catalogRequest;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  Future<void> _purchaseUpdates = Future.value();
  bool _restoring = false;

  Future<void> refreshCatalog() => _catalogRequest ??= _loadCatalog()
      .whenComplete(() => _catalogRequest = null);

  Future<void> refreshEntitlements() =>
      _ref.read(isProProvider.notifier).refresh();

  Future<void> _loadCatalog() async {
    state = state.copyWith(catalogLoading: true);
    try {
      final store = InAppPurchase.instance;
      final available = await store.isAvailable();
      if (!mounted) return;
      if (!available) {
        state = state.copyWith(available: false, products: const {});
        return;
      }
      _sub ??= store.purchaseStream.listen(
        (purchases) {
          _purchaseUpdates = _purchaseUpdates.then(
            (_) => _onPurchaseUpdate(purchases),
          );
        },
        onError: (Object error) {
          state = state.copyWith(loading: _restoring, error: error.toString());
        },
      );
      state = state.copyWith(available: true);
      final canSellMonthly = await _ref
          .read(isProProvider.notifier)
          .canSellMonthly;
      final response = await store.queryProductDetails(
        canSellMonthly ? _productIds : const {kProductLifetime},
      );
      debugPrint(
        '[RollReel] IAP products found: ${response.productDetails.map((p) => p.id).toList()}, '
        'not found: ${response.notFoundIDs}, error: ${response.error}',
      );
      if (!mounted) return;
      state = state.copyWith(
        products: {for (final p in response.productDetails) p.id: p},
      );
    } catch (error) {
      debugPrint('[RollReel] Store initialization failed: $error');
      if (mounted) state = state.copyWith(products: const {});
    } finally {
      if (mounted) state = state.copyWith(catalogLoading: false);
    }
  }

  Future<void> purchase(String productId) async {
    if (state.loading || state.catalogLoading) return;
    final product = state.products[productId];
    if (product == null) {
      debugPrint(
        '[RollReel] purchase() called for $productId but product not found',
      );
      state = state.copyWith(
        error: 'This plan isn\'t available right now. Please try again later.',
      );
      return;
    }
    state = state.copyWith(loading: true, clearError: true);
    try {
      final started = await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!started && mounted) {
        state = state.copyWith(loading: false, error: 'Purchase failed');
      }
    } catch (error) {
      debugPrint('[RollReel] Purchase could not start: $error');
      if (mounted) {
        state = state.copyWith(loading: false, error: 'Purchase failed');
      }
    }
  }

  Future<bool> restore() async {
    if (state.loading) return false;
    _restoring = true;
    state = state.copyWith(loading: true, clearError: true);
    try {
      if (await _ref.read(isProProvider.notifier).restoreFromStoreKit()) {
        return mounted && state.error == null;
      }
      if (!mounted) return false;
      final catalog = _catalogRequest;
      if (catalog != null) await catalog;
      if (!mounted) return false;
      if (!state.available && catalog == null) await refreshCatalog();
      if (!mounted || !state.available) return false;
      await InAppPurchase.instance.restorePurchases();
      await _purchaseUpdates;
      return mounted && state.error == null;
    } catch (error) {
      if (mounted) state = state.copyWith(error: error.toString());
      return false;
    } finally {
      _restoring = false;
      if (mounted) state = state.copyWith(loading: false);
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    if (!mounted) return;
    final matching = purchases.where(
      (purchase) => _productIds.contains(purchase.productID),
    );
    try {
      for (final purchase in matching) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          await _ref
              .read(isProProvider.notifier)
              .applyPurchase(purchase.productID);
        } else if (purchase.status == PurchaseStatus.error && mounted) {
          state = state.copyWith(
            error: purchase.error?.message ?? 'Purchase failed',
          );
        }
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      }
    } catch (error) {
      debugPrint('[RollReel] Purchase update could not finish: $error');
      if (mounted) state = state.copyWith(error: 'Purchase failed');
    } finally {
      if (mounted &&
          !_restoring &&
          matching.isNotEmpty &&
          matching.every(
            (purchase) => purchase.status != PurchaseStatus.pending,
          )) {
        state = state.copyWith(loading: false);
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final iapProvider = StateNotifierProvider<IAPNotifier, IAPState>(
  (ref) => IAPNotifier(ref),
);
