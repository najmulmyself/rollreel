import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';

final _packageInfoProvider = FutureProvider((_) => PackageInfo.fromPlatform());

Color get _background =>
    RRColors.isDark.value ? RRColors.bgDeep : const Color(0xFFF4FAFF);
Color get _surface => RRColors.bgSurface;
Color get _line =>
    RRColors.isDark.value ? RRColors.divider : const Color(0xFFE0EBF2);
Color get _ink =>
    RRColors.isDark.value ? RRColors.textPrimary : RRColors.brandInk;
Color get _muted =>
    RRColors.isDark.value ? RRColors.textSecond : RRColors.brandMutedInk;
Color get _accent =>
    RRColors.isDark.value ? const Color(0xFFA9DFFF) : RRColors.brandBlue;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
    required this.active,
    required this.onOpenPaywall,
    required this.onOpenVault,
  });

  final bool active;
  final VoidCallback onOpenPaywall;
  final VoidCallback onOpenVault;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  bool _restoring = false;

  Future<void> _restorePurchases() async {
    if (_restoring) return;
    HapticFeedback.selectionClick();
    setState(() => _restoring = true);
    final completed = await ref.read(iapProvider.notifier).restore();
    if (!mounted) return;
    setState(() => _restoring = false);
    if (!widget.active) return;
    final l10n = AppLocalizations.of(context)!;
    final message = !completed
        ? l10n.settingsRestoreFailed
        : ref.read(isProProvider)
        ? l10n.settingsProActive
        : l10n.settingsRestoreComplete;
    _messenger.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: RRColors.isDark.value
              ? RRColors.bgElevated
              : RRColors.brandInk,
          content: Text(
            message,
            style: RRTypography.subheadline.copyWith(color: Colors.white),
          ),
        ),
      );
  }

  Future<void> _rateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing(appStoreId: '6781843410');
    }
  }

  void _shareApp(BuildContext rowContext) {
    final l10n = AppLocalizations.of(rowContext)!;
    final box = rowContext.findRenderObject() as RenderBox?;
    // The share sheet must be anchored to the row on iPad.
    final origin = box == null
        ? Rect.zero
        : box.localToGlobal(Offset.zero) & box.size;
    Share.share(
      '${l10n.shareAppMessage}\nhttps://apps.apple.com/app/id6781843410',
      sharePositionOrigin: origin,
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(
      'https://najmulmyself.github.io/rollreel/privacy.html',
    );
    if (await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.privacyPolicy),
        content: Text(l10n.privacyPolicyBody),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDefaultFilter(FeedFilter current) async {
    HapticFeedback.selectionClick();
    final selection = await showModalBottomSheet<FeedFilter>(
      context: context,
      backgroundColor: _surface,
      barrierColor: RRColors.isDark.value
          ? Colors.black54
          : const Color(0x6A0B2033),
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : const AnimationStyle(
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 160),
            ),
      builder: (_) => _DefaultFilterSheet(current: current),
    );
    if (!mounted || selection == null || selection == current) return;
    await ref.read(settingsProvider.notifier).setDefaultFilter(selection);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isPro = ref.watch(isProProvider);
    final package = ref.watch(_packageInfoProvider).valueOrNull;

    return AnnotatedRegion(
      value:
          (settings.darkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
      child: ScaffoldMessenger(
        key: _messenger,
        child: Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SettingsHeader(title: l10n.settings, active: widget.active),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: ListView(
                        key: const PageStorageKey('settings'),
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                        children: [
                          _SettingsGroup(
                            children: [
                              _ProBanner(
                                isPro: isPro,
                                onPressed: widget.onOpenPaywall,
                              ),
                              _SettingsRow(
                                icon: CupertinoIcons.arrow_clockwise,
                                label: l10n.restorePurchases,
                                onTap: _restoring ? null : _restorePurchases,
                                accessory: _restoring
                                    ? CupertinoActivityIndicator(
                                        color: _accent,
                                        radius: 8,
                                      )
                                    : _chevron(),
                              ),
                            ],
                          ),
                          _SettingsSection(
                            title: l10n.playbackSection,
                            rows: [
                              _SettingsToggle(
                                icon: CupertinoIcons.arrow_2_circlepath,
                                label: l10n.loopShortVideos,
                                description: l10n.loopShortVideosSub,
                                value: settings.loopShortVideos,
                                onChanged: notifier.setLoopShortVideos,
                              ),
                              _SettingsToggle(
                                icon: CupertinoIcons.play_circle,
                                label: l10n.autoPlayOnLaunch,
                                description: l10n.autoPlayOnLaunchSub,
                                value: settings.autoPlay,
                                onChanged: notifier.setAutoPlay,
                              ),
                              _SettingsRow(
                                icon: CupertinoIcons.slider_horizontal_3,
                                label: l10n.defaultFilter,
                                description: l10n.defaultFilterSub,
                                value: _filterLabel(
                                  l10n,
                                  settings.defaultFilter,
                                ),
                                onTap: () =>
                                    _pickDefaultFilter(settings.defaultFilter),
                              ),
                            ],
                          ),
                          _SettingsSection(
                            title: l10n.appearanceSection,
                            rows: [
                              _SettingsToggle(
                                icon: CupertinoIcons.moon_stars,
                                label: l10n.darkMode,
                                value: settings.darkMode,
                                onChanged: notifier.setDarkMode,
                              ),
                              _SettingsToggle(
                                icon: CupertinoIcons.calendar,
                                label: l10n.showDateLabels,
                                value: settings.showDateLabels,
                                onChanged: notifier.setShowDateLabels,
                              ),
                              _SettingsToggle(
                                icon: CupertinoIcons.clock,
                                label: l10n.showDurationBadges,
                                value: settings.showDurationBadges,
                                onChanged: notifier.setShowDurationBadges,
                              ),
                            ],
                          ),
                          _SettingsSection(
                            title: l10n.privacySection,
                            rows: [
                              _SettingsRow(
                                icon: CupertinoIcons.lock_shield,
                                label: l10n.privacyVault,
                                description: l10n.settingsVaultDescription,
                                onTap: widget.onOpenVault,
                              ),
                            ],
                          ),
                          _SettingsSection(
                            title: l10n.aboutSection,
                            rows: [
                              _SettingsRow(
                                icon: CupertinoIcons.doc_text,
                                label: l10n.privacyPolicy,
                                onTap: _openPrivacyPolicy,
                              ),
                              _SettingsRow(
                                icon: CupertinoIcons.star,
                                label: l10n.rateApp,
                                onTap: _rateApp,
                              ),
                              Builder(
                                builder: (rowContext) => _SettingsRow(
                                  icon: CupertinoIcons.share,
                                  label: l10n.shareApp,
                                  onTap: () => _shareApp(rowContext),
                                ),
                              ),
                              _SettingsRow(
                                icon: CupertinoIcons.info_circle,
                                label: l10n.version,
                                value:
                                    package == null ||
                                        package.buildNumber.isEmpty
                                    ? package?.version
                                    : '${package.version} (${package.buildNumber})',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _filterLabel(AppLocalizations l10n, FeedFilter filter) =>
    switch (filter) {
      FeedFilter.all => l10n.filterAll,
      FeedFilter.today => l10n.filterToday,
      FeedFilter.shorts => l10n.filterShorts,
      FeedFilter.long => l10n.filterLong,
    };

class _SettingsHeader extends StatefulWidget {
  const _SettingsHeader({required this.title, required this.active});

  final String title;
  final bool active;

  @override
  State<_SettingsHeader> createState() => _SettingsHeaderState();
}

class _SettingsHeaderState extends State<_SettingsHeader> {
  bool _visited = false;

  @override
  void didUpdateWidget(_SettingsHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active && !widget.active) _visited = true;
  }

  @override
  Widget build(BuildContext context) {
    final wave =
        widget.active &&
        !_visited &&
        TickerMode.of(context) &&
        !MediaQuery.disableAnimationsOf(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final dark = RRColors.isDark.value;
    final stacked =
        MediaQuery.sizeOf(context).width < 420 &&
        MediaQuery.textScalerOf(context).scale(38) > 54;
    const resting = Image(
      image: AssetImage('assets/images/onboarding-kingfisher.webp'),
      excludeFromSemantics: true,
      fit: BoxFit.contain,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              PositionedDirectional(
                end: 0,
                top: 0,
                bottom: 0,
                width: 176,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(rtl ? -.34 : .34, .17),
                      radius: 1.45,
                      colors: [
                        dark ? RRColors.bgElevated : const Color(0xFFD2EFFE),
                        _background.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 82),
                alignment: AlignmentDirectional.centerStart,
                padding: stacked
                    ? const EdgeInsetsDirectional.fromSTEB(20, 13, 20, 53)
                    : const EdgeInsetsDirectional.fromSTEB(20, 13, 94, 13),
                child: Semantics(
                  header: true,
                  child: Text(
                    widget.title,
                    style: RRTypography.title1.copyWith(
                      fontSize: 38,
                      height: 1.05,
                      letterSpacing: -1.5,
                      color: _ink,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                end: 24,
                bottom: 4,
                width: stacked ? 33 : 51,
                height: stacked ? 49 : 77,
                child: Transform.flip(
                  flipX: rtl,
                  child: wave
                      ? Image.asset(
                          'assets/images/onboarding-kingfisher-wave.webp',
                          excludeFromSemantics: true,
                          fit: BoxFit.contain,
                          frameBuilder: (_, child, frame, _) =>
                              frame == null ? resting : child,
                          errorBuilder: (_, _, _) => resting,
                        )
                      : resting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBanner extends StatelessWidget {
  const _ProBanner({required this.isPro, required this.onPressed});

  final bool isPro;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = RRColors.isDark.value;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: dark
                ? [RRColors.bgElevated, RRColors.bgSurface]
                : const [Color(0xFF0D3B67), Color(0xFF135D97)],
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 78),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    width: 38,
                    height: 38,
                    cacheWidth: 114,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.paywallTitle,
                        style: RRTypography.headline.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isPro
                            ? l10n.settingsProActive
                            : l10n.settingsProDescription,
                        style: RRTypography.caption.copyWith(
                          color: const Color(0xFFD8ECF8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _chevron(color: const Color(0xFFE5F3FC)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: RRTypography.title2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsGroup(children: rows, divided: true),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children, this.divided = false});

  final List<Widget> children;
  final bool divided;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (divided && index > 0) _settingsDivider(),
            children[index],
          ],
        ],
      ),
    );
  }
}

Widget _settingsDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 48, end: 12),
  child: Divider(height: 1, thickness: 1, color: _line),
);

Widget _chevron({Color? color}) =>
    Icon(CupertinoIcons.chevron_forward, size: 13, color: color ?? _accent);

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.description,
    this.value,
    this.accessory,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? description;
  final String? value;
  final Widget? accessory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final trailing = value;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 53),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 26, child: Icon(icon, size: 19, color: _accent)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: RRTypography.headline.copyWith(
                      color: _ink,
                      fontSize: 15,
                    ),
                  ),
                  if (description case final description?) ...[
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: RRTypography.caption.copyWith(
                        color: _muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  trailing,
                  textAlign: TextAlign.end,
                  style: RRTypography.caption.copyWith(
                    color: _muted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            if (accessory != null || onTap != null) ...[
              const SizedBox(width: 8),
              accessory ?? _chevron(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
  });

  final IconData icon;
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = RRColors.isDark.value;
    return MergeSemantics(
      child: _SettingsRow(
        icon: icon,
        label: label,
        description: description,
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(!value);
        },
        accessory: Transform.scale(
          scale: .82,
          alignment: AlignmentDirectional.centerEnd,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: dark ? _accent : const Color(0xFF0C619E),
            inactiveTrackColor: dark
                ? const Color(0xFF4B4B5C)
                : const Color(0xFFC1D1DC),
            thumbColor: dark ? RRColors.bgDeep : Colors.white,
            inactiveThumbColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _DefaultFilterSheet extends StatelessWidget {
  const _DefaultFilterSheet({required this.current});

  final FeedFilter current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: RRColors.isDark.value
                      ? RRColors.textDisabled
                      : const Color(0xFFB9CDDC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.defaultFilter,
                      style: RRTypography.title2.copyWith(
                        fontSize: 25,
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.libraryClose,
                    style: RRTypography.subheadline.copyWith(
                      color: _accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.settingsFilterDescription,
              style: RRTypography.body.copyWith(color: _muted, fontSize: 15),
            ),
            const SizedBox(height: 10),
            for (final filter in FeedFilter.values) ...[
              Semantics(
                checked: filter == current,
                inMutuallyExclusiveGroup: true,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context, filter);
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 47),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _filterLabel(l10n, filter),
                            style: RRTypography.body.copyWith(
                              fontSize: 15,
                              color: filter == current ? _accent : _ink,
                              fontWeight: filter == current
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (filter == current)
                          Icon(
                            CupertinoIcons.check_mark,
                            size: 15,
                            color: _accent,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: _line),
            ],
          ],
        ),
      ),
    );
  }
}
