import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'onboarding_style.dart';

class OnboardingSample extends StatefulWidget {
  const OnboardingSample({super.key, required this.active});

  final bool active;

  @override
  State<OnboardingSample> createState() => _OnboardingSampleState();
}

class _OnboardingSampleState extends State<OnboardingSample> {
  static const _clips = [
    'assets/images/onboarding-sample-first.mp4',
    'assets/images/onboarding-sample-next.mp4',
  ];
  static const _posters = [
    'assets/images/onboarding-sample-poster.webp',
    'assets/images/onboarding-sample-next-poster.webp',
  ];

  VideoPlayerController? _controller;
  bool _reduceMotion = false;
  int _index = 0;
  double _drag = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _updatePlayback();
  }

  @override
  void didUpdateWidget(OnboardingSample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _updatePlayback();
  }

  void _updatePlayback() {
    if (!widget.active || _reduceMotion) {
      _release();
    } else if (_controller == null) {
      unawaited(_play());
    }
  }

  Future<void> _play() async {
    final controller = VideoPlayerController.asset(_clips[_index]);
    _controller = controller;
    try {
      await controller.initialize();
      if (!identical(_controller, controller)) return;
      await controller.setVolume(0);
      if (!identical(_controller, controller)) return;
      await controller.play();
      if (mounted && identical(_controller, controller)) setState(() {});
    } on Exception {
      // Keep the bundled poster visible when video playback is unavailable.
    }
  }

  void _release() {
    final controller = _controller;
    _controller = null;
    unawaited(controller?.dispose());
  }

  void _next() {
    HapticFeedback.selectionClick();
    _release();
    setState(() => _index = (_index + 1) % _clips.length);
    _updatePlayback();
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;
    return AspectRatio(
      aspectRatio: 1.52,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: (_) => _drag = 0,
          onVerticalDragUpdate: (details) => _drag += details.delta.dy,
          onVerticalDragEnd: (_) {
            if (_drag < -26) _next();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _posters[_index],
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
              if (controller != null && controller.value.isInitialized)
                ExcludeSemantics(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox.fromSize(
                      size: controller.value.size,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
              PositionedDirectional(
                start: 12,
                top: 12,
                child: Semantics(
                  liveRegion: true,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xD90B203A),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      child: Text(
                        l10n.onboardingSampleClip(_index + 1, _clips.length),
                        style: RRTypography.caption.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                end: 10,
                bottom: 10,
                child: IconButton(
                  onPressed: _next,
                  tooltip: l10n.onboardingNextSample,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF7FBFE),
                    foregroundColor: const OnboardingStyle().action,
                    fixedSize: const Size.square(44),
                  ),
                  icon: const Icon(CupertinoIcons.arrow_up, size: 21),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
