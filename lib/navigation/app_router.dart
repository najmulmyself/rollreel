import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/browse/browse_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/permission/permission_denied_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/vault/vault_screen.dart';

enum RRRoute {
  splash,
  onboarding,
  feed,
  browse,
  settings,
  paywall,
  vault,
  permissionDenied,
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> with WidgetsBindingObserver {
  RRRoute _route = RRRoute.splash;
  int _feedInitialIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Re-check permission when user returns from iOS Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _route == RRRoute.permissionDenied) {
      _recheckPermission();
    }
  }

  Future<void> _recheckPermission() async {
    final perm = await PhotoManager.requestPermissionExtend();
    if (perm.isAuth || perm == PermissionState.limited) {
      _go(RRRoute.feed);
    }
  }

  void _go(RRRoute route) => setState(() => _route = route);

  Future<void> _afterSplash() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('has_seen_onboarding') ?? false;
      if (!seen) {
        _go(RRRoute.onboarding);
        return;
      }
      // Silent check — no dialog shown when permission already determined
      final perm = await PhotoManager.requestPermissionExtend();
      if (perm.isAuth || perm == PermissionState.limited) {
        _go(RRRoute.feed);
      } else {
        _go(RRRoute.permissionDenied);
      }
    } catch (_) {
      _go(RRRoute.onboarding);
    }
  }

  Future<void> _finishOnboarding(PermissionState perm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (perm.isAuth || perm == PermissionState.limited) {
      _go(RRRoute.feed);
    } else {
      _go(RRRoute.permissionDenied);
    }
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
          initialIndex: _feedInitialIndex,
        );
      case RRRoute.browse:
        return BrowseScreen(
          onBack: () => _go(RRRoute.feed),
          onPlayAt: (index) {
            setState(() => _feedInitialIndex = index);
            _go(RRRoute.feed);
          },
        );
      case RRRoute.settings:
        return SettingsScreen(
          onBack: () => _go(RRRoute.feed),
          onOpenPaywall: () => _go(RRRoute.paywall),
          onOpenVault: () => _go(RRRoute.vault),
        );
      case RRRoute.paywall:
        return PaywallScreen(onClose: () => _go(RRRoute.settings));
      case RRRoute.vault:
        return VaultScreen(onBack: () => _go(RRRoute.settings));
      case RRRoute.permissionDenied:
        return PermissionDeniedScreen(
          onTryAgain: () => PhotoManager.openSetting(),
          onContinue: () => _go(RRRoute.feed),
        );
    }
  }
}
