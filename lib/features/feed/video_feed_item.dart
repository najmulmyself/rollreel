import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/glass_panel.dart';
import 'dynamic_bg.dart';

class VideoFeedItem extends StatefulWidget {
  const VideoFeedItem({
    super.key,
    required this.asset,
    required this.isActive,
    required this.onShare,
    required this.onMoreOptions,
  });

  final AssetEntity asset;
  final bool isActive;
  final VoidCallback onShare;
  final VoidCallback onMoreOptions;

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showControls = false;
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
    _initController();
  }

  Future<void> _loadThumbnail() async {
    final bytes = await widget.asset.thumbnailDataWithSize(const ThumbnailSize(400, 700));
    if (mounted) setState(() => _thumbnail = bytes);
  }

  Future<void> _initController() async {
    final file = await widget.asset.file;
    if (file == null || !mounted) return;

    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }

    controller.setLooping(true);
    controller.addListener(_onVideoUpdate);

    if (!mounted) {
      controller.removeListener(_onVideoUpdate);
      await controller.dispose();
      return;
    }

    setState(() {
      _controller = controller;
      _initialized = true;
    });

    if (widget.isActive) await controller.play();
  }

  void _onVideoUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(VideoFeedItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      if (widget.isActive) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showControls) setState(() => _showControls = false);
      });
    }
  }

  void _seek(Duration offset) {
    if (!_initialized || _controller == null) return;
    final next = _controller!.value.position + offset;
    _controller!.seekTo(next.isNegative ? Duration.zero : next);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return DynamicBackground(
      thumbnailBytes: _thumbnail,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        onDoubleTapDown: (d) {
          final half = MediaQuery.sizeOf(context).width / 2;
          _seek(d.localPosition.dx > half
              ? const Duration(seconds: 10)
              : const Duration(seconds: -10));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video or thumbnail fallback
            if (_initialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_thumbnail != null)
              Image.memory(_thumbnail!, fit: BoxFit.cover)
            else
              const ColoredBox(color: RRColors.bgDeep),

            // Spinner while loading
            if (!_initialized)
              const Center(child: CupertinoActivityIndicator(color: Colors.white)),

            // Bottom gradient vignette
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Control panel
            Positioned(
              left: RRSpace.sp20,
              right: RRSpace.sp20,
              bottom: safeBottom + RRSpace.sp12,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: _ControlPanel(
                    asset: widget.asset,
                    controller: _controller,
                    initialized: _initialized,
                    onShare: widget.onShare,
                    onMoreOptions: widget.onMoreOptions,
                    onSeek: _seek,
                    onTogglePlay: () {
                      if (_initialized && _controller != null) {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.asset,
    required this.controller,
    required this.initialized,
    required this.onShare,
    required this.onMoreOptions,
    required this.onSeek,
    required this.onTogglePlay,
  });

  final AssetEntity asset;
  final VideoPlayerController? controller;
  final bool initialized;
  final VoidCallback onShare;
  final VoidCallback onMoreOptions;
  final void Function(Duration) onSeek;
  final VoidCallback onTogglePlay;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _date(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title = asset.title ?? _date(asset.createDateTime);
    final duration = Duration(seconds: asset.duration);
    final isPlaying = initialized && (controller?.value.isPlaying ?? false);
    final position = controller?.value.position ?? Duration.zero;
    final total = controller?.value.duration ?? duration;
    final progress = total.inMilliseconds > 0
        ? (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return GlassPanel(
      borderRadius: BorderRadius.circular(RRSpace.radiusXl),
      padding: const EdgeInsets.fromLTRB(RRSpace.sp16, RRSpace.sp12, RRSpace.sp8, RRSpace.sp12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + share
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: RRTypography.headline, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      '${_date(asset.createDateTime)} · ${_fmt(duration)}',
                      style: RRTypography.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onShare,
                icon: const Icon(CupertinoIcons.share, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
            ],
          ),
          const SizedBox(height: RRSpace.sp8),
          // Scrubber
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: RRColors.accentCoral,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
            ),
            child: Slider(
              value: progress,
              onChanged: (v) {
                controller?.seekTo(
                  Duration(milliseconds: (v * total.inMilliseconds).toInt()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(position), style: RRTypography.caption),
                Text(_fmt(total), style: RRTypography.caption),
              ],
            ),
          ),
          const SizedBox(height: RRSpace.sp8),
          // Playback buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.heart, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              ),
              IconButton(
                onPressed: () => onSeek(const Duration(seconds: -10)),
                icon: const Icon(CupertinoIcons.gobackward_10, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              ),
              GestureDetector(
                onTap: onTogglePlay,
                child: Icon(
                  isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              IconButton(
                onPressed: () => onSeek(const Duration(seconds: 10)),
                icon: const Icon(CupertinoIcons.goforward_10, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              ),
              IconButton(
                onPressed: onMoreOptions,
                icon: const Icon(CupertinoIcons.ellipsis_circle, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
