import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

// ─── Feature data ─────────────────────────────────────────────────────────────

enum _Tier { pro, plus }

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.tier,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final _Tier tier;
}

// Phase 1: only features that actually ship today. Plus-exclusive perks
// (On This Day, Memory Reel Auto-Gen, Siri Shortcuts, Early Access) and
// unbuilt Pro perks (Smart Collections, Lock Screen Widget) return once
// they're implemented in a later phase.
const List<_FeatureData> _kFeatures = [
  _FeatureData(
    icon: Icons.visibility_off_rounded,
    iconColor: Color(0xFF1F6B45),
    title: 'Ad-Free Experience',
    subtitle: 'No interruptions, ever',
    tier: _Tier.pro,
  ),
  _FeatureData(
    icon: CupertinoIcons.lock_fill,
    iconColor: Color(0xFF4A2A8B),
    title: 'Privacy Vault',
    subtitle: 'Lock sensitive videos with Face ID',
    tier: _Tier.pro,
  ),
  _FeatureData(
    icon: CupertinoIcons.clock_fill,
    iconColor: Color(0xFF1A5A6B),
    title: 'Playback Speed Control',
    subtitle: '2× fast-forward on long-press',
    tier: _Tier.pro,
  ),
];

// ─── Plan enum ────────────────────────────────────────────────────────────────

enum _Plan { lifetime, annual }

extension _PlanX on _Plan {
  String get productId =>
      this == _Plan.lifetime ? kProductLifetime : kProductAnnual;
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

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: RRColors.bgDeep,
      body: Column(
        children: [
          _buildHeader(context, isPro),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Feature list ─────────────────────────────────────────
                  ..._kFeatures.map((f) => _FeatureRow(
                        data: f,
                        included: f.tier == _Tier.pro ||
                            _selected == _Plan.annual,
                      )),
                  const SizedBox(height: RRSpace.sp20),

                  // ── Pricing cards ────────────────────────────────────────
                  Row(
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
                          plan: _Plan.annual,
                          selected: _selected == _Plan.annual,
                          price: iap.products[kProductAnnual]?.price,
                          onTap: () =>
                              setState(() => _selected = _Plan.annual),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RRSpace.sp20),

                  // ── CTA button ───────────────────────────────────────────
                  GestureDetector(
                    onTap: (iap.loading || isPro) ? null : _purchase,
                    child: Container(
                      height: RRSpace.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: RRColors.gradBrand,
                        borderRadius:
                            BorderRadius.circular(RRSpace.radiusFull),
                      ),
                      alignment: Alignment.center,
                      child: iap.loading
                          ? const CupertinoActivityIndicator(
                              color: Colors.white)
                          : Text(
                              isPro
                                  ? 'You\'re Pro!'
                                  : 'Unlock RollReel Pro',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp12),

                  // ── Footer ───────────────────────────────────────────────
                  Text(
                    _selected == _Plan.lifetime
                        ? 'One-time purchase · No subscription'
                        : 'Auto-renews annually · Cancel anytime',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RRColors.textDisabled,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp16),
                  GestureDetector(
                    onTap: iap.loading ? null : _restore,
                    child: Text(
                      'Restore Purchases',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: RRColors.textSecond,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: RRSpace.sp12),
                  Text(
                    'Payment charged to Apple ID. Subscription auto-renews unless cancelled 24h before period ends.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RRColors.textDisabled,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header (gradient, extends behind status bar) ────────────────────────────

  Widget _buildHeader(BuildContext context, bool isPro) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(RRSpace.sp16, topPad + 12, RRSpace.sp16, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF00D4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // PRO badge + close button
          Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: RRSpace.sp16, vertical: RRSpace.sp4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                ),
                child: Text(
                  isPro ? 'ACTIVE' : 'PRO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp20),
          const Text(
            'RollReel Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: RRSpace.sp8),
          const Text(
            'Watch more. Worry less.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: RRSpace.sp8),
        ],
      ),
    );
  }
}

// ─── Feature row ──────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.data, required this.included});

  final _FeatureData data;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RRSpace.sp12),
      child: Opacity(
        opacity: included ? 1.0 : 0.45,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(data.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: RRSpace.sp16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                          color: RRColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (data.tier == _Tier.plus) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: RRColors.accentCyan
                                .withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(RRSpace.radiusFull),
                          ),
                          child: const Text(
                            'PLUS',
                            style: TextStyle(
                              color: RRColors.accentCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      color: RRColors.textSecond,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: RRSpace.sp12),
            Icon(
              included
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.lock_fill,
              color: included
                  ? RRColors.accentGreen
                  : RRColors.textDisabled,
              size: included ? 24 : 20,
            ),
          ],
        ),
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
    return _isLifetime ? '\$4.99' : '\$14.99/yr';
  }

  String get _subLabel {
    if (_isLifetime) return 'Lifetime Access';
    // For annual, show per-month breakdown if possible
    return '\$1.25/month';
  }

  Widget _inner() {
    return Container(
      padding: const EdgeInsets.all(RRSpace.sp16),
      decoration: BoxDecoration(
        color: RRColors.bgElevated,
        borderRadius: BorderRadius.circular(
            selected ? RRSpace.radiusLg - 1 : RRSpace.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isLifetime
                  ? RRColors.accentAmber.withValues(alpha: 0.2)
                  : RRColors.accentCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(RRSpace.radiusFull),
            ),
            child: Text(
              _isLifetime ? 'RollReel Pro' : 'RollReel Plus',
              style: TextStyle(
                color: _isLifetime
                    ? RRColors.accentAmber
                    : RRColors.accentCyan,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: RRSpace.sp12),
          Text(
            _displayPrice,
            style: TextStyle(
              color: RRColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _subLabel,
            style: TextStyle(
              color: RRColors.textSecond,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: selected
          ? Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [RRColors.accentCyan, RRColors.accentViolet],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(RRSpace.radiusLg + 1),
              ),
              child: _inner(),
            )
          : _inner(),
    );
  }
}
