import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';

enum PaywallEntry { playback, vault, memories, speed }

const _dinner = 'assets/images/onboarding-dinner.webp';
const _coast = 'assets/images/onboarding-coast.webp';
const _drive = 'assets/images/onboarding-drive.webp';
const _kingfisher = 'assets/images/home_kingfisher.webp';

class PaywallArtwork extends StatefulWidget {
  const PaywallArtwork({
    super.key,
    required this.entry,
    required this.dark,
    this.compact = false,
  });

  final PaywallEntry entry;
  final bool dark;
  final bool compact;

  @override
  State<PaywallArtwork> createState() => _PaywallArtworkState();
}

class _PaywallArtworkState extends State<PaywallArtwork>
    with SingleTickerProviderStateMixin {
  late final _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  );
  bool _entered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _entered = true;
      _entrance.value = 1;
    } else if (!_entered) {
      _entered = true;
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entry = widget.entry;
    final inVault = entry == PaywallEntry.vault;
    final memories = entry == PaywallEntry.memories;
    final (heading, promise) = switch (entry) {
      PaywallEntry.playback => (
        l10n.paywallPlaybackTitle,
        l10n.paywallPlaybackBody,
      ),
      PaywallEntry.vault => (l10n.paywallVaultTitle, l10n.paywallVaultBody),
      PaywallEntry.memories => (
        l10n.paywallMemoriesTitle,
        l10n.paywallMemoriesBody,
      ),
      PaywallEntry.speed => (l10n.paywallSpeedTitle, l10n.featureSpeedSub),
    };
    final onDark = inVault || memories || widget.dark;
    final background = switch (entry) {
      PaywallEntry.vault => const Color(0xFF1B2739),
      PaywallEntry.memories => const Color(0xFF24425E),
      _ => widget.dark ? const Color(0xFF111E2B) : const Color(0xFFDFEDF9),
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 328;
        final largeText = MediaQuery.textScalerOf(context).scale(16) > 22;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final titleWidth =
            constraints.maxWidth *
            (largeText
                ? .91
                : narrow
                ? .6
                : .58);
        final mascotHeight = largeText
            ? 106.0
            : narrow
            ? 165.0
            : 194.0;
        final mascot = Transform.flip(
          flipX: rtl,
          child: Image.asset(_kingfisher, fit: BoxFit.contain),
        );
        final scene = inVault
            ? const _VaultFrame()
            : memories
            ? const _MemoryFrames()
            : _Filmstrip(narrow: narrow || largeText);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: onDark ? const Color(0xFF395065) : const Color(0xFFC6DEEE),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: narrow ? 202 : 230),
              child: Stack(
                children: [
                  if (memories)
                    Positioned.fill(
                      child: ExcludeSemantics(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(_coast, fit: BoxFit.cover),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentDirectional.centerStart,
                                  end: AlignmentDirectional.centerEnd,
                                  colors: [
                                    Color(0xF20B2339),
                                    Color(0xDA0E2840),
                                    Color(0x54244760),
                                  ],
                                  stops: [0, .49, 1],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (inVault)
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                            colors: [Color(0xFF1B2739), Color(0xFF243E52)],
                          ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    bottom: 14,
                    start: narrow ? 13 : 17,
                    child: ExcludeSemantics(
                      child: AnimatedBuilder(
                        animation: _entrance,
                        child: scene,
                        builder: (context, child) {
                          final t = Curves.easeOutCubic.transform(
                            _entrance.value,
                          );
                          return Transform.translate(
                            offset: Offset(
                              (rtl ? 1 : -1) * (1 - t) * 15,
                              memories ? (1 - t) * 5 : 0,
                            ),
                            child: Transform.scale(
                              scale: inVault ? .94 + .06 * t : 1,
                              alignment: AlignmentDirectional.centerStart,
                              child: Opacity(
                                opacity: .55 + .45 * t,
                                child: child,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: -2,
                    end: narrow ? 6 : 5,
                    width: mascotHeight / 1.5,
                    height: mascotHeight,
                    child: ExcludeSemantics(
                      child: AnimatedBuilder(
                        animation: _entrance,
                        child: mascot,
                        builder: (context, child) {
                          final t = Curves.easeOutCubic.transform(
                            _entrance.value,
                          );
                          final direction = rtl ? -1 : 1;
                          return Transform.translate(
                            offset: Offset(
                              direction * (1 - t) * 8,
                              (1 - t) * 6,
                            ),
                            child: Transform.rotate(
                              angle: direction * (1 - t) * .07,
                              alignment: const Alignment(0, .75),
                              child: child,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      narrow ? 13 : 17,
                      22,
                      10,
                      largeText ? 109 : 82,
                    ),
                    child: SizedBox(
                      width: titleWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              heading,
                              style: RRTypography.title1.copyWith(
                                color: onDark
                                    ? Colors.white
                                    : RRColors.brandInk,
                                fontSize: widget.compact && largeText
                                    ? 27
                                    : narrow
                                    ? 34
                                    : 38,
                                letterSpacing: -1.7,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            promise,
                            style: RRTypography.subheadline.copyWith(
                              color: onDark
                                  ? const Color(0xFFD4E5F3)
                                  : RRColors.brandMutedInk,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Filmstrip extends StatelessWidget {
  const _Filmstrip({required this.narrow});

  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final side = narrow ? 37.0 : 54.0;
    return SizedBox(
      height: 59,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          _Frame(asset: _dinner, width: side, height: 43),
          _Frame(
            asset: _coast,
            width: narrow ? 60 : 77,
            height: 57,
            focused: true,
          ),
          _Frame(asset: _drive, width: side, height: 43),
        ],
      ),
    );
  }
}

class _MemoryFrames extends StatelessWidget {
  const _MemoryFrames();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 59,
      child: Stack(
        children: [
          PositionedDirectional(
            start: 70,
            bottom: 3,
            child: Transform.rotate(
              angle: .13,
              child: const _Frame(asset: _dinner, width: 95, height: 52),
            ),
          ),
          PositionedDirectional(
            start: 5,
            bottom: 3,
            child: Transform.rotate(
              angle: -.105,
              child: const _Frame(
                asset: _drive,
                width: 99,
                height: 53,
                focused: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultFrame extends StatelessWidget {
  const _VaultFrame();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF122132)),
            Opacity(
              opacity: .32,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Image.asset(_drive, fit: BoxFit.cover, cacheWidth: 360),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0xFF53768E)),
                ),
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(6),
              child: CustomPaint(
                painter: _Viewfinder(color: Color(0xB8FFFFFF)),
              ),
            ),
            const Center(
              child: Icon(
                CupertinoIcons.lock_fill,
                color: Colors.white,
                size: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.asset,
    required this.width,
    required this.height,
    this.focused = false,
  });

  final String asset;
  final double width;
  final double height;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final border = focused ? 2.0 : 1.0;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(border),
      decoration: BoxDecoration(
        color: focused ? Colors.white : const Color(0xFFA2B6C6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover, cacheWidth: 310),
            if (focused)
              const Padding(
                padding: EdgeInsets.all(3),
                child: CustomPaint(painter: _Viewfinder(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

class _Viewfinder extends CustomPainter {
  const _Viewfinder({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const length = 8.0;
    for (final x in [0.0, size.width]) {
      for (final y in [0.0, size.height]) {
        final corner = Offset(x, y);
        canvas.drawLine(
          corner,
          Offset(x + (x == 0 ? length : -length), y),
          paint,
        );
        canvas.drawLine(
          corner,
          Offset(x, y + (y == 0 ? length : -length)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_Viewfinder oldDelegate) => oldDelegate.color != color;
}
