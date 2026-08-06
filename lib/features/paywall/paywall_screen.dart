import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';

const String kTermsOfUseUrl =
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
const String kPrivacyPolicyUrl =
    'https://najmulmyself.github.io/rollreel/privacy.html';

// ─── Feature data ─────────────────────────────────────────────────────────────

enum _FeatureId { adFree, vault, speed, onThisDay }

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.color,
    required this.id,
    this.solid = false,
  });

  final IconData icon;
  final Color color;
  final _FeatureId id;
  // Ad-Free renders as a solid-fill tile (white icon); the rest are
  // light-tinted tiles with a colored icon, matching the reference.
  final bool solid;
}

const List<_FeatureData> _kFeatures = [
  _FeatureData(
    icon: Icons.visibility_off_rounded,
    color: RRColors.iconGreen,
    id: _FeatureId.adFree,
    solid: true,
  ),
  _FeatureData(
    icon: CupertinoIcons.lock_fill,
    color: RRColors.accentViolet,
    id: _FeatureId.vault,
  ),
  _FeatureData(
    icon: CupertinoIcons.clock_fill,
    color: RRColors.accentBlue,
    id: _FeatureId.speed,
  ),
  _FeatureData(
    icon: CupertinoIcons.calendar_today,
    color: RRColors.accentPink,
    id: _FeatureId.onThisDay,
  ),
];

// ─── Plan enum ────────────────────────────────────────────────────────────────

enum _Plan { lifetime, monthly }

extension _PlanX on _Plan {
  String get productId =>
      this == _Plan.lifetime ? kProductLifetime : kProductMonthly;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  _Plan _selected = _Plan.lifetime;

  void _purchase() {
    final iap = ref.read(iapProvider.notifier);
    iap.purchase(_selected.productId);
  }

