import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/video/video_library_provider.dart';
import '../features/browse/browse_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/settings/settings_screen.dart';

const _kTabBarHeight = 62.0;
const _kTabBarMargin = 10.0;

class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
    required this.onOpenPaywall,
    required this.onOpenVault,
  });

  final VoidCallback onOpenPaywall;
  final VoidCallback onOpenVault;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _tab = 0;
  bool _videoPlaying = false;

  void _setTab(int index) {
    if (_tab == index) return;
    HapticFeedback.selectionClick();
    setState(() => _tab = index);
  }

  void _handleFeedPlayState(bool playing) {
    if (mounted) setState(() => _videoPlaying = playing);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final tabBarFootprint = _kTabBarHeight + _kTabBarMargin + safeBottom;
    final showTabBar = _tab != 0 || !_videoPlaying;

    // When Browse triggers a play, switch to the Watch tab
    ref.listen<String?>(feedJumpToAssetProvider, (_, assetId) {
      if (assetId != null) _setTab(0);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: Stack(
        children: [
          // ── Tab content — bottom-padded so nothing hides behind the tab bar
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: MediaQuery.of(context).padding.copyWith(
                bottom: tabBarFootprint,
              ),
            ),
            child: IndexedStack(
              index: _tab,
              children: [
                FeedScreen(
                  isTabActive: _tab == 0,
                  onPlayStateChanged: _handleFeedPlayState,
                ),
                BrowseScreen(
                  onPlayAt: (assetId) {
                    ref.read(feedJumpToAssetProvider.notifier).state = assetId;
                    _setTab(0);
                  },
                ),
                SettingsScreen(
                  onOpenPaywall: widget.onOpenPaywall,
                  onOpenVault: widget.onOpenVault,
                ),
              ],
            ),
          ),

          // ── Floating glass tab bar
          Positioned(
            bottom: safeBottom + _kTabBarMargin,
            left: 20,
            right: 20,
            child: IgnorePointer(
              ignoring: !showTabBar,
              child: AnimatedOpacity(
                opacity: showTabBar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: AnimatedSlide(
                  offset: showTabBar ? Offset.zero : const Offset(0, 0.4),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: _GlassTabBar(
                    currentTab: _tab,
                    onTabSelected: _setTab,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass tab bar ────────────────────────────────────────────────────────────

class _GlassTabBar extends StatelessWidget {
  const _GlassTabBar({
    required this.currentTab,
    required this.onTabSelected,
  });

  final int currentTab;
  final void Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          height: _kTabBarHeight,
          decoration: BoxDecoration(
            // Base glass layer
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.13),
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
              // Inner top highlight — mimics liquid glass refraction
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabItem(
                  icon: CupertinoIcons.play_circle,
                  selectedIcon: CupertinoIcons.play_circle_fill,
                  label: 'Watch',
                  selected: currentTab == 0,
                  onTap: () => onTabSelected(0),
                ),
                _TabItem(
                  icon: CupertinoIcons.square_grid_2x2,
                  selectedIcon: CupertinoIcons.square_grid_2x2_fill,
                  label: 'Library',
                  selected: currentTab == 1,
                  onTap: () => onTabSelected(1),
                ),
                _TabItem(
                  icon: CupertinoIcons.gear_alt,
                  selectedIcon: CupertinoIcons.gear_alt_fill,
                  label: 'Settings',
                  selected: currentTab == 2,
                  onTap: () => onTabSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tab item — iOS 26 style: selected shows icon + label in a glass pill ─────

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 14 : 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: selected
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 0.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                selected ? selectedIcon : icon,
                key: ValueKey(selected),
                size: 22,
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
