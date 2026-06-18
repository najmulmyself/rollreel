import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/review/review_prompt_provider.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/permission/permission_denied_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/vault/vault_screen.dart';
import 'main_shell.dart';

enum RRRoute {
  splash,
  onboarding,
  main,
  paywall,
  vault,
  permissionDenied,
}

class AppRouter extends ConsumerStatefulWidget {
  const AppRouter({super.key});

  @override
  ConsumerState<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<AppRouter> with WidgetsBindingObserver {
  RRRoute _route = RRRoute.splash;
  int _mainTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(reviewPromptProvider).ensureInstallDateRecorded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Re-check permission when user returns from iOS Settings; also drives
  // the auto review-prompt session tracking (PRD §13).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final review = ref.read(reviewPromptProvider);
    if (state == AppLifecycleState.resumed) {
      review.maybeRequestReview();
      if (_route == RRRoute.permissionDenied) {
        _recheckPermission();
      }
    } else if (state == AppLifecycleState.paused) {
      review.endSession();
    }
  }

  Future<void> _recheckPermission() async {
    final perm = await PhotoManager.requestPermissionExtend();
    if (perm.isAuth || perm == PermissionState.limited) {
      _go(RRRoute.main);
    }
  }

  void _go(RRRoute route) => setState(() => _route = route);

  // Must be requested while the app is active/foreground, before the first
  // ad request, so AdMob knows whether it may serve personalized ads.
  Future<void> _requestTrackingIfNeeded() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // Platform without ATT support (e.g. Android) — no-op.
    }
  }

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
        await _requestTrackingIfNeeded();
        _go(RRRoute.main);
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
      await _requestTrackingIfNeeded();
      _go(RRRoute.main);
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
      case RRRoute.main:
        return MainShell(
          initialTab: _mainTab,
          onTabChanged: (tab) => _mainTab = tab,
          onOpenPaywall: () => _go(RRRoute.paywall),
          onOpenVault: () => _go(RRRoute.vault),
        );
      case RRRoute.paywall:
        return PaywallScreen(onClose: () => _go(RRRoute.main));
      case RRRoute.vault:
        return VaultScreen(onBack: () => _go(RRRoute.main));
      case RRRoute.permissionDenied:
        return PermissionDeniedScreen(
          onTryAgain: () => PhotoManager.openSetting(),
          onContinue: () => _go(RRRoute.main),
        );
    }
  }
}
