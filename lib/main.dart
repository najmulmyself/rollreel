import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/settings/app_locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'l10n/app_localizations.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
  // AdMob SDK init spins up network calls and mediation adapters — kicking it
  // off after the first frame keeps it off the launch critical path. The
  // first interstitial isn't requested until several swipes in, so nothing
  // downstream is waiting on this.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    MobileAds.instance.initialize();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: RRColors.isDark,
      builder: (context, _, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: RRAppTheme.dark(),
        darkTheme: RRAppTheme.dark(),
        themeMode: ThemeMode.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const AppRouter(),
      ),
    );
  }
}
