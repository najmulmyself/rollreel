import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../l10n/app_localizations.dart';

/// The center Play button opens the player without changing the selected tab.
class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
    required this.onCenterTap,
  });

  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final accent = isDark ? RRColors.accentViolet : RRColors.brandBlue;
    final muted = isDark ? const Color(0xFF7A7A8C) : RRColors.brandMutedInk;
    final background = isDark
        ? const Color(0xFF131320)
        : const Color(0xFFFBFDFF);
    final outline = isDark ? const Color(0x0FFFFFFF) : const Color(0xFFDCE6ED);
    final destinations = [
      (CupertinoIcons.house, CupertinoIcons.house_fill, l10n.home),
      (CupertinoIcons.folder, CupertinoIcons.folder_fill, l10n.library),
      (CupertinoIcons.heart, CupertinoIcons.heart_fill, l10n.favorites),
      (CupertinoIcons.gear_alt, CupertinoIcons.gear_alt_fill, l10n.settings),
    ];

    Widget destination(int index) {
      final (icon, activeIcon, label) = destinations[index];
      final active = currentIndex == index;
      return Expanded(
        child: _NavBtn(
          icon: active ? activeIcon : icon,
          label: label,
          selected: active,
          color: active ? accent : muted,
          onTap: () => onTap(index),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: outline)),
      ),
      padding: EdgeInsets.fromLTRB(8, 0, 8, bottomInset > 0 ? bottomInset : 12),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            destination(0),
            destination(1),
            Semantics(
              label: l10n.feed,
              button: true,
              onTap: onCenterTap,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: onCenterTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent,
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
                        ? Border.all(color: const Color(0x40FFFFFF), width: 2)
                        : null,
                    boxShadow: [
                      if (isDark)
                        const BoxShadow(
                          color: Color(0x8C8B5CF6),
                          blurRadius: 22,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.play_fill,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ),
            destination(2),
            destination(3),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
