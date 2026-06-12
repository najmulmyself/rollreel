import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPrefsKey);
    if (saved != null) {
      state = LogoVariant.values.firstWhere(
        (v) => v.name == saved,
        orElse: () => LogoVariant.classic,
      );
    }
  }

  Future<void> select(LogoVariant variant) async {
    state = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, variant.name);
  }
}
