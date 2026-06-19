import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../iap/iap_provider.dart';

const String kInterstitialAdUnitId =
    'ca-app-pub-3549493907002564/1729166596';

const int kSwipesPerInterstitial = 6;

class AdsNotifier extends StateNotifier<int> {
  AdsNotifier(this._ref) : super(0) {
    _loadInterstitial();
  }

  final Ref _ref;
  InterstitialAd? _interstitial;

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: kInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[RollReel] Interstitial loaded');
          _interstitial = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[RollReel] Interstitial failed to load: $error');
          _interstitial = null;
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
      state = 0;
      final ad = _interstitial;
      if (ad != null) {
        _interstitial = null;
        ad.show();
      } else {
        debugPrint('[RollReel] Swipe threshold hit but no interstitial ready yet');
      }
    } else {
      state = count;
    }
  }
}

final adsProvider =
    StateNotifierProvider<AdsNotifier, int>((ref) => AdsNotifier(ref));
