import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../core/settings/settings_provider.dart';
import '../../core/theme/spacing.dart';
import '../../core/vault/vault_provider.dart';
import 'dynamic_bg.dart';

class VideoFeedItem extends ConsumerStatefulWidget {
  const VideoFeedItem({
    super.key,
    required this.asset,
    required this.isActive,
    required this.onControllerReady,
    this.onDelete,
  });

  final AssetEntity asset;
  final bool isActive;
  final void Function(VideoPlayerController?) onControllerReady;
  final VoidCallback? onDelete;

  @override
  ConsumerState<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends ConsumerState<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  Uint8List? _thumbnail;
  bool _showPlayIcon = false;
  bool _iconIsPlay = false;

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

  void _togglePlay() {
    if (!_initialized || _controller == null) return;
    final wasPlaying = _controller!.value.isPlaying;
    setState(() {
      _showPlayIcon = true;
      _iconIsPlay = !wasPlaying;
    });
    if (wasPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) setState(() => _showPlayIcon = false);
    });
  }

  Future<void> _openLandscape(BuildContext context) async {
    final wasPlaying = _controller?.value.isPlaying ?? false;
    final position = _controller?.value.position;
    final navigator = Navigator.of(context);
    await _controller?.pause();
    if (!mounted) return;

    await navigator.push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _LandscapeVideoPage(
        asset: widget.asset,
        startPosition: position,
      ),
    ));

    if (mounted && wasPlaying) _controller?.play();
  }

  Future<void> _showOptions(BuildContext context) async {
    final inVault = ref.read(vaultIdsProvider).contains(widget.asset.id);
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
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            child: const Text('Delete Video'),
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

  Future<void> _showLongPressSheet(BuildContext context) async {
    HapticFeedback.mediumImpact();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => _VideoInfoSheet(asset: widget.asset),
              );
            },
            child: const Text('Get Info'),
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

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return DynamicBackground(
      thumbnailBytes: _thumbnail,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePlay,
        onLongPress: () => _showLongPressSheet(context),
        onDoubleTapDown: (d) {
          HapticFeedback.lightImpact();
          final half = MediaQuery.sizeOf(context).width / 2;
          final offset = d.localPosition.dx > half
              ? const Duration(seconds: 10)
              : const Duration(seconds: -10);
          final next =
              (_controller?.value.position ?? Duration.zero) + offset;
          _controller?.seekTo(next.isNegative ? Duration.zero : next);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video at native aspect ratio ───────────────────────────────
            if (_initialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_thumbnail != null)
              Center(
                child: Image.memory(_thumbnail!, fit: BoxFit.contain),
              )
            else
              const ColoredBox(color: Colors.black),

            // ── Loading indicator ──────────────────────────────────────────
            if (!_initialized)
              const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),

            // ── Top vignette ───────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom vignette ────────────────────────────────────────────
            const Positioned.fill(
              child: IgnorePointer(
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
            ),

            // ── Tap flash: play/pause icon ─────────────────────────────────
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showPlayIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                child: Center(
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.52),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _iconIsPlay
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // ── Right sidebar — vertically centered ────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                    right: RRSpace.sp16, bottom: safeBottom + 56),
                child: _Sidebar(
                  asset: widget.asset,
                  onLandscape: () => _openLandscape(context),
                  onOptions: () => _showOptions(context),
                ),
              ),
            ),

            // ── Seek bar + time ────────────────────────────────────────────
            Positioned(
              left: RRSpace.sp20,
              right: RRSpace.sp20,
              bottom: safeBottom + 20,
              child: _controller != null
                  ? _VideoSeekBar(controller: _controller!)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Right sidebar ────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.asset,
    required this.onLandscape,
    required this.onOptions,
  });
  final AssetEntity asset;
  final VoidCallback onLandscape;
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
        _SideBtn(icon: CupertinoIcons.heart, onTap: () {}),
        const SizedBox(height: 28),
        _SideBtn(icon: CupertinoIcons.share, onTap: _share),
        const SizedBox(height: 28),
        _SideBtn(icon: Icons.fullscreen_rounded, onTap: onLandscape),
        const SizedBox(height: 28),
        _SideBtn(icon: CupertinoIcons.ellipsis, onTap: onOptions),
      ],
    );
  }
}

