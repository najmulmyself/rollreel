import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../iap/iap_provider.dart';
import 'system_prompt_coordinator.dart';

// Real ad units return "No ad to show" (zero fill) until the AdMob account
// has enough traffic history — that's expected, not a bug. Use Google's
// official test unit in debug builds so the ad pipeline itself can be
// verified without depending on real fill.
const String kInterstitialAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/4411468910'
    : 'ca-app-pub-3549493907002564/1729166596';

const String kBannerAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/2934735716'
    : 'ca-app-pub-3549493907002564/5485502212';

class InterstitialAds {
  InterstitialAds(this._ref) {
    _loadInterstitial();
  }

  final Ref _ref;
  InterstitialAd? _interstitial;
  InterstitialAd? _showingInterstitial;
  DateTime? _loadedAt;
  bool _isLoading = false;
  bool _disposed = false;

  bool get isShowingInterstitial => _showingInterstitial != null;

  // Google interstitials expire ~60 minutes after load; showing an expired
  // ad reliably fails. Refresh proactively instead of relying on the
  // failure path, with a safety buffer under the real expiry.
  static const _maxAge = Duration(minutes: 50);

  void _loadInterstitial() {
    if (_disposed || _isLoading || isShowingInterstitial) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: kInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (_disposed) {
            ad.dispose();
            return;
          }
          debugPrint('[RollReel] Interstitial loaded');
          _isLoading = false;
          _interstitial = ad;
          _loadedAt = DateTime.now();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('[RollReel] Interstitial shown');
            },
            onAdDismissedFullScreenContent: _finishInterstitial,
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[RollReel] Interstitial failed to show: $error');
              _finishInterstitial(ad);
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[RollReel] Interstitial failed to load: $error');
          _isLoading = false;
          _interstitial = null;
          // Retry shortly instead of waiting for the next swipe-threshold hit.
          Future.delayed(const Duration(seconds: 5), _loadInterstitial);
        },
      ),
    );
  }

  void _finishInterstitial(InterstitialAd ad) {
    if (!identical(_showingInterstitial, ad)) return;
    _showingInterstitial = null;
    unawaited(ad.dispose());
    _loadInterstitial();
  }

  void showInterstitial() {
    if (_disposed ||
        _ref.read(isProProvider) ||
        isShowingInterstitial ||
        _ref.read(isSystemPromptActiveProvider)) {
      return;
    }

    final ad = _interstitial;
    if (ad == null) {
      _loadInterstitial();
      return;
    }
    final loadedAt = _loadedAt;
    _interstitial = null;
    _loadedAt = null;
    if (loadedAt != null && DateTime.now().difference(loadedAt) > _maxAge) {
      unawaited(ad.dispose());
      _loadInterstitial();
      return;
    }

    _showingInterstitial = ad;
    unawaited(
      ad.show().catchError((Object error) {
        debugPrint('[RollReel] Could not present interstitial: $error');
        _finishInterstitial(ad);
      }),
    );
  }

  void dispose() {
    _disposed = true;
    unawaited(_interstitial?.dispose());
    _interstitial = null;
  }
}

final adsProvider = Provider<InterstitialAds>((ref) {
  final ads = InterstitialAds(ref);
  ref.onDispose(ads.dispose);
  return ads;
});
