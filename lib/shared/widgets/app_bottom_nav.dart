import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';

enum AppBottomTab { library, info, settings }

/// Persistent Library / Info / Settings bar used at the bottom of the
/// Feed and Browse screens.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.active,
    this.onLibrary,
    this.onInfo,
    this.onSettings,
  });

  final AppBottomTab active;
  final VoidCallback? onLibrary;
  final VoidCallback? onInfo;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: CupertinoIcons.square_grid_2x2_fill,
              label: l10n.library,
              active: active == AppBottomTab.library,
              onTap: onLibrary,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: CupertinoIcons.info_circle,
              label: l10n.infoTab,
              active: active == AppBottomTab.info,
              onTap: onInfo,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: CupertinoIcons.gear_alt,
              label: l10n.settings,
              active: active == AppBottomTab.settings,
              onTap: onSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? RRColors.accentViolet : Colors.white70;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
