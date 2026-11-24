import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../l10n/app_localizations.dart';

/// Persistent 5-item floating bottom nav: Home / Library / floating center
/// Play button / Favorites / Settings. A floating pill that follows the
/// app's light/dark theme, sitting on top of any page background.
/// [currentIndex] addresses the 4 real destinations (0=Home, 1=Library,
/// 2=Favorites, 3=Settings) — the center button is a standalone action,
/// not a tab.
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

  static const double _barHeight = 68;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isDark = RRColors.isDark.value;
    final centerSize = isDark ? 60.0 : 54.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        bottomInset > 0 ? bottomInset : 12,
      ),
      child: SizedBox(
        height: _barHeight + 12,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: _barHeight,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xF0131320) : Colors.white,
                borderRadius: BorderRadius.circular(_barHeight / 2),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : RRColors.brandOutline.withValues(alpha: 0.7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                    blurRadius: isDark ? 24 : 12,
                    offset: Offset(0, isDark ? 10 : 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.house,
                      activeIcon: CupertinoIcons.house_fill,
                      label: l10n.home,
                      active: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.folder,
                      activeIcon: CupertinoIcons.folder_fill,
                      label: l10n.library,
                      active: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  SizedBox(width: centerSize),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.heart,
                      activeIcon: CupertinoIcons.heart_fill,
                      label: l10n.favorites,
                      active: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  Expanded(
                    child: _NavBtn(
                      icon: CupertinoIcons.gear_alt,
                      activeIcon: CupertinoIcons.gear_alt_fill,
                      label: l10n.settings,
                      active: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: (_barHeight - centerSize) / 2,
              child: Semantics(
                label: l10n.feed,
                button: true,
                onTap: onCenterTap,
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: onCenterTap,
                  child: Container(
                    width: centerSize,
                    height: centerSize,
                    decoration: BoxDecoration(
                      color: isDark ? null : RRColors.brandBlue,
                      gradient: isDark
                          ? const LinearGradient(
                              colors: [
                                RRColors.accentBlue,
                                RRColors.accentViolet,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      shape: BoxShape.circle,
                      border: isDark
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 2,
                            )
                          : null,
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: RRColors.accentViolet.withValues(
                              alpha: 0.55,
                            ),
                            blurRadius: 22,
                            spreadRadius: 1,
                          ),
                      ],
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
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = RRColors.isDark.value;
    final color = isDark
        ? (active ? RRColors.accentViolet : const Color(0xFF7A7A8C))
        : (active ? RRColors.brandBlue : RRColors.brandMutedInk);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(active ? activeIcon : icon, color: color, size: 22),
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
