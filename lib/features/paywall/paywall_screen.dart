import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'paywall_artwork.dart';

export 'paywall_artwork.dart' show PaywallEntry;

const _termsUrl =
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
const _privacyUrl = 'https://najmulmyself.github.io/rollreel/privacy.html';

enum _Plan {
  lifetime(kProductLifetime),
  monthly(kProductMonthly);

  const _Plan(this.productId);

  final String productId;
}

Future<void> showSwipePaywall(
  BuildContext context, {
  required VoidCallback onPresented,
}) async {
  final dismissed = showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (context) {
      final needsMoreSpace =
          MediaQuery.sizeOf(context).height < 720 ||
          MediaQuery.textScalerOf(context).scale(16) > 20;
      return FractionallySizedBox(
        heightFactor: needsMoreSpace ? .90 : .75,
        child: const PaywallScreen(compactOffer: true),
      );
    },
  );
  onPresented();
  await dismissed;
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({
    super.key,
    this.entry = PaywallEntry.playback,
    this.compactOffer = false,
  });

  final PaywallEntry entry;
  final bool compactOffer;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  _Plan _selected = _Plan.lifetime;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final store = ref.read(iapProvider);
      if (!store.catalogLoading && store.products.isEmpty) {
        ref.read(iapProvider.notifier).refreshCatalog();
      }
    });
  }

  void _showMessage(String message) {
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

  Future<void> _restore() async {
    if (_restoring) return;
    HapticFeedback.selectionClick();
    setState(() => _restoring = true);
    final completed = await ref.read(iapProvider.notifier).restore();
    if (!mounted) return;
    setState(() => _restoring = false);
    final l10n = AppLocalizations.of(context)!;
    if (!completed) {
      _showMessage(l10n.settingsRestoreFailed);
    } else if (!ref.read(isProProvider)) {
      _showMessage(l10n.settingsRestoreComplete);
    }
  }

  Future<void> _openLegal(String url) async {
    try {
      if (await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } on PlatformException catch (error) {
      debugPrint('Could not open paywall link: $error');
    }
    if (mounted)
      _showMessage(AppLocalizations.of(context)!.paywallLinkUnavailable);
  }

  _Plan _effectiveSelection(IAPState store) {
    if (store.products.containsKey(_selected.productId)) return _selected;
    for (final plan in _Plan.values) {
      if (store.products.containsKey(plan.productId)) return plan;
    }
    return _selected;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = ref.watch(iapProvider);
    final active = ref.watch(isProProvider);
    final dark = ref.watch(
      settingsProvider.select((settings) => settings.darkMode),
    );
    final colors = _PaywallColors(dark);
    final plan = _effectiveSelection(store);
    final product = store.products[plan.productId];

    ref.listen<IAPState>(iapProvider, (previous, next) {
      if (!_restoring && next.error != null && next.error != previous?.error) {
        _showMessage(l10n.purchaseFailed);
      }
    });
    ref.listen<bool>(isProProvider, (previous, next) {
      if (previous == false && next && store.loading) {
        HapticFeedback.mediumImpact();
      }
    });

    final String action;
    final String? billing;
    if (active) {
      action = l10n.continueLabel;
      billing = null;
    } else if (store.catalogLoading) {
      action = l10n.paywallLoadingPrices;
      billing = null;
    } else if (product == null) {
      action = l10n.paywallPricesUnavailable;
      billing = null;
    } else if (plan == _Plan.lifetime) {
      action = l10n.paywallGetLifetime;
      billing = l10n.paywallLifetimeBilling(product.price);
    } else {
      action = l10n.paywallSubscribeMonthly;
      billing = l10n.paywallMonthlyBilling(product.price);
    }

    final checkout = _Checkout(
      colors: colors,
      action: action,
      billing: billing,
      busy: store.loading || _restoring,
      restoring: _restoring,
      onContinue: active
          ? () => Navigator.of(context).pop(true)
          : (store.loading ||
                _restoring ||
                store.catalogLoading ||
                product == null)
          ? null
          : () {
              HapticFeedback.selectionClick();
              ref.read(iapProvider.notifier).purchase(plan.productId);
            },
      onRestore: store.loading || _restoring ? null : _restore,
      onTerms: () => _openLegal(_termsUrl),
      onPrivacy: () => _openLegal(_privacyUrl),
    );

    final content = active
        ? _ActiveNotice(colors: colors)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaywallArtwork(
                entry: widget.entry,
                dark: dark,
                compact: widget.compactOffer,
              ),
              if (!widget.compactOffer) ...[
                const SizedBox(height: 12),
                _Benefits(entry: widget.entry, colors: colors),
              ],
            ],
          );
    final plans = active
        ? null
        : Padding(
            padding: EdgeInsets.only(
              top: widget.entry == PaywallEntry.vault ? 12 : 18,
            ),
            child: _PlanSelector(
              colors: colors,
              entry: widget.entry,
              store: store,
              selected: plan,
              restoring: _restoring,
              onSelect: (next) {
                if (next == plan) return;
                HapticFeedback.selectionClick();
                setState(() => _selected = next);
              },
              onRetry: ref.read(iapProvider.notifier).refreshCatalog,
            ),
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: ScaffoldMessenger(
        key: _messenger,
        child: Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scrollCheckout =
                        constraints.maxHeight < 565 ||
                        MediaQuery.textScalerOf(context).scale(16) > 22;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TopBar(
                          colors: colors,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, viewport) =>
                                SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: viewport.maxHeight,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          active && !scrollCheckout
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            20,
                                            4,
                                            20,
                                            16,
                                          ),
                                          child: content,
                                        ),
                                        if (plans != null || scrollCheckout)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              if (plans != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        20,
                                                        0,
                                                        20,
                                                        16,
                                                      ),
                                                  child: plans,
                                                ),
                                              if (scrollCheckout) checkout,
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        if (!scrollCheckout) checkout,
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaywallColors {
  const _PaywallColors(this.dark);

  final bool dark;
  Color get background => dark ? RRColors.bgDeep : const Color(0xFFF5FAFF);
  Color get panel => dark ? RRColors.bgSurface : Colors.white;
  Color get ink => dark ? RRColors.textPrimary : RRColors.brandInk;
  Color get muted => dark ? RRColors.textSecond : RRColors.brandMutedInk;
  Color get line => dark ? const Color(0xFF262635) : const Color(0xFFD9E6EE);
  Color get selected =>
      dark ? const Color(0xFF14283B) : const Color(0xFFE9F6FF);
  Color get iconTile =>
      dark ? const Color(0xFF182635) : const Color(0xFFE9F4FC);
  Color get accent => dark ? const Color(0xFFA7DEFF) : RRColors.brandBlue;
  Color get onAccent => dark ? RRColors.brandInk : Colors.white;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.colors, required this.onClose});

  final _PaywallColors colors;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20, end: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                'assets/icons/icon.png',
                width: 25,
                height: 25,
                cacheWidth: 75,
                excludeFromSemantics: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.paywallTitle,
                style: RRTypography.headline.copyWith(
                  color: colors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.libraryClose,
              onPressed: onClose,
              color: colors.muted,
              icon: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.panel,
                  border: Border.all(color: colors.line),
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.xmark, size: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits({required this.entry, required this.colors});

  final PaywallEntry entry;
  final _PaywallColors colors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playback = (
      CupertinoIcons.eye_slash,
      l10n.paywallAdFree,
      l10n.paywallAdFreeBody,
    );
    final vault = (
      CupertinoIcons.lock_shield,
      l10n.privacyVault,
      l10n.paywallVaultBenefit,
    );
    final speed = (
      CupertinoIcons.gauge,
      l10n.paywallSpeed,
      l10n.paywallSpeedBenefit,
    );
    final memories = (
      CupertinoIcons.calendar,
      l10n.onThisDay,
      l10n.paywallMemoriesBenefit,
    );
    final benefits = switch (entry) {
      PaywallEntry.playback => [playback, vault, speed, memories],
      PaywallEntry.vault => [vault, playback, speed, memories],
      PaywallEntry.memories => [memories, playback, vault, speed],
      PaywallEntry.speed => [speed, playback, vault, memories],
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        final grid =
            entry == PaywallEntry.vault &&
            constraints.maxWidth >= 305 &&
            MediaQuery.textScalerOf(context).scale(16) <= 20;
        return Wrap(
          spacing: 12,
          children: [
            for (final (icon, title, body) in benefits)
              SizedBox(
                width: grid
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: colors.line)),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: grid ? 72 : 46),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: grid ? 12 : 5),
                      child: Row(
                        crossAxisAlignment: grid
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colors.iconTile,
                            ),
                            child: Icon(icon, color: colors.accent, size: 15),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: RRTypography.headline.copyWith(
                                    color: colors.ink,
                                    fontSize: 13.5,
                                  ),
                                ),
                                Text(
                                  body,
                                  style: RRTypography.caption.copyWith(
                                    color: colors.muted,
                                    height: 1.24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlanSelector extends StatelessWidget {
  const _PlanSelector({
    required this.colors,
    required this.entry,
    required this.store,
    required this.selected,
    required this.restoring,
    required this.onSelect,
    required this.onRetry,
  });

  final _PaywallColors colors;
  final PaywallEntry entry;
  final IAPState store;
  final _Plan selected;
  final bool restoring;
  final ValueChanged<_Plan> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showRetry =
        !store.catalogLoading && store.products.length < _Plan.values.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l10n.paywallChoosePlan,
                  style: RRTypography.headline.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (showRetry)
              TextButton(
                onPressed: store.loading || restoring ? null : onRetry,
                style: TextButton.styleFrom(foregroundColor: colors.accent),
                child: Text(l10n.retry),
              ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                entry == PaywallEntry.vault ||
                constraints.maxWidth < 305 ||
                MediaQuery.textScalerOf(context).scale(16) > 19;
            return Wrap(
              spacing: 8,
              runSpacing: 7,
              children: [
                for (final plan in _Plan.values)
                  SizedBox(
                    width: stacked
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 8) / 2,
                    child: _PlanCard(
                      plan: plan,
                      product: store.products[plan.productId],
                      catalogLoading: store.catalogLoading,
                      enabled:
                          !store.loading && !restoring && !store.catalogLoading,
                      selected:
                          selected == plan &&
                          store.products.containsKey(plan.productId),
                      stacked: stacked,
                      colors: colors,
                      onTap: () => onSelect(plan),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.product,
    required this.catalogLoading,
    required this.enabled,
    required this.selected,
    required this.stacked,
    required this.colors,
    required this.onTap,
  });

  final _Plan plan;
  final ProductDetails? product;
  final bool catalogLoading;
  final bool enabled;
  final bool selected;
  final bool stacked;
  final _PaywallColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lifetime = plan == _Plan.lifetime;
    final price = product?.price;
    final name = Text(
      lifetime ? l10n.paywallLifetime : l10n.paywallMonthly,
      style: RRTypography.headline.copyWith(color: colors.ink, fontSize: 14),
    );
    final interval = Text(
      lifetime ? l10n.onePaymentLabel : l10n.paywallRenewsMonthly,
      style: RRTypography.caption.copyWith(color: colors.muted),
    );
    final priceLabel = _priceLabel(l10n, price, lifetime);
    final indicator = Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.accent : colors.muted,
          width: selected ? 4 : 1,
        ),
      ),
    );
    final actionable = enabled && product != null;
    return Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      enabled: actionable,
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? colors.selected : colors.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? colors.accent : colors.line),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: actionable ? onTap : null,
            child: Container(
              constraints: BoxConstraints(minHeight: stacked ? 54 : 90),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              child: stacked
                  ? LayoutBuilder(
                      builder: (context, constraints) => Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                name,
                                const SizedBox(height: 2),
                                interval,
                              ],
                            ),
                          ),
                          const SizedBox(width: 7),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * .44,
                            ),
                            child: priceLabel,
                          ),
                          const SizedBox(width: 8),
                          indicator,
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: name),
                            indicator,
                          ],
                        ),
                        const SizedBox(height: 3),
                        priceLabel,
                        const SizedBox(height: 3),
                        interval,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceLabel(AppLocalizations l10n, String? price, bool lifetime) {
    final alignment = stacked ? TextAlign.end : TextAlign.start;
    if (catalogLoading || price == null) {
      return Text(
        catalogLoading ? l10n.homeLoading : l10n.homeUnavailable,
        textAlign: alignment,
        style: RRTypography.caption.copyWith(color: colors.muted, fontSize: 13),
      );
    }
    final amount = TextSpan(
      text: price,
      style: RRTypography.headline.copyWith(
        fontSize: stacked ? 18 : 21,
        color: colors.ink,
        fontWeight: FontWeight.w700,
      ),
    );
    if (lifetime) return Text.rich(amount, textAlign: alignment);

    final monthly = l10n.paywallMonthlyPrice(price);
    final start = monthly.indexOf(price);
    return Text.rich(
      TextSpan(
        style: RRTypography.caption.copyWith(color: colors.muted),
        children: [
          TextSpan(text: monthly.substring(0, start)),
          amount,
          TextSpan(text: monthly.substring(start + price.length)),
        ],
      ),
      textAlign: alignment,
    );
  }
}

