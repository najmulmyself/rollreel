import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../l10n/app_localizations.dart';

/// Persistent 5-item bottom nav: Home / Library / floating center Play
/// button / Favorites / Settings. [currentIndex] addresses the 4 real
/// destinations (0=Home, 1=Library, 2=Favorites, 3=Settings) — the
/// floating center button is a standalone action, not a tab.
class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  static const double _barHeight = 64;
  static const double _centerSize = 60;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: _barHeight + _centerSize / 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: _barHeight,
            decoration: BoxDecoration(
              color: RRColors.bgElevated,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.house_fill,
                      label: l10n.home,
                      active: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.folder_fill,
                      label: l10n.library,
                      active: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  const SizedBox(width: _centerSize),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.heart_fill,
                      label: l10n.favorites,
                      active: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.gear_alt_fill,
                      label: l10n.settings,
                      active: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: _barHeight - _centerSize / 2,
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: _centerSize,
                height: _centerSize,
                decoration: BoxDecoration(
                  gradient: RRColors.gradPro,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: RRColors.accentViolet.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: RRColors.bgDeep, width: 3),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? RRColors.accentViolet : RRColors.textDisabled;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
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
