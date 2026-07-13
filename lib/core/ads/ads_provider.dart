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

const int kSwipesPerInterstitial = 5;

class AdsNotifier extends StateNotifier<int> {
  AdsNotifier(this._ref) : super(0) {
    _loadInterstitial();
  }

  final Ref _ref;
  InterstitialAd? _interstitial;
  DateTime? _loadedAt;
  bool _isLoading = false;

  // Google interstitials expire ~60 minutes after load; showing an expired
  // ad reliably fails. Refresh proactively instead of relying on the
  // failure path, with a safety buffer under the real expiry.
  static const _maxAge = Duration(minutes: 50);

  void _loadInterstitial() {
    if (_isLoading) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: kInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[RollReel] Interstitial loaded');
          _isLoading = false;
          _interstitial = ad;
          _loadedAt = DateTime.now();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('[RollReel] Interstitial shown');
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _loadedAt = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[RollReel] Interstitial failed to show: $error');
              ad.dispose();
              _interstitial = null;
              _loadedAt = null;
              _loadInterstitial();
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

  // Called on every feed swipe. Shows a preloaded interstitial every
  // [kSwipesPerInterstitial] swipes; never for Pro/Plus users.
  void registerSwipe() {
    if (_ref.read(isProProvider)) return;

    final count = state + 1;
    if (count >= kSwipesPerInterstitial) {
      var ad = _interstitial;

      // Discard an expired ad instead of calling show() on it — that
      // reliably fails and wastes the swipe opportunity.
      if (ad != null &&
          _loadedAt != null &&
          DateTime.now().difference(_loadedAt!) > _maxAge) {
        debugPrint('[RollReel] Interstitial expired, discarding');
        ad.dispose();
        ad = null;
        _interstitial = null;
        _loadedAt = null;
      }

      // Don't race a native system prompt (ATT, App Store review) — iOS
      // can only present one modal at a time and the show() call can be
      // silently dropped.
      final promptActive = _ref.read(isSystemPromptActiveProvider);

      if (ad != null && !promptActive) {
        state = 0;
        _interstitial = null;
        ad.show();
      } else {
        // Not ready yet — hold at the threshold and retry on the next swipe
        // instead of silently resetting and losing this ad opportunity.
        debugPrint('[RollReel] Swipe threshold hit but interstitial not shown '
            '(ready: ${ad != null}, promptActive: $promptActive)');
        state = count;
        if (ad == null) _loadInterstitial();
      }
    } else {
      state = count;
    }
  }
}

final adsProvider =
    StateNotifierProvider<AdsNotifier, int>((ref) => AdsNotifier(ref));