class _Checkout extends StatelessWidget {
  const _Checkout({
    required this.colors,
    required this.action,
    required this.billing,
    required this.busy,
    required this.restoring,
    required this.onContinue,
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
  });

  final _PaywallColors colors;
  final String action;
  final String? billing;
  final bool busy;
  final bool restoring;
  final VoidCallback? onContinue;
  final VoidCallback? onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = onContinue != null && !busy;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: enabled ? onContinue : null,
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.standard,
                backgroundColor: colors.accent,
                foregroundColor: colors.onAccent,
                disabledBackgroundColor: colors.accent.withValues(alpha: .24),
                disabledForegroundColor: colors.ink,
                minimumSize: const Size.fromHeight(48),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                textStyle: RRTypography.headline.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      busy ? l10n.homeLoading : action,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (busy) ...[
                    const SizedBox(width: 8),
                    CupertinoActivityIndicator(color: colors.ink, radius: 8),
                  ] else if (enabled) ...[
                    const SizedBox(width: 7),
                    const Icon(CupertinoIcons.arrow_right, size: 14),
                  ],
                ],
              ),
            ),
            if (billing case final text?)
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 3),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: RRTypography.caption.copyWith(
                      color: colors.muted,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (final (label, callback) in [
                  (
                    restoring ? l10n.homeLoading : l10n.restorePurchases,
                    onRestore,
                  ),
                  (l10n.termsOfUse, onTerms),
                  (l10n.privacyPolicy, onPrivacy),
                ])
                  TextButton(
                    onPressed: callback,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.accent,
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      textStyle: RRTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(label),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveNotice extends StatelessWidget {
  const _ActiveNotice({required this.colors});

  final _PaywallColors colors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        children: [
          Image.asset(
            'assets/images/home_kingfisher.webp',
            width: 104,
            height: 156,
            excludeFromSemantics: true,
          ),
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: Text(
              l10n.settingsProActive,
              textAlign: TextAlign.center,
              style: RRTypography.title1.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.bulletAllProFeatures,
            textAlign: TextAlign.center,
            style: RRTypography.body.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
