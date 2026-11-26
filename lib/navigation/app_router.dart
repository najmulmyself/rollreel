import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/iap/iap_provider.dart';
import '../core/permissions/permission_provider.dart';
import '../core/review/review_prompt_provider.dart';
import '../core/video/video_library_provider.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/permission/permission_denied_screen.dart';
import '../features/splash/splash_screen.dart';
import 'main_shell.dart';

enum RRRoute { splash, onboarding, main, permissionDenied }

class AppRouter extends ConsumerStatefulWidget {
  const AppRouter({super.key});

  @override
  ConsumerState<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<AppRouter>
    with WidgetsBindingObserver {
  RRRoute _route = RRRoute.splash;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(iapProvider);
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
    try {
      final permission = await PhotoManager.getPermissionState(
        requestOption: const PermissionRequestOption(),
      );
      if (mounted &&
          _route == RRRoute.permissionDenied &&
          permission.hasAccess) {
        _enterMainWithAccess();
      }
    } on Exception {
      // Leave the recovery screen available when the system check fails.
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
      _go(RRRoute.main);
    } catch (_) {
      _go(RRRoute.onboarding);
    }
  }

  Future<void> _finishOnboarding(PermissionState perm) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
    } on Exception catch (error) {
      debugPrint('Unable to save onboarding completion: $error');
    }
    if (!mounted) return;
    if (perm.hasAccess) {
      _enterMainWithAccess();
    } else if (perm == PermissionState.notDetermined) {
      _go(RRRoute.main);
    } else {
      _go(RRRoute.permissionDenied);
    }
  }

  void _enterMainWithAccess() {
    ref.invalidate(permissionProvider);
    ref.invalidate(videoLibraryProvider);
    _go(RRRoute.main);
    // Give the Photos library time to finish syncing after a fresh grant.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) ref.invalidate(videoLibraryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_route) {
      case RRRoute.splash:
        return SplashScreen(onComplete: _afterSplash);
      case RRRoute.onboarding:
        return OnboardingScreen(onDone: _finishOnboarding);
      case RRRoute.main:
        return const MainShell();
      case RRRoute.permissionDenied:
        return PermissionDeniedScreen(
          onTryAgain: () => PhotoManager.openSetting(),
          onContinue: () => _go(RRRoute.main),
        );
    }
  }
}
