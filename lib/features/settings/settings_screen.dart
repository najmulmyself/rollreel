import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
    this.onBack,
    required this.onOpenPaywall,
    required this.onOpenVault,
  });

  final VoidCallback? onBack;
  final VoidCallback onOpenPaywall;
  final VoidCallback onOpenVault;

  static const String _version = '1.0.0';
  static const String _build = '1';

  Future<void> _rateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      review.requestReview();
    } else {
      review.openStoreListing();
    }
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share link copied!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: RRColors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RRSpace.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNav(context),
            const Divider(height: 1, color: RRColors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp20, RRSpace.sp16, 48),
                children: [
                  // ── RollReel Pro banner ──────────────────────────────────
                  _buildProBanner(context),
                  const SizedBox(height: RRSpace.sp24),

                  // ── PLAYBACK ─────────────────────────────────────────────
                  const _SectionLabel('PLAYBACK'),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF7D5A2A),
                          icon: CupertinoIcons.arrow_2_circlepath),
                      label: 'Loop Short Videos',
                      value: s.loopShortVideos,
                      onChanged: notifier.setLoopShortVideos,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF1B6F6F),
                          icon: CupertinoIcons.play_fill),
                      label: 'Auto-play on Launch',
                      value: s.autoPlay,
                      onChanged: notifier.setAutoPlay,
                    ),
                    const _NavRow(
                      icon: _SettingIcon(
                          color: Color(0xFF7D2E2E),
                          icon: CupertinoIcons.line_horizontal_3_decrease),
                      label: 'Default Filter',
                      trailingText: 'All',
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── APPEARANCE ───────────────────────────────────────────
                  const _SectionLabel('APPEARANCE'),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF3D3FB8),
                          icon: CupertinoIcons.calendar),
                      label: 'Show Date Labels',
                      value: s.showDateLabels,
                      onChanged: notifier.setShowDateLabels,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF237A4A),
                          icon: CupertinoIcons.clock_fill),
                      label: 'Show Duration Badges',
                      value: s.showDurationBadges,
                      onChanged: notifier.setShowDurationBadges,
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── PRIVACY ──────────────────────────────────────────────
                  const _SectionLabel('PRIVACY'),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF4A2A8B),
                          icon: CupertinoIcons.lock_fill),
                      label: 'Privacy Vault',
                      trailingText: 'Set Up',
                      onTap: onOpenVault,
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF1A5A6B),
                          icon: Icons.face_retouching_natural),
                      label: 'App Lock (Face ID)',
                      trailingText: 'Pro',
                      onTap: onOpenPaywall,
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── ABOUT ────────────────────────────────────────────────
                  const _SectionLabel('ABOUT'),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    const _NavRow(
                      icon: _SettingIcon(
                          color: Color(0xFF2A6B3A),
                          icon: CupertinoIcons.shield_fill),
                      label: 'Privacy Policy',
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF8B6A1A),
                          icon: CupertinoIcons.star_fill),
                      label: 'Rate RollReel',
                      onTap: _rateApp,
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF1A4A8B),
                          icon: CupertinoIcons.share),
                      label: 'Share RollReel',
                      onTap: () => _shareApp(context),
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF2A2D4A),
                          icon: CupertinoIcons.info_circle_fill),
                      label: 'Version',
                      trailingText: '$_version (Build $_build)',
                      showChevron: false,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top nav ──────────────────────────────────────────────────────────────────

  Widget _buildTopNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: RRSpace.sp4, vertical: RRSpace.sp4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(
                  horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
              onPressed: onBack,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.chevron_left,
                      color: RRColors.accentCyan, size: 18),
                  SizedBox(width: 2),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: RRColors.accentCyan,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'Settings',
            style: TextStyle(
              color: RRColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pro banner ───────────────────────────────────────────────────────────────

  Widget _buildProBanner(BuildContext context) {
    return GestureDetector(
      onTap: onOpenPaywall,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp16, vertical: RRSpace.sp16),
        decoration: BoxDecoration(
          gradient: RRColors.gradPro,
          borderRadius: BorderRadius.circular(RRSpace.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(RRSpace.radiusFull),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: RRSpace.sp12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RollReel Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ad-free · Vault · Speed · Collections',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: RRSpace.sp4),
      child: Text(
        text,
        style: const TextStyle(
          color: RRColors.textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── Settings group ───────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RRColors.bgElevated,
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++) ...[
              rows[i],
              if (i < rows.length - 1)
                const Divider(height: 1, color: RRColors.divider, indent: 62),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Rounded square icon ──────────────────────────────────────────────────────

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

// ─── Toggle row ───────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final Widget icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: RRSpace.sp16, vertical: RRSpace.sp12),
      child: Row(
        children: [
          icon,
          const SizedBox(width: RRSpace.sp12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: RRColors.textPrimary, fontSize: 16),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: RRColors.accentCoral,
          ),
        ],
      ),
    );
  }
}

// ─── Nav row ──────────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
    this.showChevron = true,
  });

  final Widget icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp16, vertical: 14),
        child: Row(
          children: [
            icon,
            const SizedBox(width: RRSpace.sp12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: RRColors.textPrimary, fontSize: 16),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                    color: RRColors.textSecond, fontSize: 15),
              ),
              if (showChevron) const SizedBox(width: RRSpace.sp4),
            ],
            if (showChevron)
              const Icon(CupertinoIcons.chevron_right,
                  color: RRColors.textDisabled, size: 16),
          ],
        ),
      ),
    );
  }
}
