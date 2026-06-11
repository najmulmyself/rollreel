import 'package:flutter/material.dart';

import '../features/browse/browse_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/permission/permission_denied_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';

enum RRRoute {
  splash,
  onboarding,
  permission,
  feed,
  browse,
  settings,
  paywall,
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  RRRoute _route = RRRoute.splash;

  void _go(RRRoute route) => setState(() => _route = route);

  @override
  Widget build(BuildContext context) {
    switch (_route) {
      case RRRoute.splash:
        return SplashScreen(onComplete: () => _go(RRRoute.onboarding));
      case RRRoute.onboarding:
        return OnboardingScreen(onDone: () => _go(RRRoute.feed));
      case RRRoute.permission:
        return PermissionDeniedScreen(
          onTryAgain: () => _go(RRRoute.feed),
          onContinue: () => _go(RRRoute.feed),
        );
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
