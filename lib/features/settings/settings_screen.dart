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
      backgroundColor: RRColors.bgTint,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNav(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, 48),
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
                          color: RRColors.iconOrange,
                          icon: CupertinoIcons.arrow_2_circlepath),
                      label: l10n.loopShortVideos,
                      sublabel: l10n.loopShortVideosSub,
                      value: s.loopShortVideos,
                      onChanged: notifier.setLoopShortVideos,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconGreen,
                          icon: CupertinoIcons.play_fill),
                      label: l10n.autoPlayOnLaunch,
                      sublabel: l10n.autoPlayOnLaunchSub,
                      value: s.autoPlay,
                      onChanged: notifier.setAutoPlay,
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconRed,
                          icon: CupertinoIcons.slider_horizontal_3),
                      label: l10n.defaultFilter,
                      sublabel: l10n.defaultFilterSub,
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
                          color: RRColors.iconPurple,
                          icon: CupertinoIcons.moon_stars_fill),
                      label: l10n.darkMode,
                      sublabel: l10n.darkModeSub,
                      value: s.darkMode,
                      onChanged: notifier.setDarkMode,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconBlue,
                          icon: CupertinoIcons.calendar),
                      label: l10n.showDateLabels,
                      sublabel: l10n.showDateLabelsSub,
                      value: s.showDateLabels,
                      onChanged: notifier.setShowDateLabels,
                    ),
                    _ToggleRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconGreen,
                          icon: CupertinoIcons.clock_fill),
                      label: l10n.showDurationBadges,
                      sublabel: l10n.showDurationBadgesSub,
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
                          color: RRColors.iconBlue,
                          icon: CupertinoIcons.shield_fill),
                      label: l10n.privacySettingsTitle,
                      sublabel: l10n.privacySettingsSub,
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
                          color: RRColors.iconTeal,
                          icon: CupertinoIcons.shield_fill),
                      label: l10n.privacyPolicy,
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconOrange,
                          icon: CupertinoIcons.star_fill),
                      label: l10n.rateApp,
                      onTap: _rateApp,
                    ),
                    Builder(
                      builder: (btnContext) => _NavRow(
                        icon: const _SettingIcon(
                            color: RRColors.iconBlue,
                            icon: CupertinoIcons.share),
                        label: l10n.shareApp,
                        onTap: () => _shareApp(btnContext),
                      ),
                    ),
                    _NavRow(
                      icon: const _SettingIcon(
                          color: RRColors.iconPurple,
                          icon: CupertinoIcons.info_circle_fill),
                      label: l10n.version,
                      trailingText: '$_version (Build $_build)',
                      showChevron: false,
                    ),
                  ]),
                  const SizedBox(height: RRSpace.sp24),
                  Center(
                    child: Text(
                      'RollReel v$_version',
                      style: TextStyle(
                        color: RRColors.textDisabled,
                        fontSize: 12,
                      ),
                    ),
                  ),
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
                      color: RRColors.accentViolet, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    l10n.back,
                    style: const TextStyle(
                      color: RRColors.accentViolet,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pro banner ───────────────────────────────────────────────────────────────

  Widget _buildProBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = l10n.proCardSubtitle.split(' · ');
    const featureIcons = [
      CupertinoIcons.eye_slash,
      CupertinoIcons.lock_fill,
      CupertinoIcons.bolt_fill,
      CupertinoIcons.folder_fill,
    ];

    return GestureDetector(
      onTap: onOpenPaywall,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(RRSpace.sp16),
            decoration: BoxDecoration(
              gradient: RRColors.gradPro,
              borderRadius: BorderRadius.circular(RRSpace.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder app-badge icon — swap for the real
                    // ribbon/medal asset once provided.
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.military_tech_rounded,
                        color: Color(0xFFFFB347),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: RRSpace.sp12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 70),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(RRSpace.radiusFull),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.workspace_premium_rounded,
                                      color: Colors.white, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.pro,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.paywallTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.proCardTagline,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RRSpace.sp16),
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.18)),
                const SizedBox(height: RRSpace.sp12),
                Row(
                  children: [
                    for (var i = 0; i < features.length; i++) ...[
                      Icon(featureIcons[i % featureIcons.length],
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 13),
                      const SizedBox(width: 5),
                      Text(
                        features[i],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (i < features.length - 1) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 11,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Placeholder for the 3D glass play-button render — swap for the
          // real asset once provided.
          Positioned(
            top: 8,
            right: 12,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
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
          color: RRColors.accentViolet.withValues(alpha: 0.65),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++) ...[
              rows[i],
              if (i < rows.length - 1)
                Divider(height: 1, color: RRColors.divider, indent: 72),
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 20),
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
    this.sublabel,
  });

  final Widget icon;
  final String label;
  final String? sublabel;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: RRColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (sublabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sublabel!,
                    style: TextStyle(color: RRColors.textSecond, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: RRColors.accentViolet,
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
    this.sublabel,
    this.trailingText,
    this.onTap,
    this.showChevron = true,
  });

  final Widget icon;
  final String label;
  final String? sublabel;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: RRColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (sublabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sublabel!,
                      style:
                          TextStyle(color: RRColors.textSecond, fontSize: 13),
                    ),
                  ],
                ],
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
