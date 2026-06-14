import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/vault/vault_provider.dart';
import 'dynamic_bg.dart';

class VideoFeedItem extends ConsumerStatefulWidget {
  const VideoFeedItem({
    super.key,
    required this.asset,
    required this.isActive,
    required this.onControllerReady,
  });

  final AssetEntity asset;
  final bool isActive;
  final void Function(VideoPlayerController?) onControllerReady;

  @override
  ConsumerState<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends ConsumerState<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
    _initController();
  }

  Future<void> _loadThumbnail() async {
    final bytes = await widget.asset
        .thumbnailDataWithSize(const ThumbnailSize(400, 700));
    if (mounted) setState(() => _thumbnail = bytes);
  }

  Future<void> _initController() async {
    final file = await widget.asset.file;
    if (file == null || !mounted) return;

    final ctrl = VideoPlayerController.file(file);
    await ctrl.initialize();
    if (!mounted) {
      await ctrl.dispose();
      return;
    }

    final settings = ref.read(settingsProvider);
    // Loop only short videos (< 30 s) when the toggle is on
    ctrl.setLooping(settings.loopShortVideos && widget.asset.duration < 30);
    ctrl.addListener(_onTick);

    setState(() {
      _controller = ctrl;
      _initialized = true;
    });

    if (widget.isActive) {
      if (settings.autoPlay) await ctrl.play();
      widget.onControllerReady(ctrl);
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(VideoFeedItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive == old.isActive) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.isActive) {
        _controller?.play();
        if (_initialized && _controller != null) {
          widget.onControllerReady(_controller);
        }
      } else {
        _controller?.pause();
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _showOptions(BuildContext context) async {
    final inVault =
        ref.read(vaultIdsProvider).contains(widget.asset.id);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vaultIdsProvider.notifier).toggle(widget.asset.id);
            },
            child: Text(inVault ? 'Remove from Vault' : 'Add to Vault'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _togglePlay() {
    if (!_initialized || _controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  String _date(DateTime dt) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.asset.title ?? _date(widget.asset.createDateTime);
    final subtitle = _date(widget.asset.createDateTime);

    return DynamicBackground(
      thumbnailBytes: _thumbnail,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePlay,
        onDoubleTapDown: (d) {
          HapticFeedback.lightImpact();
          final half = MediaQuery.sizeOf(context).width / 2;
          final offset = d.localPosition.dx > half
              ? const Duration(seconds: 10)
              : const Duration(seconds: -10);
          final next = (_controller?.value.position ?? Duration.zero) + offset;
          _controller?.seekTo(next.isNegative ? Duration.zero : next);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video ──
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

            // ── Loading indicator ──
            if (!_initialized)
              const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),

            // ── Bottom vignette ──
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.45, 1.0],
                  ),
                ),
              ),
            ),

            // ── Video info (bottom-left) ──
            Positioned(
              left: RRSpace.sp16,
              right: 72,
              bottom: RRSpace.sp20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                      shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
                    ),
                  ),
                ],
              ),
            ),

            // ── Right sidebar ──
            Positioned(
              right: RRSpace.sp8,
              bottom: RRSpace.sp24,
              child: _Sidebar(
                asset: widget.asset,
                onOptions: () => _showOptions(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Right sidebar ────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.asset, required this.onOptions});
  final AssetEntity asset;
  final VoidCallback onOptions;

  Future<void> _share() async {
    final file = await asset.file;
    if (file != null) await Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SideBtn(icon: CupertinoIcons.heart),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: _share,
          child: const _SideBtn(icon: CupertinoIcons.share),
        ),
        const SizedBox(height: 22),
        const _SideBtn(icon: CupertinoIcons.bookmark),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: onOptions,
          child: const _SideBtn(icon: CupertinoIcons.ellipsis),
        ),
      ],
    );
  }
}

class _SideBtn extends StatelessWidget {
  const _SideBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: 26,
      shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
    );
  }
}