  void _restore() {
    ref.read(iapProvider.notifier).restore();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iap = ref.watch(iapProvider);
    final isPro = ref.watch(isProProvider);

    // Show error once via SnackBar
    ref.listen<IAPState>(iapProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: RRColors.accentCoral,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: RRColors.bgTint,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 48),
        child: Column(
          children: [
            _buildHeader(context, isPro),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Feature list ─────────────────────────────────────────
                  Container(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: RRSpace.sp16),
                    child: Column(
                      children: [
                        for (var i = 0; i < _kFeatures.length; i++) ...[
                          _FeatureRow(data: _kFeatures[i]),
                          if (i < _kFeatures.length - 1)
                            Divider(height: 1, color: RRColors.divider),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp20),

                  // ── Pricing cards ────────────────────────────────────────
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _PricingCard(
                            plan: _Plan.lifetime,
                            selected: _selected == _Plan.lifetime,
                            price: iap.products[kProductLifetime]?.price,
                            onTap: () =>
                                setState(() => _selected = _Plan.lifetime),
                          ),
                        ),
                        const SizedBox(width: RRSpace.sp12),
                        Expanded(
                          child: _PricingCard(
                            plan: _Plan.monthly,
                            selected: _selected == _Plan.monthly,
                            price: iap.products[kProductMonthly]?.price,
                            onTap: () =>
                                setState(() => _selected = _Plan.monthly),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp20),

                  // ── CTA button ───────────────────────────────────────────
                  GestureDetector(
                    onTap: (iap.loading || isPro) ? null : _purchase,
                    child: Container(
                      height: RRSpace.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: RRColors.gradVioletPink,
                        borderRadius:
                            BorderRadius.circular(RRSpace.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: RRColors.accentViolet.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: iap.loading
                          ? const CupertinoActivityIndicator(
                              color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.workspace_premium_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isPro
                                      ? l10n.youArePro
                                      : l10n.unlockProForever,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp16),

                  // ── Footer ───────────────────────────────────────────────
                  _FooterBadges(text: l10n.lifetimeFooter),
                  const SizedBox(height: RRSpace.sp16),
                  GestureDetector(
                    onTap: iap.loading ? null : _restore,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.arrow_counterclockwise,
                            color: RRColors.accentViolet, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          l10n.restorePurchases,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: RRColors.accentViolet,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp12),
                  Text(
                    l10n.oneTimeDisclaimer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RRColors.textDisabled,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _openUrl(kTermsOfUseUrl),
                        child: Text(
                          l10n.termsOfUse,
                          style: TextStyle(
                            color: RRColors.textSecond,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: RRSpace.sp16),
                      GestureDetector(
                        onTap: () => _openUrl(kPrivacyPolicyUrl),
                        child: Text(
                          l10n.privacyPolicy,
                          style: TextStyle(
                            color: RRColors.textSecond,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle _titleBaseStyle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  // Colors the last word (typically "Pro") violet; falls back to a solid
  // title when the string has no separate last word to split.
  List<TextSpan> _titleSpans(String title) {
    final lastSpace = title.lastIndexOf(' ');
    if (lastSpace < 0) {
      return [
        TextSpan(
            text: title,
            style: _titleBaseStyle.copyWith(color: RRColors.textPrimary)),
      ];
    }
    return [
      TextSpan(
        text: '${title.substring(0, lastSpace)} ',
        style: _titleBaseStyle.copyWith(color: RRColors.textPrimary),
      ),
      TextSpan(
        text: title.substring(lastSpace + 1),
        style: _titleBaseStyle.copyWith(color: RRColors.accentViolet),
      ),
    ];
  }

  // ── Header (badge + title + hero image) ──────────────────────────────────

  Widget _buildHeader(BuildContext context, bool isPro) {
    final l10n = AppLocalizations.of(context)!;
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(RRSpace.sp16, topPad + 12, RRSpace.sp16, 0),
      child: Column(
        children: [
          // PRO/ACTIVE badge + close button
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: RRSpace.sp16, vertical: RRSpace.sp8),
                decoration: BoxDecoration(
                  color: RRColors.bgElevated,
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                  border: Border.all(
                      color: RRColors.accentViolet.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: Color(0xFFFFB347), size: 15),
                    const SizedBox(width: 6),
                    Text(
                      isPro ? l10n.active : l10n.pro,
                      style: const TextStyle(
                        color: RRColors.accentViolet,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: RRColors.bgElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black.withValues(alpha: 0.08)),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: RRColors.textPrimary,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: _titleSpans(l10n.paywallTitle)),
          ),
          const SizedBox(height: RRSpace.sp8),
          Text(
            l10n.paywallTagline,
            style: TextStyle(
              color: RRColors.textSecond,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Image.asset(
            'assets/images/paywall_hero_light.png',
            width: double.infinity,
            height: 230,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ─── Footer badges (icon + label per "·"-separated segment, "|" between) ─────

class _FooterBadges extends StatelessWidget {
  const _FooterBadges({required this.text});

  final String text;

  static const _icons = [
    CupertinoIcons.checkmark_shield_fill,
    CupertinoIcons.star_fill,
    CupertinoIcons.arrow_2_circlepath,
  ];

  @override
  Widget build(BuildContext context) {
    final segments = text.split(' · ');
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < segments.length; i++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icons[i % _icons.length],
                  color: RRColors.accentViolet, size: 13),
              const SizedBox(width: 5),
              Text(
                segments[i],
                style: TextStyle(color: RRColors.textSecond, fontSize: 13),
              ),
            ],
          ),
          if (i < segments.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp12),
              child: Text('|',
                  style: TextStyle(color: RRColors.divider, fontSize: 13)),
            ),
        ],
      ],
    );
  }
}

// ─── Feature row ──────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.data});

  final _FeatureData data;

  static String _title(AppLocalizations l10n, _FeatureId id) {
    switch (id) {
      case _FeatureId.adFree:
        return l10n.featureAdFree;
      case _FeatureId.vault:
        return l10n.featureVault;
      case _FeatureId.speed:
        return l10n.featureSpeed;
      case _FeatureId.onThisDay:
        return l10n.featureOnThisDay;
    }
  }

  static String _subtitle(AppLocalizations l10n, _FeatureId id) {
    switch (id) {
      case _FeatureId.adFree:
        return l10n.featureAdFreeSub;
      case _FeatureId.vault:
        return l10n.featureVaultSub;
      case _FeatureId.speed:
        return l10n.featureSpeedSub;
      case _FeatureId.onThisDay:
        return l10n.featureOnThisDaySub;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RRSpace.sp12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  data.solid ? data.color : data.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon,
                color: data.solid ? Colors.white : data.color, size: 20),
          ),
          const SizedBox(width: RRSpace.sp16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(l10n, data.id),
                  style: TextStyle(
                    color: RRColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(l10n, data.id),
                  style: TextStyle(
                    color: RRColors.textSecond,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: RRSpace.sp12),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: RRColors.accentViolet.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(CupertinoIcons.check_mark,
                color: RRColors.accentViolet, size: 15),
          ),
        ],
      ),
    );
  }
}

// ─── Pricing card ─────────────────────────────────────────────────────────────

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.plan,
    required this.selected,
    required this.onTap,
    this.price,
  });

  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;
  final String? price;

  bool get _isLifetime => plan == _Plan.lifetime;

  String get _displayPrice {
    if (price != null) return price!;
    return _isLifetime ? '\$4.99' : '\$0.99';
  }

  List<String> _bullets(AppLocalizations l10n) {
    return _isLifetime
        ? [l10n.bulletLifetimeAccess, l10n.bulletAllProFeatures, l10n.bulletFutureUpdates]
        : [l10n.bulletAllProFeatures, l10n.bulletFutureUpdates];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _isLifetime ? RRColors.accentViolet : RRColors.accentBlue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
            RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, RRSpace.sp16),
        decoration: BoxDecoration(
          color: RRColors.bgElevated,
          borderRadius: BorderRadius.circular(RRSpace.radiusLg),
          border: Border.all(
              color: selected ? accent : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_isLifetime)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: RRColors.accentViolet,
                      borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                    ),
                    child: Text(
                      l10n.bestValue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (selected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(CupertinoIcons.check_mark,
                        color: Colors.white, size: 13),
                  ),
              ],
            ),
            const SizedBox(height: RRSpace.sp8),
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  _isLifetime
                      ? CupertinoIcons.money_dollar_circle_fill
                      : CupertinoIcons.star_fill,
                  color: accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: RRSpace.sp8),
            Center(
              child: Text(
                _isLifetime ? 'RollReel Pro' : 'RollReel Plus',
                style: TextStyle(
                  color: RRColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                _displayPrice,
                maxLines: 1,
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                l10n.onePaymentLabel,
                style: TextStyle(
                  color: RRColors.textSecond,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: RRSpace.sp12),
            Divider(height: 1, color: RRColors.divider),
            const SizedBox(height: RRSpace.sp8),
            for (final bullet in _bullets(l10n))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(CupertinoIcons.check_mark,
                          color: Colors.white, size: 10),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bullet,
                        style: TextStyle(
                          color: RRColors.textPrimary,
                          fontSize: 13,
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
}
