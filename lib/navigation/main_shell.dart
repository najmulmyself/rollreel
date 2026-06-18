import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/video/video_library_provider.dart';
import '../features/browse/browse_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/settings/settings_screen.dart';

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

  void _setTab(int index) {
    if (_tab == index) return;
    HapticFeedback.selectionClick();
    setState(() => _tab = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    // When Browse triggers a play, switch to the Watch tab
    ref.listen<String?>(feedJumpToAssetProvider, (_, assetId) {
      if (assetId != null) _setTab(0);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: IndexedStack(
        index: _tab,
        children: [
          FeedScreen(
            isTabActive: _tab == 0,
            onOpenBrowse: () => _setTab(1),
            onOpenSettings: () => _setTab(2),
          ),
          BrowseScreen(
            onBack: () => _setTab(0),
            onPlayAt: (assetId) {
              ref.read(feedJumpToAssetProvider.notifier).state = assetId;
              _setTab(0);
            },
          ),
          SettingsScreen(
            onBack: () => _setTab(0),
            onOpenPaywall: widget.onOpenPaywall,
            onOpenVault: widget.onOpenVault,
          ),
        ],
      ),
    );
  }
}
