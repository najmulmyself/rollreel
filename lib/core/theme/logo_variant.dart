import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_icon_channel.dart';

enum LogoVariant {
  classic,  // Play-button circle, "Your Videos. Your Way."
  iconic,   // icon.png star/reel, "Watch. Feel. Remember."
}

const _kPrefsKey = 'logo_variant';

final logoVariantProvider =
    StateNotifierProvider<LogoVariantNotifier, LogoVariant>((ref) {
  return LogoVariantNotifier();
});

class LogoVariantNotifier extends StateNotifier<LogoVariant> {
  LogoVariantNotifier() : super(LogoVariant.classic) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kPrefsKey);
      if (saved != null) {
        state = LogoVariant.values.firstWhere(
          (v) => v.name == saved,
          orElse: () => LogoVariant.classic,
        );
      }
    } catch (e) {
      debugPrint('Logo variant load error: $e');
      // Keep default state
    }
  }

  Future<void> select(LogoVariant variant) async {
    state = variant;
    await AppIconChannel.setIcon(variant);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefsKey, variant.name);
    } catch (e) {
      debugPrint('Logo variant save error: $e');
    }
  }
}
