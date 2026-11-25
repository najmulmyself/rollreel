import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';

String homeClipHeroTag(String id) => 'home-watch-next-$id';

class HomeClipPoster extends StatelessWidget {
  const HomeClipPoster({super.key, required this.bytes, required this.fit});

  final Uint8List? bytes;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: Color(0xFF0C2639),
      child: Center(
        child: Icon(CupertinoIcons.film, size: 28, color: Colors.white54),
      ),
    );
    final data = bytes;
    if (data == null) return placeholder;
    return Image.memory(
      data,
      fit: fit,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class HomeClipPlayer extends StatefulWidget {
  const HomeClipPlayer({
    super.key,
    required this.asset,
    required this.title,
    required this.poster,
  });

  final AssetEntity asset;
  final String title;
  final Uint8List? poster;

  @override
  State<HomeClipPlayer> createState() => _HomeClipPlayerState();
}

class _HomeClipPlayerState extends State<HomeClipPlayer> {
  VideoPlayerController? _controller;
  Animation<double>? _routeAnimation;
  bool _failed = false;
  bool _transitionFinished = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animation = ModalRoute.of(context)?.animation;
    if (_routeAnimation == animation && animation != null) return;
    _routeAnimation?.removeStatusListener(_onRouteStatus);
    _routeAnimation = animation;
    animation?.addStatusListener(_onRouteStatus);
    if (animation == null || animation.isCompleted) _transitionFinished = true;
  }

  void _onRouteStatus(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      unawaited(_controller?.pause());
      return;
    }
    if (status != AnimationStatus.completed || _transitionFinished) return;
    setState(() => _transitionFinished = true);
    final controller = _controller;
    if (controller != null) unawaited(_play(controller));
  }

  Future<void> _load() async {
    VideoPlayerController? controller;
    try {
      final file = await widget.asset.file;
      if (!mounted) return;
      if (file == null) throw StateError('The video file is unavailable');
      controller = VideoPlayerController.file(file);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      controller.addListener(_onPlaybackChanged);
      if (_transitionFinished) await _play(controller);
    } catch (error) {
      await controller?.dispose();
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _play(VideoPlayerController controller) async {
    if (ModalRoute.of(context)?.isCurrent == false) return;
    try {
      await controller.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _onPlaybackChanged() {
    if (!_failed && _controller?.value.hasError == true) {
      setState(() => _failed = true);
    }
  }

  void _retry() {
    final controller = _controller;
    controller?.removeListener(_onPlaybackChanged);
    setState(() {
      _controller = null;
      _failed = false;
    });
    controller?.dispose();
    _load();
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteStatus);
    _controller?.removeListener(_onPlaybackChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orientationWidth = widget.asset.orientatedWidth;
    final orientationHeight = widget.asset.orientatedHeight;
    final ratio = orientationWidth > 0 && orientationHeight > 0
        ? orientationWidth / orientationHeight
        : 16 / 9;
    final controller = _controller;
    final ready = controller != null && _transitionFinished && !_failed;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF06101A),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final width = math.min(size.width, size.height * .62 * ratio);
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: (size.width - width) / 2,
                  top: (size.height - width / ratio) / 2,
                  width: width,
                  height: width / ratio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      HeroMode(
                        enabled: !MediaQuery.disableAnimationsOf(context),
                        child: Hero(
                          tag: homeClipHeroTag(widget.asset.id),
                          child: HomeClipPoster(
                            bytes: widget.poster,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (ready)
                        ColoredBox(
                          color: const Color(0xFF06101A),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        )
                      else if (_transitionFinished && !_failed)
                        const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: (size.height + width / ratio) / 2 + 16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: RRTypography.headline.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_failed)
                  Center(
                    child: ColoredBox(
                      color: const Color(0xEE06101A),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.homePlaybackFailed,
                              style: const TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: _retry,
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 0,
                  start: 8,
                  child: SafeArea(
                    bottom: false,
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
                if (ready)
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 4,
                    child: SafeArea(
                      top: false,
                      child: _PlaybackControls(controller: controller),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final labels = AppLocalizations.of(context)!;
        final duration = value.duration.inMilliseconds;
        final position = value.position.inMilliseconds.clamp(0, duration);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor: const Color(0xFF75DAF2),
                inactiveTrackColor: const Color(0xFF556470),
                thumbColor: const Color(0xFF75DAF2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              ),
              child: Slider(
                value: duration == 0 ? 0 : position / duration,
                onChanged: duration == 0
                    ? null
                    : (fraction) => controller.seekTo(
                        Duration(milliseconds: (duration * fraction).round()),
                      ),
              ),
            ),
            IconButton(
              tooltip: value.isPlaying ? labels.homePause : labels.homePlay,
              onPressed: () =>
                  value.isPlaying ? controller.pause() : controller.play(),
              icon: Icon(
                value.isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
