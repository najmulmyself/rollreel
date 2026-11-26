import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/ads/system_prompt_coordinator.dart';
import '../core/iap/iap_provider.dart';
import '../core/settings/settings_provider.dart';
import '../core/theme/colors.dart';
import '../core/vault/vault_provider.dart';
import '../core/video/video_library_provider.dart';
import '../features/browse/browse_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/memories/on_this_day_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/vault/vault_screen.dart';
import '../l10n/app_localizations.dart';
import 'main_nav_bar.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late int _tab = widget.initialTab;
  bool _paywallPresented = false;

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
    if (kIsWeb || !Platform.isIOS) return;
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
    FocusManager.instance.primaryFocus?.unfocus();
    HapticFeedback.selectionClick();
    setState(() => _tab = index);
  }

  Future<bool> _openPaywall(PaywallEntry entry) async {
    if (_paywallPresented || !mounted) return false;
    _paywallPresented = true;
    try {
      final activated = await Navigator.of(context).push<bool>(
        CupertinoPageRoute<bool>(
          fullscreenDialog: true,
          builder: (_) => PaywallScreen(entry: entry),
        ),
      );
      return activated == true;
    } finally {
      _paywallPresented = false;
    }
  }

  Future<void> _openVault() async {
    await ref.read(vaultIdsProvider.notifier).ready;
    if (!mounted) return;
    await ref.read(isProProvider.notifier).ready;
    if (!mounted) return;
    final hasSavedClips = ref.read(vaultIdsProvider).isNotEmpty;
    if (!hasSavedClips &&
        !ref.read(isProProvider) &&
        !await _openPaywall(PaywallEntry.vault)) {
      return;
    }
    if (!mounted) return;
    final recovered = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (vaultContext) => VaultScreen(
          onBack: () => Navigator.of(vaultContext).pop(),
          onRecovered: () => Navigator.of(vaultContext).pop(true),
        ),
      ),
    );
    if (mounted && recovered == true) {
      _setTab(1);
      _showVaultMessage(AppLocalizations.of(context)!.vaultRecoveryDone);
    }
  }

  Future<void> _changeVaultMembership(String assetId, bool add) async {
    final vault = ref.read(vaultIdsProvider.notifier);
    try {
      if (!add) {
        await vault.remove(assetId);
        return;
      }
      if (await vault.add(assetId) || !mounted) return;
      if (await _openPaywall(PaywallEntry.vault) && mounted) {
        if (!await vault.add(assetId) && mounted) {
          _showVaultMessage(AppLocalizations.of(context)!.vaultUpdateFailed);
        }
      }
    } catch (error) {
      debugPrint('[RollReel] Vault membership could not be changed: $error');
      if (mounted) {
        _showVaultMessage(AppLocalizations.of(context)!.vaultUpdateFailed);
      }
    }
  }

  void _showVaultMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: RRColors.brandInk,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _leavePlayerForTab(BuildContext playerContext, int tab) {
    if (ModalRoute.isCurrentOf(playerContext) != true) return;
    _setTab(tab);
    Navigator.of(playerContext).pop();
  }

  // The video player is a full-screen route pushed from the floating center
  // button (or from tapping a video in Library/Favorites), not one of the
  // persistent bottom-nav tabs.
  void _openFeed(BuildContext context, {String? assetId}) {
    if (assetId != null) {
      ref.read(feedFilterProvider.notifier).state = FeedFilter.all;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (playerContext) => FeedScreen(
          initialAssetId: assetId,
          onOpenBrowse: () => Navigator.of(context).pop(),
          onOpenLibrary: () => _leavePlayerForTab(playerContext, 1),
          onOpenSettings: () => _leavePlayerForTab(playerContext, 3),
          onVaultChange: _changeVaultMembership,
          onOpenPaywall: () async {
            await _openPaywall(PaywallEntry.speed);
          },
        ),
      ),
    );
  }

  Future<void> _openMemories(String? assetId) async {
    if (!ref.read(isProProvider) &&
        !await _openPaywall(PaywallEntry.memories)) {
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (playerContext) => OnThisDayScreen(
          initialAssetId: assetId,
          onOpenLibrary: () => _leavePlayerForTab(playerContext, 1),
          onOpenSettings: () => _leavePlayerForTab(playerContext, 3),
          onVaultChange: _changeVaultMembership,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.select((s) => s.darkMode));
    return Scaffold(
      backgroundColor: RRColors.bgTint,
      extendBody: _tab != 3,
      body: IndexedStack(
        index: _tab,
        children: [
          ProfileScreen(
            onOpenLibrary: () => _setTab(1),
            onOpenMemories: _openMemories,
          ),
          BrowseScreen(
            onOpenMemories: () => _openMemories(null),
            onPlayAt: (assetId) => _openFeed(context, assetId: assetId),
            onVaultChange: _changeVaultMembership,
          ),
          FavoritesScreen(
            onOpenLibrary: () => _setTab(1),
            onPlayAt: (assetId) => _openFeed(context, assetId: assetId),
          ),
          SettingsScreen(
            active: _tab == 3,
            onOpenPaywall: () => _openPaywall(PaywallEntry.playback),
            onOpenVault: _openVault,
          ),
        ],
      ),
      bottomNavigationBar: MainNavBar(
        currentIndex: _tab,
        isDark: isDark,
        onTap: _setTab,
        onCenterTap: () => _openFeed(context),
      ),
    );
  }
}
