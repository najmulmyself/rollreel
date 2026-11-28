import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SwipePromotion { none, interstitial, proOffer }

final playerPromotionScheduleProvider = Provider<PlayerPromotionSchedule>(
  (_) => PlayerPromotionSchedule(),
);

class PlayerPromotionSchedule {
  static const _swipesPerAd = 5;
  static const _swipesPerOffer = 10;
  static const _offerLimit = 2;
  static const _offerWindow = Duration(hours: 3);
  static const _offerTimesKey = 'player_pro_offer_times';

  int _swipes = 0;
  SharedPreferences? _preferences;

  SwipePromotion recordSwipe() {
    _swipes = (_swipes + 1) % _swipesPerOffer;
    if (_swipes == 0) return SwipePromotion.proOffer;
    if (_swipes % _swipesPerAd == 0) return SwipePromotion.interstitial;
    return SwipePromotion.none;
  }

  Future<bool> hasOfferSlot() async {
    try {
      final prefs = _preferences ??= await SharedPreferences.getInstance();
      return _recentOffers(prefs, DateTime.now()).length < _offerLimit;
    } catch (error) {
      debugPrint('[RollReel] Could not read player offer history: $error');
      return false;
    }
  }

  Future<void> recordOfferShown() async {
    final prefs = _preferences;
    if (prefs == null) return;
    final now = DateTime.now();
    final offers = [
      ..._recentOffers(prefs, now),
      now.millisecondsSinceEpoch.toString(),
    ];
    try {
      if (!await prefs.setStringList(_offerTimesKey, offers)) {
        debugPrint('[RollReel] Could not save player offer history.');
      }
    } catch (error) {
      debugPrint('[RollReel] Could not save player offer history: $error');
    }
  }

  List<String> _recentOffers(SharedPreferences prefs, DateTime now) {
    final cutoff = now.subtract(_offerWindow).millisecondsSinceEpoch;
    final timestamps = prefs.getStringList(_offerTimesKey) ?? const <String>[];
    return timestamps
        .where((timestamp) => (int.tryParse(timestamp) ?? 0) > cutoff)
        .toList();
  }
}
