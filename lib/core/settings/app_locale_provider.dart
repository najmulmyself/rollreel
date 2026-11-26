import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

const _languageKey = 'settings_language';

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale?>(
  (ref) => AppLocaleNotifier(),
);

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(null) {
    ready = _load();
  }

  late final Future<void> ready;

  Future<void> _load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final code = preferences.getString(_languageKey);
      if (code == null || code.isEmpty) return;
      final locale = Locale(code);
      if (mounted && AppLocalizations.supportedLocales.contains(locale)) {
        state = locale;
      }
    } catch (_) {
      // Follow the device language if the saved preference cannot be read.
    }
  }

  Future<void> setLocale(Locale? locale) async {
    await ready;
    if (locale != null && !AppLocalizations.supportedLocales.contains(locale)) {
      throw ArgumentError.value(locale, 'locale');
    }
    final preferences = await SharedPreferences.getInstance();
    final saved = locale == null
        ? await preferences.remove(_languageKey)
        : await preferences.setString(_languageKey, locale.languageCode);
    if (!saved) throw StateError('Could not save the language preference.');
    if (mounted) state = locale;
  }
}
