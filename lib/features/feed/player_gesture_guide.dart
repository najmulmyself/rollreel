import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';

Future<void> showPlayerGestureGuide(BuildContext context) async {
  await showGeneralDialog<void>(
    context: context,
    barrierColor: const Color(0xBD030914),
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => const _PlayerGestureGuide(),
  );
}

enum _Motion { swipe, tap, doubleTap, drag }

typedef _Cue = ({Alignment alignment, IconData icon, _Motion motion});

class _PlayerGestureGuide extends StatefulWidget {
  const _PlayerGestureGuide();

  @override
  State<_PlayerGestureGuide> createState() => _PlayerGestureGuideState();
}

class _PlayerGestureGuideState extends State<_PlayerGestureGuide>
    with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1750),
  );
  int _step = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
      _motion.value = .3;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  void _advance(bool isLast) {
    HapticFeedback.selectionClick();
    if (isLast) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step++);
      if (_motion.isAnimating) _motion.value = 0;
      if (!MediaQuery.disableAnimationsOf(context)) _motion.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      (
        l10n.playerGuideSwipe,
        l10n.playerGuideSwipeBody,
        const <_Cue>[
          (
            alignment: Alignment.center,
            icon: CupertinoIcons.arrow_up,
            motion: _Motion.swipe,
          ),
        ],
      ),
      (
        l10n.playerGuideTap,
        l10n.playerGuideTapBody,
        const <_Cue>[
          (
            alignment: Alignment.center,
            icon: CupertinoIcons.pause_fill,
            motion: _Motion.tap,
          ),
        ],
      ),
      (
        l10n.playerGuideSeek,
        l10n.playerGuideSeekBody,
        const <_Cue>[
          (
            alignment: Alignment(-.58, 0),
            icon: CupertinoIcons.gobackward_10,
            motion: _Motion.doubleTap,
          ),
          (
            alignment: Alignment(.58, 0),
            icon: CupertinoIcons.goforward_10,
            motion: _Motion.doubleTap,
          ),
        ],
      ),
      (
        l10n.playerGuideEdges,
        l10n.playerGuideEdgesBody,
        const <_Cue>[
          (
            alignment: Alignment(-1, 0),
            icon: CupertinoIcons.sun_max,
            motion: _Motion.drag,
          ),
          (
            alignment: Alignment(1, 0),
            icon: CupertinoIcons.speaker_2,
            motion: _Motion.drag,
          ),
        ],
      ),
    ];
    final (title, body, cues) = steps[_step];
    final last = _step == steps.length - 1;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ExcludeSemantics(
                    child: AnimatedBuilder(
                      animation: _motion,
                      builder: (context, _) => Stack(
                        fit: StackFit.expand,
                        children: [
                          for (final cue in cues)
                            Align(
                              alignment: cue.alignment,
                              child: _GestureCue(
                                icon: cue.icon,
                                motion: cue.motion,
                                progress: _motion.value,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 480,
                    maxHeight: constraints.maxHeight * .68,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF102638),
                      border: Border.all(color: const Color(0x5C75DAF2)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.positionCounter(_step + 1, steps.length),
                            style: RRTypography.caption.copyWith(
                              color: RRColors.accentCyan,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Semantics(
                            header: true,
                            liveRegion: true,
                            child: Text(
                              title,
                              style: RRTypography.title2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            body,
                            style: RRTypography.body.copyWith(
                              color: const Color(0xFFCADDE7),
                              height: 1.36,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 10,
                            runSpacing: 6,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFCADDE7),
                                  minimumSize: const Size(44, 44),
                                ),
                                child: Text(l10n.skip),
                              ),
                              FilledButton(
                                onPressed: () => _advance(last),
                                style: FilledButton.styleFrom(
                                  foregroundColor: RRColors.brandInk,
                                  backgroundColor: RRColors.accentCyan,
                                  minimumSize: const Size(44, 44),
                                ),
                                child: Text(
                                  last
                                      ? l10n.playerGuideDone
                                      : l10n.continueLabel,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GestureCue extends StatelessWidget {
  const _GestureCue({
    required this.icon,
    required this.motion,
    required this.progress,
  });

  final IconData icon;
  final _Motion motion;
  final double progress;

  double _pulse(double center) =>
      (1 - (progress - center).abs() / .11).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final pulse = switch (motion) {
      _Motion.tap => _pulse(.34),
      _Motion.doubleTap => math.max(_pulse(.25), _pulse(.47)),
      _ => 0.0,
    };
    final dy = switch (motion) {
      _Motion.swipe => 28 - 56 * Curves.easeInOut.transform(progress),
      _Motion.drag => 24 * math.cos(progress * math.pi * 2),
      _ => 0.0,
    };

    final size = motion == _Motion.drag ? 56.0 : 68.0 + 12 * pulse;
    return SizedBox(
      width: motion == _Motion.drag ? size : 84,
      height: 124,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (motion == _Motion.swipe || motion == _Motion.drag)
            Container(
              width: 2,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0x7E75DAF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Transform.translate(
            offset: Offset(0, dy),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: RRColors.accentCyan, width: 2),
                color: const Color(0xD41C4E62),
              ),
              child: Icon(icon, color: Colors.white, size: 29),
            ),
          ),
        ],
      ),
    );
  }
}
