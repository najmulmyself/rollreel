import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../l10n/app_localizations.dart';
import 'onboarding_style.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final void Function(PermissionState) onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;
  bool _requesting = false;
  bool _couldNotRequest = false;

  Future<void> _requestAccess() async {
    if (_requesting) return;
    setState(() {
      _requesting = true;
      _couldNotRequest = false;
    });

    final PermissionState permission;
    try {
      permission = await PhotoManager.requestPermissionExtend();
    } on Exception {
      if (!mounted) return;
      setState(() {
        _requesting = false;
        _couldNotRequest = true;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _requesting = false);
    widget.onDone(permission);
  }

  void _moveTo(int index) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _controller.jumpToPage(index);
    } else {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 280),
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
    final style = OnboardingStyle.current;
    final pages = [
      (title: l10n.onboardingTitle, body: l10n.onboardingSubtitle),
      (title: l10n.onboardingPrivacyTitle, body: l10n.onboardingPrivacyBody),
      (
        title: l10n.onboardingPermissionTitle,
        body: l10n.onboardingPermissionBody,
      ),
    ];
    final isLast = _index == pages.length - 1;
    final actionLabel = switch (_index) {
      0 => l10n.getStarted,
      1 => l10n.continueLabel,
      _ => _requesting ? l10n.requesting : l10n.allowAccess,
    };

    return AnnotatedRegion(
      value: style.systemOverlay,
      child: Scaffold(
        backgroundColor: style.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 12, 6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/icons/icon.png',
                            width: 28,
                            height: 28,
                            excludeFromSemantics: true,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'RollReel',
                            style: style
                                .title(19)
                                .copyWith(letterSpacing: -0.5),
                          ),
                        ),
                        TextButton(
                          onPressed: _requesting
                              ? null
                              : () => widget.onDone(
                                  PermissionState.notDetermined,
                                ),
                          style: TextButton.styleFrom(
                            foregroundColor: style.secondary,
                            minimumSize: const Size(48, 48),
                            textStyle: style.label,
                          ),
                          child: Text(l10n.skip),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      allowImplicitScrolling: true,
                      physics: _requesting
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      onPageChanged: (index) => setState(() => _index = index),
                      children: [
                        for (var index = 0; index < pages.length; index++)
                          _OnboardingPage(
                            index: index,
                            count: pages.length,
                            title: pages[index].title,
                            body: pages[index].body,
                            note: index == pages.length - 1
                                ? l10n.onboardingPermissionNote
                                : null,
                            style: style,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 9, 24, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isLast && _couldNotRequest)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                l10n.onboardingPermissionError,
                                style: style.body.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            if (_index > 0) ...[
                              Tooltip(
                                message: l10n.back,
                                excludeFromSemantics: true,
                                child: OutlinedButton(
                                  onPressed: _requesting
                                      ? null
                                      : () => _moveTo(_index - 1),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: style.ink,
                                    visualDensity: VisualDensity.standard,
                                    fixedSize: const Size(54, 54),
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(color: style.line),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Semantics(
                                    label: l10n.back,
                                    child: const BackButtonIcon(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: FilledButton(
                                onPressed: _requesting
                                    ? null
                                    : isLast
                                    ? _requestAccess
                                    : () => _moveTo(_index + 1),
                                style: style.primaryButton,
                                child: Text(
                                  actionLabel,
                                  textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.index,
    required this.count,
    required this.title,
    required this.body,
    required this.note,
    required this.style,
  });

  final int index;
  final int count;
  final String title;
  final String body;
  final String? note;
  final OnboardingStyle style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 370;
        final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
        // Keep room for the permission explanation on short phones.
        final copySpace = compact ? 272 : 238;
        final artworkHeight =
            (constraints.maxHeight - copySpace - (textScale - 1) * 100)
                .clamp(132.0, 400.0)
                .toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: artworkHeight,
                child: ExcludeSemantics(
                  child: _OnboardingArtwork(index: index, style: style),
                ),
              ),
              SizedBox(height: constraints.maxHeight < 480 ? 16 : 25),
              Semantics(
                label: AppLocalizations.of(
                  context,
                )!.onboardingStep(index + 1, count),
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      for (var step = 0; step < count; step++)
                        Container(
                          width: 22,
                          height: 3,
                          margin: const EdgeInsetsDirectional.only(end: 5),
                          decoration: BoxDecoration(
                            color: step == index ? style.progress : style.line,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: compact ? style.title(28) : style.title(),
                ),
              ),
              const SizedBox(height: 10),
              Text(body, style: style.body),
              if (note case final note?) ...[
                const SizedBox(height: 11),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        CupertinoIcons.info_circle,
                        color: style.secondary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        note,
                        style: style.body.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OnboardingArtwork extends StatelessWidget {
  const _OnboardingArtwork({required this.index, required this.style});

  static const _coast = 'assets/images/onboarding-coast.webp';
  static const _dinner = 'assets/images/onboarding-dinner.webp';
  static const _drive = 'assets/images/onboarding-drive.webp';
  final int index;
  final OnboardingStyle style;

  Widget _photo(String asset, {Alignment alignment = Alignment.center}) =>
      Image.asset(asset, fit: BoxFit.cover, alignment: alignment);

  Widget _badge(IconData icon, {Color? background}) => DecoratedBox(
    decoration: BoxDecoration(
      color: background ?? style.artworkAccent,
      shape: BoxShape.circle,
    ),
    child: SizedBox.square(
      dimension: 44,
      child: Icon(icon, color: style.artworkFrame, size: 19),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: ColoredBox(
        color: style.artworkFrame,
        child: switch (index) {
          0 => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _photo(_coast, alignment: const Alignment(0, 0.22)),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x66000000)],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 15,
                      start: 15,
                      child: _badge(
                        CupertinoIcons.play_fill,
                        background: const Color(0xFFF9F6F0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _photo(_dinner)),
                    const SizedBox(height: 3),
                    Expanded(
                      child: _photo(
                        _drive,
                        alignment: const Alignment(0, 0.17),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          1 => Stack(
            fit: StackFit.expand,
            children: [
              _photo(_dinner, alignment: const Alignment(0, -0.04)),
              PositionedDirectional(
                bottom: 15,
                end: 15,
                child: _badge(CupertinoIcons.lock_fill),
              ),
            ],
          ),
          _ => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _photo(_dinner)),
              const SizedBox(width: 3),
              Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _photo(_drive, alignment: const Alignment(0, 0.25)),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(color: style.artworkAccent, width: 2),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 15,
                      end: 15,
                      child: _badge(CupertinoIcons.check_mark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: _photo(_coast, alignment: const Alignment(0, 0.25)),
              ),
            ],
          ),
        },
      ),
    );
  }
}
