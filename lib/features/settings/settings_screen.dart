import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';

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

  // iPad shows the share sheet as a popover and requires an anchor rect —
  // without one it renders at (0,0) and gets dismissed before it's visible.
  // [btnContext] is the row's own BuildContext, captured at tap time via a
  // Builder, so no GlobalKey is needed.
  void _shareApp(BuildContext btnContext) {
    final l10n = AppLocalizations.of(btnContext)!;
    final box = btnContext.findRenderObject() as RenderBox?;
    final origin =
        box == null ? Rect.zero : (box.localToGlobal(Offset.zero) & box.size);
    Share.share(
      '${l10n.shareAppMessage}\n'
      'https://apps.apple.com/app/id6781843410',
      sharePositionOrigin: origin,
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.parse('https://najmulmyself.github.io/rollreel/privacy.html');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context)!;
      showCupertinoDialog<void>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(l10n.privacyPolicy),
          content: Text(l10n.privacyPolicyBody),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }

  static String _filterLabel(AppLocalizations l10n, FeedFilter f) {
    switch (f) {
      case FeedFilter.all:
        return l10n.filterAll;
      case FeedFilter.today:
        return l10n.filterToday;
      case FeedFilter.shorts:
        return l10n.filterShorts;
      case FeedFilter.long:
        return l10n.filterLong;
    }
  }

  Future<void> _showDefaultFilterPicker(
      BuildContext context, AppSettings s, SettingsNotifier notifier) async {
    final l10n = AppLocalizations.of(context)!;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(l10n.defaultFilter),
        actions: FeedFilter.values.map((f) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              notifier.setDefaultFilter(f);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_filterLabel(l10n, f)),
                if (s.defaultFilter == f) ...[
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.checkmark,
                      size: 16, color: CupertinoColors.activeBlue),
                ],
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isPro = ref.watch(isProProvider);

    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNav(context),
            Divider(height: 1, color: RRColors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp20, RRSpace.sp16, 48),
                children: [
                  // ── RollReel Pro banner ──────────────────────────────────
                  _buildProBanner(context),
                  const SizedBox(height: RRSpace.sp24),

                  // ── PLAYBACK ─────────────────────────────────────────────
                  _SectionLabel(l10n.playbackSection),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF7D5A2A),
                          icon: CupertinoIcons.arrow_2_circlepath),
                      label: l10n.loopShortVideos,
                      value: s.loopShortVideos,
                      onChanged: notifier.setLoopShortVideos,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF1B6F6F),
                          icon: CupertinoIcons.play_fill),
                      label: l10n.autoPlayOnLaunch,
                      value: s.autoPlay,
                      onChanged: notifier.setAutoPlay,
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF7D2E2E),
                          icon: CupertinoIcons.line_horizontal_3_decrease),
                      label: l10n.defaultFilter,
                      trailingText: _filterLabel(l10n, s.defaultFilter),
                      onTap: () =>
                          _showDefaultFilterPicker(context, s, notifier),
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── APPEARANCE ───────────────────────────────────────────
                  _SectionLabel(l10n.appearanceSection),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF5A3D1A),
                          icon: CupertinoIcons.moon_fill),
                      label: l10n.darkMode,
                      value: s.darkMode,
                      onChanged: notifier.setDarkMode,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF3D3FB8),
                          icon: CupertinoIcons.calendar),
                      label: l10n.showDateLabels,
                      value: s.showDateLabels,
                      onChanged: notifier.setShowDateLabels,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF237A4A),
                          icon: CupertinoIcons.clock_fill),
                      label: l10n.showDurationBadges,
                      value: s.showDurationBadges,
                      onChanged: notifier.setShowDurationBadges,
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── PRIVACY ──────────────────────────────────────────────
                  _SectionLabel(l10n.privacySection),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF4A2A8B),
                          icon: CupertinoIcons.lock_fill),
                      label: l10n.privacyVault,
                      trailingText: isPro ? null : l10n.proBadge,
                      onTap: isPro ? onOpenVault : onOpenPaywall,
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),

                  // ── ABOUT ────────────────────────────────────────────────
                  _SectionLabel(l10n.aboutSection),
                  const SizedBox(height: RRSpace.sp8),
                  _SettingsGroup(rows: [
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF2A6B3A),
                          icon: CupertinoIcons.shield_fill),
                      label: l10n.privacyPolicy,
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF8B6A1A),
                          icon: CupertinoIcons.star_fill),
                      label: l10n.rateApp,
                      onTap: _rateApp,
                    ),
                    Builder(
                      builder: (btnContext) => _NavRow(
                        icon: const _SettingIcon(
                            color: Color(0xFF1A4A8B),
                            icon: CupertinoIcons.share),
                        label: l10n.shareApp,
                        onTap: () => _shareApp(btnContext),
                      ),
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: Color(0xFF2A2D4A),
                          icon: CupertinoIcons.info_circle_fill),
                      label: l10n.version,
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
    final l10n = AppLocalizations.of(context)!;
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.chevron_left,
                      color: RRColors.accentCyan, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    l10n.back,
                    style: const TextStyle(
                      color: RRColors.accentCyan,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            l10n.settings,
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
    final l10n = AppLocalizations.of(context)!;
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
              child: Text(
                l10n.pro,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: RRSpace.sp12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paywallTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.proCardSubtitle,
                    style: const TextStyle(
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
        style: TextStyle(
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
                Divider(height: 1, color: RRColors.divider, indent: 62),
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
              style: TextStyle(color: RRColors.textPrimary, fontSize: 16),
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
    super.key,
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
                style: TextStyle(
                    color: RRColors.textPrimary, fontSize: 16),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                    color: RRColors.textSecond, fontSize: 15),
              ),
              if (showChevron) const SizedBox(width: RRSpace.sp4),
            ],
            if (showChevron)
              Icon(CupertinoIcons.chevron_right,
                  color: RRColors.textDisabled, size: 16),
          ],
        ),
      ),
    );
  }
}
