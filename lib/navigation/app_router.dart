import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/browse/browse_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';

enum RRRoute { splash, onboarding, feed, browse, settings, paywall }

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  RRRoute _route = RRRoute.splash;

  void _go(RRRoute route) => setState(() => _route = route);

  Future<void> _afterSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('has_seen_onboarding') ?? false;
    if (!seen) {
      _go(RRRoute.onboarding);
    } else {
      _go(RRRoute.feed);
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    _go(RRRoute.feed);
  }

  @override
  Widget build(BuildContext context) {
    switch (_route) {
      case RRRoute.splash:
        return SplashScreen(onComplete: _afterSplash);
      case RRRoute.onboarding:
        return OnboardingScreen(onDone: _finishOnboarding);
      case RRRoute.feed:
        return FeedScreen(
          onOpenBrowse: () => _go(RRRoute.browse),
          onOpenSettings: () => _go(RRRoute.settings),
        );
      case RRRoute.browse:
        return BrowseScreen(onBack: () => _go(RRRoute.feed));
      case RRRoute.settings:
        return SettingsScreen(
          onBack: () => _go(RRRoute.feed),
          onOpenPaywall: () => _go(RRRoute.paywall),
        );
      case RRRoute.paywall:
        return PaywallScreen(onClose: () => _go(RRRoute.settings));
    }
  }
}