class _SideBtn extends StatelessWidget {
  const _SideBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          color: Colors.white,
          size: 27,
          shadows: const [Shadow(blurRadius: 10, color: Colors.black54)],
        ),
      ),
    );
  }
}

// ─── Shared seek bar ──────────────────────────────────────────────────────────

class _VideoSeekBar extends StatelessWidget {
  const _VideoSeekBar({required this.controller});
  final VideoPlayerController controller;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final totalMs = value.duration.inMilliseconds;
        final posMs = value.position.inMilliseconds;
        final progress =
            totalMs > 0 ? (posMs / totalMs).clamp(0.0, 1.0) : 0.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            final w = context.size?.width ?? 1;
            controller.seekTo(Duration(
                milliseconds:
                    ((d.localPosition.dx / w).clamp(0.0, 1.0) * totalMs)
                        .toInt()));
          },
          onHorizontalDragUpdate: (d) {
            final w = context.size?.width ?? 1;
            controller.seekTo(Duration(
                milliseconds:
                    ((d.localPosition.dx / w).clamp(0.0, 1.0) * totalMs)
                        .toInt()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_fmt(value.position),
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 10.5)),
                  Text(_fmt(value.duration),
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 10.5)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Landscape fullscreen page ────────────────────────────────────────────────

class _LandscapeVideoPage extends StatefulWidget {
  const _LandscapeVideoPage({required this.asset, this.startPosition});
  final AssetEntity asset;
  final Duration? startPosition;

  @override
  State<_LandscapeVideoPage> createState() => _LandscapeVideoPageState();
}

class _LandscapeVideoPageState extends State<_LandscapeVideoPage> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showPlayIcon = false;
  bool _iconIsPlay = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initController();
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
    if (widget.startPosition != null) {
      await ctrl.seekTo(widget.startPosition!);
    }
    await ctrl.play();
    setState(() {
      _controller = ctrl;
      _initialized = true;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final ctrl = _controller;
    if (ctrl == null) return;
    final wasPlaying = ctrl.value.isPlaying;
    setState(() {
      _showPlayIcon = true;
      _iconIsPlay = !wasPlaying;
    });
    if (wasPlaying) {
      ctrl.pause();
    } else {
      ctrl.play();
    }
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) setState(() => _showPlayIcon = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePlay,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video at native ratio ──────────────────────────────────────
            if (_initialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),

            // ── Bottom vignette ────────────────────────────────────────────
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xBB000000)],
                      stops: [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Play/pause flash ───────────────────────────────────────────
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showPlayIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                child: Center(
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.52),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _iconIsPlay
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // ── Close button (top-left) ────────────────────────────────────
            Positioned(
              top: safe.top + 12,
              left: safe.left + 12,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fullscreen_exit_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // ── Seek bar (bottom) ──────────────────────────────────────────
            if (_controller != null)
              Positioned(
                left: safe.left + RRSpace.sp20,
                right: safe.right + RRSpace.sp20,
                bottom: safe.bottom + 16,
                child: _VideoSeekBar(controller: _controller!),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Video info sheet ─────────────────────────────────────────────────────────

class _VideoInfoSheet extends StatefulWidget {
  const _VideoInfoSheet({required this.asset});
  final AssetEntity asset;

  @override
  State<_VideoInfoSheet> createState() => _VideoInfoSheetState();
}

class _VideoInfoSheetState extends State<_VideoInfoSheet> {
  int? _fileSizeBytes;

  @override
  void initState() {
    super.initState();
    _loadFileSize();
  }

  Future<void> _loadFileSize() async {
    final file = await widget.asset.file;
    if (mounted && file != null) {
      setState(() => _fileSizeBytes = file.lengthSync());
    }
  }

  String _fmtSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _fmtDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String _fmtDate(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $hour:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(0, 12, 0, safeBottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              asset.title ?? 'Video',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12, height: 24),
          _InfoRow(label: 'Date', value: _fmtDate(asset.createDateTime)),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(label: 'Duration', value: _fmtDuration(asset.duration)),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(
            label: 'Resolution',
            value: '${asset.width} × ${asset.height}',
          ),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(
            label: 'File Size',
            value: _fileSizeBytes != null ? _fmtSize(_fileSizeBytes!) : '—',
          ),
          if (asset.mimeType != null) ...[
            const Divider(color: Colors.white12, height: 1),
            _InfoRow(label: 'Format', value: asset.mimeType!),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 15)),
          const Spacer(),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
