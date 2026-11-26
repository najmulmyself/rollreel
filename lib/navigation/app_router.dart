import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/ads/ads_provider.dart';
import '../core/ads/system_prompt_coordinator.dart';
import '../core/iap/iap_provider.dart';
import '../core/permissions/permission_provider.dart';
import '../core/review/review_prompt_provider.dart';
import '../core/theme/colors.dart';
import '../core/updates/app_update_service.dart';
import '../core/video/video_library_provider.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/permission/permission_denied_screen.dart';
import '../features/splash/splash_screen.dart';
import '../l10n/app_localizations.dart';
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
  Timer? _updateTimer;
  bool _checkingUpdate = false;
  bool _updatePromptOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(iapProvider);
    ref.read(reviewPromptProvider).ensureInstallDateRecorded();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Re-check permission when user returns from iOS Settings; also drives
  // the auto review-prompt session tracking (PRD §13).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final review = ref.read(reviewPromptProvider);
    if (state == AppLifecycleState.resumed) {
      _scheduleUpdateCheck();
      ref.read(iapProvider.notifier).refreshEntitlements();
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

  void _go(RRRoute route) {
    if (!mounted) return;
    setState(() => _route = route);
    if (route == RRRoute.main) _scheduleUpdateCheck();
  }

  void _scheduleUpdateCheck({Duration delay = const Duration(seconds: 5)}) {
    _updateTimer?.cancel();
    if (_route != RRRoute.main) return;
    _updateTimer = Timer(delay, _maybeOfferUpdate);
  }

  bool get _canOfferUpdate =>
      mounted &&
      _route == RRRoute.main &&
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed &&
      ModalRoute.isCurrentOf(context) != false &&
      !ref.read(isSystemPromptActiveProvider) &&
      !(ref.exists(adsProvider) && ref.read(adsProvider).isShowingInterstitial);

  Future<void> _maybeOfferUpdate() async {
    if (!mounted || _checkingUpdate || _updatePromptOpen) return;
    if (!_canOfferUpdate) {
      _scheduleUpdateCheck(delay: const Duration(seconds: 30));
      return;
    }
    _checkingUpdate = true;
    final service = ref.read(appUpdateServiceProvider);
    final update = await service.check();
    _checkingUpdate = false;
    if (!mounted || update == null) return;
    if (!_canOfferUpdate) {
      _scheduleUpdateCheck(delay: const Duration(seconds: 30));
      return;
    }
    _updatePromptOpen = true;
    ref.read(isSystemPromptActiveProvider.notifier).state = true;
    try {
      await showCupertinoDialog<void>(
        context: context,
        builder: (_) => _AppUpdateDialog(update: update),
      );
      await service.remindLater(update);
    } finally {
      _updatePromptOpen = false;
      if (mounted) {
        ref.read(isSystemPromptActiveProvider.notifier).state = false;
      }
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

class _AppUpdateDialog extends StatefulWidget {
  const _AppUpdateDialog({required this.update});

  final AvailableAppUpdate update;

  @override
  State<_AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<_AppUpdateDialog> {
  bool _opening = false;
  bool _failed = false;

  Future<void> _openStore() async {
    setState(() {
      _opening = true;
      _failed = false;
    });
    try {
      final opened = await launchUrl(
        rollReelAppStoreUrl,
        mode: LaunchMode.externalApplication,
      ).timeout(const Duration(seconds: 5));
      if (!mounted) return;
      if (opened) {
        Navigator.pop(context);
        return;
      }
    } catch (_) {
      // Keep the prompt available so the person can retry or dismiss it.
    }
    if (mounted) {
      setState(() {
        _opening = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: RRColors.isDark.value ? Brightness.dark : Brightness.light,
        primaryColor: RRColors.isDark.value
            ? const Color(0xFFA9DFFF)
            : RRColors.brandBlue,
      ),
      child: CupertinoAlertDialog(
        title: Text(l10n.updateAvailableTitle),
        content: Text(
          _failed
              ? l10n.updateStoreUnavailable
              : l10n.updateAvailableBody(widget.update.version),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: _opening ? null : () => Navigator.pop(context),
            child: Text(l10n.onboardingNotNow),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: _opening ? null : _openStore,
            child: _opening
                ? const CupertinoActivityIndicator()
                : Text(l10n.updateNow),
          ),
        ],
      ),
    );
  }
}
