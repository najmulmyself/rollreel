import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'onboarding_layout.dart';
import 'onboarding_sample.dart';
import 'onboarding_style.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final void Function(PermissionState) onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _step = 0;
  bool _requesting = false;
  bool _couldNotRequest = false;
  bool _finishing = false;

  bool get _busy => _requesting || _finishing;

  void _finish(PermissionState permission) {
    setState(() => _finishing = true);
    widget.onDone(permission);
  }

  void _skip() {
    if (_busy) return;
    HapticFeedback.selectionClick();
    _finish(PermissionState.notDetermined);
  }

  Future<void> _requestAccess() async {
    if (_busy) return;
    HapticFeedback.selectionClick();
    setState(() {
      _requesting = true;
      _couldNotRequest = false;
    });

    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (mounted) {
        _requesting = false;
        _finish(permission);
      }
    } on Exception {
      if (!mounted) return;
      setState(() {
        _requesting = false;
        _couldNotRequest = true;
      });
    }
  }

  void _moveTo(int index) {
    if (_busy) return;
    HapticFeedback.selectionClick();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.jumpToPage(index);
    } else {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPermission = _step == 2;

    return OnboardingLayout(
      step: _step,
      primaryLabel: switch (_step) {
        0 => l10n.onboardingTrySwipe,
        1 => l10n.continueLabel,
        _ when _requesting => l10n.requesting,
        _ when _couldNotRequest => l10n.retry,
        _ => l10n.onboardingChooseVideos,
      },
      onPrimary: _busy
          ? null
          : isPermission
          ? _requestAccess
          : () => _moveTo(_step + 1),
      onBack: _step > 0 && !_busy ? () => _moveTo(_step - 1) : null,
      onSkip: !isPermission && !_busy ? _skip : null,
      secondaryLabel: isPermission ? l10n.onboardingNotNow : null,
      onSecondary: _busy ? null : _skip,
      body: PageView(
        controller: _controller,
        physics: _busy ? const NeverScrollableScrollPhysics() : null,
        onPageChanged: (index) => setState(() => _step = index),
        children: [
          _OnboardingPage(
            title: l10n.onboardingTitle,
            subtitle: l10n.onboardingSubtitle,
            titleGap: 26,
            fullBleed: true,
            child: const _WelcomeArtwork(),
          ),
          _OnboardingPage(
            title: l10n.onboardingSwipeTitle,
            subtitle: l10n.onboardingSwipeSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 21),
                OnboardingSample(active: _step == 1),
                const SizedBox(height: 14),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      start: BorderSide(color: Color(0xFF359BB9), width: 3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15),
                    child: Text(
                      l10n.onboardingPrivacyBody,
                      style: const OnboardingStyle().body.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _OnboardingPage(
            title: l10n.onboardingPermissionTitle,
            subtitle: l10n.onboardingAccessBody,
            titleGap: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                _AccessRow(
                  icon: CupertinoIcons.photo,
                  title: l10n.onboardingLimitedTitle,
                  description: l10n.onboardingLimitedBody,
                ),
                _AccessRow(
                  icon: CupertinoIcons.square_on_square,
                  title: l10n.onboardingFullTitle,
                  description: l10n.onboardingFullBody,
                ),
                if (_couldNotRequest)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.onboardingPermissionError,
                      style: const OnboardingStyle().body.copyWith(
                        fontSize: 14,
                      ),
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.titleGap = 16,
    this.fullBleed = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final double titleGap;
  final bool fullBleed;

  @override
  Widget build(BuildContext context) {
    const style = OnboardingStyle();
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = MediaQuery.sizeOf(context).height < 660;
        return SingleChildScrollView(
          padding: EdgeInsets.only(top: compact ? 2 : 15, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: compact ? 8 : titleGap),
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: style.title(constraints.maxWidth),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(subtitle, style: style.body),
                  ],
                ),
              ),
              if (fullBleed)
                child
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: child,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeArtwork extends StatelessWidget {
  const _WelcomeArtwork();

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.sizeOf(context).height * .34).clamp(
      210.0,
      312.0,
    );
    final mascot = MediaQuery.disableAnimationsOf(context)
        ? 'assets/images/onboarding-kingfisher.webp'
        : 'assets/images/onboarding-kingfisher-wave.webp';

    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: -constraints.maxWidth * .05,
                  right: -constraints.maxWidth * .07,
                  bottom: height * .06,
                  height: height * .42,
                  child: Transform.rotate(
                    angle: -.10472,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1C122B42),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 4,
                          children: [
                            for (final (name, weight) in [
                              ('dinner', 105),
                              ('coast', 124),
                              ('drive', 92),
                            ])
                              Expanded(
                                flex: weight,
                                child: Image.asset(
                                  'assets/images/onboarding-$name.webp',
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth * .12,
                  bottom: height * .04,
                  height: height * .87,
                  child: Image.asset(mascot, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessRow extends StatelessWidget {
  const _AccessRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    const style = OnboardingStyle();
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: style.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Icon(icon, size: 22, color: style.action)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: RRTypography.headline.copyWith(
                      color: style.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: style.body.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
