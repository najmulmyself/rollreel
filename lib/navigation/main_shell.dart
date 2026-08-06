import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/ads/system_prompt_coordinator.dart';
import '../core/theme/colors.dart';
import '../features/browse/browse_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import 'main_nav_bar.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
    required this.onOpenPaywall,
    required this.onOpenVault,
    this.initialTab = 0,
    this.onTabChanged,
  });

  final VoidCallback onOpenPaywall;
  final VoidCallback onOpenVault;
  final int initialTab;
  final ValueChanged<int>? onTabChanged;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late int _tab = widget.initialTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestAttIfNeeded());
  }

  // Apple rejected a previous submission because the ATT prompt couldn't be
  // found on iPadOS during review — requesting it right after runApp()/route
  // switch can fire before the root view controller is fully presented.
  // Requesting from a mounted screen's first post-frame callback, with an
  // extra delay, guarantees the window is actually on screen first.
  Future<void> _requestAttIfNeeded() async {
    if (!Platform.isIOS) return;
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        ref.read(isSystemPromptActiveProvider.notifier).state = true;
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // Platform without ATT support — no-op.
    } finally {
      ref.read(isSystemPromptActiveProvider.notifier).state = false;
    }
  }

  void _setTab(int index) {
    if (_tab == index) return;
    HapticFeedback.selectionClick();
    setState(() => _tab = index);
    widget.onTabChanged?.call(index);
  }

  // The video player is a full-screen route pushed from the floating center
  // button (or from tapping a video in Library/Favorites), not one of the
  // persistent bottom-nav tabs.
  void _openFeed(BuildContext context, {String? assetId}) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => FeedScreen(
        initialAssetId: assetId,
        onOpenBrowse: () => Navigator.of(context).pop(),
        onOpenPaywall: widget.onOpenPaywall,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgTint,
      // The nav bar's floating center button overflows above its white
      // bar into a transparent strip — without extendBody, that strip
      // shows the Scaffold's flat background instead of the page content
      // scrolling underneath it.
      extendBody: true,
      body: IndexedStack(
        index: _tab,
        children: [
          ProfileScreen(onOpenSettings: () => _setTab(3)),
          BrowseScreen(
            onOpenPaywall: widget.onOpenPaywall,
            onPlayAt: (assetId) => _openFeed(context, assetId: assetId),
          ),
          FavoritesScreen(
            onOpenLibrary: () => _setTab(1),
            onPlayAt: (assetId) => _openFeed(context, assetId: assetId),
          ),
          SettingsScreen(
            onBack: () => _setTab(0),
            onOpenPaywall: widget.onOpenPaywall,
            onOpenVault: widget.onOpenVault,
          ),
        ],
      ),
      bottomNavigationBar: MainNavBar(
        currentIndex: _tab,
        onTap: _setTab,
        onCenterTap: () => _openFeed(context),
      ),
    );
  }
}
