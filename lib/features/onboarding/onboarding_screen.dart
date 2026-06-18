import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final void Function(PermissionState) onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _index = 0;
  bool _requesting = false;

  Future<void> _requestAccess() async {
    setState(() => _requesting = true);
    final result = await PhotoManager.requestPermissionExtend();
    if (mounted) {
      setState(() => _requesting = false);
      widget.onDone(result);
    }
  }

  void _next() => _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: Stack(
        children: [
          _BackgroundGlows(index: _index),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Skip
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      RRSpace.sp20, RRSpace.sp8, RRSpace.sp20, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => widget.onDone(PermissionState.notDetermined),
                      style: TextButton.styleFrom(
                        foregroundColor: RRColors.textSecond,
                        padding: const EdgeInsets.symmetric(
                            horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),

                // Pages (visual + text)
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: const [_Page1(), _Page2(), _Page3()],
                  ),
                ),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(RRSpace.radiusFull),
                        gradient: active ? RRColors.gradBrand : null,
                        color: active
                            ? null
                            : RRColors.textDisabled
                                .withValues(alpha: 0.5),
                      ),
                    );
                  }),
                ),

                // CTA button
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      RRSpace.sp20, RRSpace.sp20, RRSpace.sp20, RRSpace.sp32),
                  child: PrimaryButton(
                    label: switch (_index) {
                      0 => 'Get Started',
                      1 => 'Continue',
                      _ => _requesting ? 'Requesting…' : 'Allow Access',
                    },
                    onPressed: switch (_index) {
                      0 => _next,
                      1 => _next,
                      _ => _requesting ? null : _requestAccess,
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Background ───────────────────────────────────────────────────────────────

class _BackgroundGlows extends StatelessWidget {
  const _BackgroundGlows({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left coral glow — all pages
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  RRColors.accentCoral.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom violet/cyan glow — pages 2 & 3
        AnimatedOpacity(
          opacity: index > 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    RRColors.accentViolet.withValues(alpha: 0.12),
                    RRColors.accentCyan.withValues(alpha: 0.08),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Page 1 ───────────────────────────────────────────────────────────────────

class _Page1 extends StatelessWidget {
  const _Page1();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(flex: 1),
        _CardStack(),
        SizedBox(height: 20),
        _SwipeHint(),
        Spacer(flex: 2),
        _PageText(
          title: 'Your Videos.\nFinally Watchable.',
          body:
              'Swipe through your camera roll like a real feed. No uploads, no accounts. Just your memories.',
        ),
        SizedBox(height: RRSpace.sp24),
      ],
    );
  }
}

class _CardStack extends StatelessWidget {
  const _CardStack();

  static const double _w = 178.0;
  static const double _h = 128.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: _h + 50,
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          // Back card – maroon
          Positioned(
            left: 65,
            top: 22,
            child: Transform.rotate(
              angle: 0.25,
              alignment: Alignment.bottomLeft,
              child: const _VideoCard(
                width: _w,
                height: _h,
                color: Color(0xFF4A1030),
              ),
            ),
          ),
          // Middle card – navy
          Positioned(
            left: 32,
            top: 10,
            child: Transform.rotate(
              angle: 0.13,
              alignment: Alignment.bottomLeft,
              child: const _VideoCard(
                width: _w,
                height: _h,
                color: Color(0xFF1A2650),
              ),
            ),
          ),
          // Front card – olive green
          Transform.rotate(
            angle: -0.025,
            child: const _VideoCard(
              width: _w,
              height: _h,
              color: Color(0xFF2D4822),
              showContent: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.width,
    required this.height,
    required this.color,
    this.showContent = false,
  });

  final double width;
  final double height;
  final Color color;
  final bool showContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RRSpace.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: showContent
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meal Prep Sunday',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Today · 2:34',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

class _SwipeHint extends StatelessWidget {
  const _SwipeHint();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(CupertinoIcons.chevron_up, color: RRColors.accentCyan, size: 13),
        SizedBox(height: 3),
        Text(
          'SWIPE',
          style: TextStyle(
            color: RRColors.accentCyan,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }
}

// ─── Page 2 ───────────────────────────────────────────────────────────────────

class _Page2 extends StatelessWidget {
  const _Page2();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(flex: 1),
        _PrivacyVisual(),
        Spacer(flex: 2),
        _PageText(
          title: '100% Private.\n100% Yours.',
          body:
              'Your videos never leave your phone. No cloud, no sign-in, no tracking. Just you.',
        ),
        SizedBox(height: RRSpace.sp24),
      ],
    );
  }
}

class _PrivacyVisual extends StatelessWidget {
  const _PrivacyVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: const [
          Icon(
            CupertinoIcons.lock_fill,
            size: 82,
            color: RRColors.accentViolet,
          ),
          // No Cloud – left
          Positioned(
            left: -18,
            top: 28,
            child: _PillLabel('No Cloud'),
          ),
          // No Account – top right
          Positioned(
            right: -28,
            top: 2,
            child: _PillLabel('No Account'),
          ),
          // No Tracking – bottom center
          Positioned(
            bottom: 0,
            child: _PillLabel('No Tracking'),
          ),
        ],
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: RRColors.bgElevated,
        borderRadius: BorderRadius.circular(RRSpace.radiusFull),
        border: Border.all(
          color: RRColors.accentViolet.withValues(alpha: 0.55),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Page 3 ───────────────────────────────────────────────────────────────────

class _Page3 extends StatelessWidget {
  const _Page3();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(flex: 1),
        _PhotoAccessVisual(),
        Spacer(flex: 2),
        _PageText(
          title: "Let's Find\nYour Videos",
          body:
              'RollReel needs access to your photo library to show your videos. They stay on your device, always.',
        ),
        SizedBox(height: RRSpace.sp24),
      ],
    );
  }
}

class _PhotoAccessVisual extends StatelessWidget {
  const _PhotoAccessVisual();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp24),
      child: Column(
        children: [
          const Icon(
            Icons.image_outlined,
            size: 64,
            color: RRColors.accentCoral,
          ),
          const SizedBox(height: RRSpace.sp16),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MiniThumb(color: Color(0xFF2D4822)),
              SizedBox(width: RRSpace.sp8),
              _MiniThumb(color: Color(0xFF4A3010)),
              SizedBox(width: RRSpace.sp8),
              _MiniThumb(color: Color(0xFF4A1030)),
            ],
          ),
          const SizedBox(height: RRSpace.sp16),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: RRSpace.sp16, vertical: RRSpace.sp12),
            decoration: BoxDecoration(
              color: RRColors.bgElevated.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(RRSpace.radiusMd),
              border: Border.all(
                  color: RRColors.accentCyan.withValues(alpha: 0.30)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.info_circle,
                    size: 16, color: RRColors.accentCyan),
                const SizedBox(width: RRSpace.sp8),
                Expanded(
                  child: Text(
                    'We only read videos — never photos, never uploads.',
                    style: TextStyle(
                        color: RRColors.textSecond, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniThumb extends StatelessWidget {
  const _MiniThumb({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RRSpace.radiusMd),
      ),
    );
  }
}

// ─── Shared text block ────────────────────────────────────────────────────────

class _PageText extends StatelessWidget {
  const _PageText({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp24),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: '.SF Pro Display',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: Colors.white,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RRSpace.sp12),
          Text(
            body,
            style: RRTypography.body.copyWith(
              color: RRColors.textSecond,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
