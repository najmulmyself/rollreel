import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/iap/iap_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/vault/vault_provider.dart';
import '../../l10n/app_localizations.dart';
import 'dynamic_bg.dart';

// ─── Gesture drag type ────────────────────────────────────────────────────────

enum _DragType { none, volume, brightness }

enum _VideoOption { info, vault, delete }

class VideoFeedItem extends ConsumerStatefulWidget {
  const VideoFeedItem({
    super.key,
    required this.asset,
    required this.isActive,
    required this.onControllerReady,
    required this.onOpenLibrary,
    required this.onOpenSettings,
    this.preload = false,
    this.onDelete,
    this.onPlayStateChanged,
    this.onControlsVisibilityChanged,
    this.onOpenPaywall,
    this.onVaultChange,
  });

  final AssetEntity asset;
  final bool isActive;
  final bool preload;
  final void Function(VideoPlayerController?) onControllerReady;
  final VoidCallback onOpenLibrary;
  final VoidCallback onOpenSettings;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onPlayStateChanged;
  final ValueChanged<bool>? onControlsVisibilityChanged;
  final Future<void> Function()? onOpenPaywall;
  final Future<void> Function(String, bool)? onVaultChange;

  @override
  ConsumerState<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends ConsumerState<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool get _initialized => _controller != null;
  PMCancelToken? _sourceRequest;
  PMCancelToken? _thumbnailRequest;
  Timer? _preloadTimer;
  bool _activatedByNavigation = false;
  bool _loadFailed = false;
  bool _titleRequested = false;
  bool _optionsOpen = false;
  Uint8List? _thumbnail;
  String? _title;
  bool _showPlayIcon = false;
  bool _iconIsPlay = false;

  // Double-tap seek flash
  bool _showSeekFlash = false;
  bool _seekFlashIsForward = true;
  Timer? _seekFlashTimer;

  // Long-press fast-forward state
  bool _fastForward = false;
  bool _showingPaywall = false;

  // Volume / brightness gesture state
  bool _brightnessTouched = false;
  _DragType _dragType = _DragType.none;
  double _dragValue = 0.0; // 0.0 – 1.0
  bool _showDragOverlay = false;
  double? _dragStartY;
  double? _dragStartValue;

  // Info card / controls visibility
  bool _controlsVisible = true;
  Timer? _controlsHideTimer;

  void _scheduleControlsAutoHide() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted && widget.isActive) _setControlsVisible(false);
    });
  }

  void _setControlsVisible(bool visible) {
    if (visible == _controlsVisible) return;
    setState(() => _controlsVisible = visible);
    widget.onControlsVisibilityChanged?.call(visible);
  }

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
    _preparePlayback();
  }

  Future<void> _loadThumbnail() async {
    final request = PMCancelToken();
    _thumbnailRequest = request;
    try {
      final bytes = await widget.asset.thumbnailDataWithSize(
        const ThumbnailSize(320, 560),
        cancelToken: request,
      );
      if (bytes != null && mounted) setState(() => _thumbnail = bytes);
    } catch (_) {
      // Playback can still start if Photos has no preview for this clip.
    } finally {
      _thumbnailRequest = null;
    }
  }

  Future<void> _loadTitle() async {
    if (_titleRequested || widget.asset.title?.trim().isNotEmpty == true)
      return;
    _titleRequested = true;
    try {
      final title = await widget.asset.titleAsync;
      if (mounted && title.trim().isNotEmpty) setState(() => _title = title);
    } catch (_) {
      // The controls use the library's fallback title.
    }
  }

  void _preparePlayback() {
    _preloadTimer?.cancel();
    if (widget.isActive) {
      _loadTitle();
      if (_controller != null) {
        _syncPlaybackAfterBuild();
      } else {
        _initController();
      }
    } else if (widget.preload) {
      // Previews can paint before an adjacent local asset opens its decoder.
      if (_controller == null && _sourceRequest == null) {
        _preloadTimer = Timer(
          const Duration(milliseconds: 220),
          _initController,
        );
      }
    } else {
      final request = _sourceRequest;
      _sourceRequest = null;
      _cancelPhotoRequest(request);
    }
  }

  bool _isCurrentRequest(PMCancelToken request) =>
      mounted &&
      identical(_sourceRequest, request) &&
      (widget.isActive || widget.preload);

  Future<void> _initController() async {
    if (!mounted ||
        _controller != null ||
        _sourceRequest != null ||
        !(widget.isActive || widget.preload))
      return;
    final request = PMCancelToken();
    final asset = widget.asset;
    _sourceRequest = request;
    VideoPlayerController? pending;
    try {
      if (!widget.isActive) {
        final locallyAvailable = await asset.isLocallyAvailable();
        if (!locallyAvailable && !widget.isActive) return;
      }
      if (!_isCurrentRequest(request)) return;

      final file = await asset.loadFile(isOrigin: false, cancelToken: request);
      if (!_isCurrentRequest(request)) return;
      if (file == null) throw StateError('Photos returned no playable file');

      final controller = pending = VideoPlayerController.file(file);
      await controller.initialize();
      if (!_isCurrentRequest(request)) return;
      await controller.setLooping(
        ref.read(settingsProvider).loopShortVideos && asset.duration < 30,
      );
      if (!_isCurrentRequest(request)) return;

      setState(() {
        _controller = controller;
        _loadFailed = false;
      });
      pending = null;
      if (widget.isActive) _syncPlaybackAfterBuild();
    } catch (error) {
      if (_isCurrentRequest(request) && widget.isActive) {
        debugPrint('[RollReel] Could not prepare video: $error');
        setState(() => _loadFailed = true);
      }
    } finally {
      if (identical(_sourceRequest, request)) _sourceRequest = null;
      await pending?.dispose();
    }
  }

  Future<void> _cancelPhotoRequest(PMCancelToken? request) async {
    if (request == null) return;
    try {
      await request.cancelRequest();
    } catch (_) {
      // A completed request can be removed by Photos before cancellation.
    }
  }

  void _syncPlaybackAfterBuild() {
    final controller = _controller;
    if (controller == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(controller, _controller)) return;
      if (!widget.isActive) {
        if (controller.value.isPlaying) controller.pause();
        return;
      }
      widget.onControllerReady(controller);
      if (_activatedByNavigation || ref.read(settingsProvider).autoPlay) {
        // A reversing swipe builds the new page before the old one. Let
        // offscreen controllers pause during this frame before starting it.
        scheduleMicrotask(() => _beginPlayback(controller));
      }
    });
  }

  Future<void> _beginPlayback(VideoPlayerController controller) async {
    if (!mounted || !widget.isActive || !identical(controller, _controller)) {
      return;
    }
    try {
      await controller.play();
      if (!mounted ||
          !widget.isActive ||
          !identical(controller, _controller) ||
          !controller.value.isPlaying) {
        return;
      }
      widget.onPlayStateChanged?.call(true);
      _scheduleControlsAutoHide();
    } catch (error) {
      debugPrint('[RollReel] Could not start video playback: $error');
    }
  }

  @override
  void didUpdateWidget(VideoFeedItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      if (widget.isActive) {
        _activatedByNavigation = true;
        _loadFailed = false;
      } else {
        _controlsHideTimer?.cancel();
        _controlsVisible = true;
        _syncPlaybackAfterBuild();
      }
    }
    if (widget.isActive != old.isActive || widget.preload != old.preload) {
      _preparePlayback();
    }
  }

  void _seekBy(Duration offset) {
    if (_controller == null) return;
    HapticFeedback.lightImpact();
    final next = _controller!.value.position + offset;
    _controller!.seekTo(next.isNegative ? Duration.zero : next);
    _flashSeek(!offset.isNegative);
  }

  void _flashSeek(bool isForward) {
    _seekFlashTimer?.cancel();
    setState(() {
      _showSeekFlash = true;
      _seekFlashIsForward = isForward;
    });
    _seekFlashTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showSeekFlash = false);
    });
  }

  @override
  void dispose() {
    _controlsHideTimer?.cancel();
    _seekFlashTimer?.cancel();
    _preloadTimer?.cancel();
    _cancelPhotoRequest(_thumbnailRequest);
    _cancelPhotoRequest(_sourceRequest);
    _sourceRequest = null;
    _controller?.dispose();
    // Only touch the system brightness API if this item actually changed it —
    // an unconditional reset here fires a platform-channel call on every page
    // disposal during fast swiping.
    if (_brightnessTouched) {
      ScreenBrightness().resetScreenBrightness();
    }
    super.dispose();
  }

  void _togglePlay() {
    if (!_initialized || _controller == null) return;
    final wasPlaying = _controller!.value.isPlaying;
    final nowPlaying = !wasPlaying;
    setState(() {
      _showPlayIcon = true;
      _iconIsPlay = nowPlaying;
    });
    if (wasPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    widget.onPlayStateChanged?.call(nowPlaying);
    if (nowPlaying) {
      _scheduleControlsAutoHide();
    } else {
      _controlsHideTimer?.cancel();
      _setControlsVisible(true);
    }
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) setState(() => _showPlayIcon = false);
    });
  }

  // ── Long-press fast-forward (2×) ─────────────────────────────────────────────

  Future<void> _startFastForward() async {
    final controller = _controller;
    if (!_initialized || controller == null) return;
    if (!ref.read(isProProvider)) {
      final openPaywall = widget.onOpenPaywall;
      if (openPaywall == null || _showingPaywall) return;
      _showingPaywall = true;
      final wasPlaying = controller.value.isPlaying;
      try {
        if (wasPlaying) await controller.pause();
        if (mounted) await openPaywall();
      } finally {
        _showingPaywall = false;
        if (mounted && widget.isActive && wasPlaying) {
          await controller.play();
        }
      }
      return;
    }
    HapticFeedback.heavyImpact();
    _controller!.setPlaybackSpeed(2.0);
    setState(() => _fastForward = true);
  }

  void _endFastForward() {
    if (!_initialized || _controller == null) return;
    _controller!.setPlaybackSpeed(1.0);
    setState(() => _fastForward = false);
  }

  // ── Volume / brightness gestures ─────────────────────────────────────────────

  Future<void> _onDragStart(DragStartDetails d, _DragType type) async {
    if (type == _DragType.brightness) {
      final current = await ScreenBrightness().current;
      _dragStartValue = current;
      _dragValue = current;
    } else {
      double? vol;
      try {
        vol = await FlutterVolumeController.getVolume();
      } catch (_) {}
      _dragStartValue = vol ?? 0.5;
      _dragValue = _dragStartValue!;
    }
    _dragType = type;
    _dragStartY = d.globalPosition.dy;
    if (mounted) setState(() => _showDragOverlay = true);
  }

  Future<void> _onDragUpdate(DragUpdateDetails d) async {
    if (_dragType == _DragType.none || _dragStartY == null) return;
    final height = MediaQuery.sizeOf(context).height;
    final dy = _dragStartY! - d.globalPosition.dy; // positive = up = increase
    final delta = dy / (height * 0.6); // 60% of screen = full range
    final newValue = (_dragStartValue! + delta).clamp(0.0, 1.0);

    setState(() => _dragValue = newValue);

    if (_dragType == _DragType.volume) {
      try {
        await FlutterVolumeController.setVolume(newValue);
      } catch (_) {}
    } else {
      try {
        await ScreenBrightness().setScreenBrightness(newValue);
        _brightnessTouched = true;
      } catch (_) {}
    }
  }

  void _onDragEnd(DragEndDetails d) {
    if (_dragType == _DragType.none) return;
    _dragType = _DragType.none;
    _dragStartY = null;
    _dragStartValue = null;
    if (mounted) {
      setState(() => _showDragOverlay = false);
    }
  }

  Future<void> _openLandscape(BuildContext context) async {
    final wasPlaying = _controller?.value.isPlaying ?? false;
    final position = _controller?.value.position;
    final navigator = Navigator.of(context);
    await _controller?.pause();
    if (!mounted) return;

    await navigator.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) =>
            _LandscapeVideoPage(asset: widget.asset, startPosition: position),
      ),
    );

    if (mounted && wasPlaying) _controller?.play();
  }

  Future<void> _showOptions(BuildContext context) async {
    if (_optionsOpen) return;
    _optionsOpen = true;
    HapticFeedback.selectionClick();
    final inVault = ref.read(vaultIdsProvider).contains(widget.asset.id);
    final change = widget.onVaultChange;
    final l10n = AppLocalizations.of(context)!;
    _VideoOption? selection;
    try {
      selection = await showCupertinoModalPopup<_VideoOption>(
        context: context,
        builder: (sheetContext) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, _VideoOption.info),
              child: Text(l10n.getInfo),
            ),
            if (change != null)
              CupertinoActionSheetAction(
                onPressed: () =>
                    Navigator.pop(sheetContext, _VideoOption.vault),
                child: Text(inVault ? l10n.removeFromVault : l10n.addToVault),
              ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(sheetContext, _VideoOption.delete),
              child: Text(l10n.deleteVideo),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(sheetContext),
            child: Text(l10n.cancel),
          ),
        ),
      );
    } finally {
      _optionsOpen = false;
    }
    if (!context.mounted || selection == null) return;
    switch (selection) {
      case _VideoOption.info:
        await showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => VideoInfoSheet(asset: widget.asset),
        );
      case _VideoOption.vault:
        final controller = _controller;
        final wasPlaying = controller?.value.isPlaying ?? false;
        try {
          if (wasPlaying) await controller?.pause();
          if (mounted) await change?.call(widget.asset.id, !inVault);
        } finally {
          if (mounted &&
              widget.isActive &&
              wasPlaying &&
              !ref.read(vaultIdsProvider).contains(widget.asset.id)) {
            await controller?.play();
          }
        }
      case _VideoOption.delete:
        widget.onDelete?.call();
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    HapticFeedback.lightImpact();
    final isForward =
        details.localPosition.dx > MediaQuery.sizeOf(context).width / 2;
    final offset = Duration(seconds: isForward ? 10 : -10);
    final next = (_controller?.value.position ?? Duration.zero) + offset;
    _controller?.seekTo(next.isNegative ? Duration.zero : next);
    _flashSeek(isForward);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    // select() so this item only rebuilds when ITS OWN favorite flag flips,
    // not on every change to the favorites set.
    final isFavorited = ref.watch(
      favoritesIdsProvider.select((ids) => ids.contains(widget.asset.id)),
    );

    final edgeWidth = (MediaQuery.sizeOf(context).width * .13).clamp(
      24.0,
      44.0,
    );
    final controller = _controller;

    return DynamicBackground(
      thumbnailBytes: _thumbnail,
      active: widget.isActive,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.isActive ? _togglePlay : null,
              onLongPressStart: widget.isActive
                  ? (_) => _startFastForward()
                  : null,
              onLongPressEnd: widget.isActive ? (_) => _endFastForward() : null,
              onDoubleTapDown: widget.isActive ? _handleDoubleTap : null,
              child: switch ((widget.isActive, controller, _thumbnail)) {
                (true, final controller?, _) => Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
                (_, _, final thumbnail?) => Center(
                  child: Image.memory(thumbnail, fit: BoxFit.contain),
                ),
                _ => const ColoredBox(color: Colors.black),
              },
            ),
          ),

          if (widget.isActive && !_initialized)
            Center(
              child: _loadFailed
                  ? TextButton(
                      onPressed: () {
                        setState(() => _loadFailed = false);
                        _initController();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black54,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.homePlaybackFailed +
                            ' ' +
                            AppLocalizations.of(context)!.retry,
                      ),
                    )
                  : const CupertinoActivityIndicator(color: Colors.white),
            ),

          // ── Top vignette ─────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
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

          // ── Bottom vignette ──────────────────────────────────────────────
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

          // ── Tap flash: play/pause icon ────────────────────────────────────
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

          // ── Fast-forward badge ───────────────────────────────────────────
          if (_fastForward)
            Positioned(
              top: 72,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      '2×',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── Double-tap seek flash ────────────────────────────────────────
          Positioned(
            top: 0,
            bottom: 0,
            left: _seekFlashIsForward
                ? MediaQuery.sizeOf(context).width / 2
                : 0,
            width: MediaQuery.sizeOf(context).width / 2,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showSeekFlash ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.52),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _seekFlashIsForward
                          ? CupertinoIcons.goforward_10
                          : CupertinoIcons.gobackward_10,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Volume / brightness overlay ──────────────────────────────────
          if (_showDragOverlay)
            IgnorePointer(
              child: _DragOverlay(type: _dragType, value: _dragValue),
            ),

          // ── Edge gesture zones: left = brightness, right = volume ─────────
          // Narrow strips only, so vertical swipes in the rest of the screen
          // are left free for the PageView to change videos.
          if (widget.isActive)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: edgeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: (d) =>
                    _onDragStart(d, _DragType.brightness),
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
              ),
            ),
          if (widget.isActive)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: edgeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: (d) => _onDragStart(d, _DragType.volume),
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
              ),
            ),
          // ── Right sidebar — sits above the info card ───────────────────────
          if (widget.isActive)
            Align(
              alignment: const Alignment(1, -0.05),
              child: Padding(
                padding: const EdgeInsets.only(right: RRSpace.sp16),
                child: PlayerControlsVisibility(
                  visible: _controlsVisible,
                  child: _Sidebar(
                    asset: widget.asset,
                    isFavorited: isFavorited,
                    onFavorite: () {
                      HapticFeedback.lightImpact();
                      ref
                          .read(favoritesIdsProvider.notifier)
                          .toggle(widget.asset.id);
                    },
                    onFullscreen: () => _openLandscape(context),
                    onOptions: () => _showOptions(context),
                  ),
                ),
              ),
            ),

          // ── Info card: title/tag, date, seek bar, controls ─────────────────
          if (widget.isActive && controller != null)
            Positioned(
              left: RRSpace.sp16,
              right: RRSpace.sp16,
              bottom: safeBottom + 8,
              child: PlayerControlsVisibility(
                visible: _controlsVisible,
                child: AnimatedSlide(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  offset: _controlsVisible ? Offset.zero : const Offset(0, 0.3),
                  child: _InfoCard(
                    asset: widget.asset,
                    title: _title,
                    controller: controller,
                    onOpenLibrary: widget.onOpenLibrary,
                    onOpenSettings: widget.onOpenSettings,
                    onTogglePlay: _togglePlay,
                    onSeekPrev: () => _seekBy(const Duration(seconds: -10)),
                    onSeekNext: () => _seekBy(const Duration(seconds: 10)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlayerControlsVisibility extends StatelessWidget {
  const PlayerControlsVisibility({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 220),
          child: child,
        ),
      ),
    );
  }
}

// ─── Drag overlay (volume / brightness) ──────────────────────────────────────

class _DragOverlay extends StatelessWidget {
  const _DragOverlay({required this.type, required this.value});

  final _DragType type;
  final double value;

  @override
  Widget build(BuildContext context) {
    final icon = type == _DragType.volume
        ? (value == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded)
        : (value == 0
            ? Icons.brightness_low_rounded
            : Icons.brightness_high_rounded);

    return Align(
      alignment: type == _DragType.volume
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: 42,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Right sidebar ────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.asset,
    required this.isFavorited,
    required this.onFavorite,
    required this.onFullscreen,
    required this.onOptions,
  });
  final AssetEntity asset;
  final bool isFavorited;
  final VoidCallback onFavorite;
  final VoidCallback onFullscreen;
  final VoidCallback onOptions;

  // iPad shows the share sheet as a popover and requires an anchor rect —
  // without one it renders at (0,0) and gets dismissed before it's visible.
  // [btnContext] is the share button's own BuildContext, captured at tap
  // time via a Builder below, so no GlobalKey (and its duplicate-key risk
  // across the PageView's simultaneously-mounted pages) is needed.
  Future<void> _share(BuildContext btnContext) async {
    final file = await asset.file;
    if (file == null) return;
    final box = btnContext.findRenderObject() as RenderBox?;
    final origin = box == null
        ? Rect.zero
        : (box.localToGlobal(Offset.zero) & box.size);
    await Share.shareXFiles([XFile(file.path)], sharePositionOrigin: origin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SideBtn(
          icon: isFavorited
              ? CupertinoIcons.suit_heart_fill
              : CupertinoIcons.suit_heart,
          selected: isFavorited,
          label: l10n.like,
          onTap: onFavorite,
        ),
        const SizedBox(height: 22),
        Builder(
          builder: (btnContext) => _SideBtn(
            icon: CupertinoIcons.arrowshape_turn_up_right,
            label: l10n.share,
            onTap: () => _share(btnContext),
          ),
        ),
        const SizedBox(height: 22),
        _SideBtn(
          icon: CupertinoIcons.arrow_up_left_arrow_down_right,
          label: l10n.expand,
          onTap: onFullscreen,
        ),
        const SizedBox(height: 22),
        _SideBtn(
          icon: CupertinoIcons.ellipsis_vertical,
          semanticLabel: l10n.libraryVideoOptions(
            asset.title ?? l10n.videoFallbackTitle,
          ),
          onTap: onOptions,
        ),
      ],
    );
  }
}

class _SideBtn extends StatelessWidget {
  const _SideBtn({
    required this.icon,
    required this.onTap,
    this.selected,
    this.label,
    this.semanticLabel,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool? selected;
  final String? label;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected == true
                    ? RRColors.accentViolet
                    : RRColors.brandInk.withValues(alpha: 0.68),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x40FFFFFF)),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Bottom info card ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.asset,
    required this.controller,
    required this.onOpenLibrary,
    required this.onOpenSettings,
    required this.onTogglePlay,
    required this.onSeekPrev,
    required this.onSeekNext,
    this.title,
  });

  final AssetEntity asset;
  final String? title;
  final VideoPlayerController controller;
  final VoidCallback onOpenLibrary;
  final VoidCallback onOpenSettings;
  final VoidCallback onTogglePlay;
  final VoidCallback onSeekPrev;
  final VoidCallback onSeekNext;

  String _fmtDay(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return l10n.today;
    if (d == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    final locale = Localizations.localeOf(context).toString();
    if (dt.year == now.year) return DateFormat.MMMd(locale).format(dt);
    return DateFormat.yMMMd(locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tag = asset.duration < 60 ? l10n.filterShorts : l10n.filterLong;
    final resolvedTitle =
        title ??
        (asset.title != null && asset.title!.isNotEmpty
            ? asset.title!
            : l10n.videoFallbackTitle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          resolvedTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              CupertinoIcons.calendar,
              color: Colors.white60,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              _fmtDay(context, asset.createDateTime),
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(width: 8),
            Text(
              '·',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: RRColors.accentViolet.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: RRColors.accentViolet,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RepaintBoundary(
          child: _VideoSeekBar(
            controller: controller,
            accentColor: RRColors.accentViolet,
            showThumb: true,
          ),
        ),
        const SizedBox(height: 16),
        _ControlsRow(
          controller: controller,
          onOpenLibrary: onOpenLibrary,
          onOpenSettings: onOpenSettings,
          onTogglePlay: onTogglePlay,
          onSeekPrev: onSeekPrev,
          onSeekNext: onSeekNext,
        ),
      ],
    );
  }
}

class _ControlsRow extends StatefulWidget {
  const _ControlsRow({
    required this.controller,
    required this.onOpenLibrary,
    required this.onOpenSettings,
    required this.onTogglePlay,
    required this.onSeekPrev,
    required this.onSeekNext,
  });

  final VideoPlayerController controller;
  final VoidCallback onOpenLibrary;
  final VoidCallback onOpenSettings;
  final VoidCallback onTogglePlay;
  final VoidCallback onSeekPrev;
  final VoidCallback onSeekNext;

  @override
  State<_ControlsRow> createState() => _ControlsRowState();
}

class _ControlsRowState extends State<_ControlsRow> {
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_playbackChanged);
  }

  @override
  void didUpdateWidget(_ControlsRow old) {
    super.didUpdateWidget(old);
    if (identical(old.controller, widget.controller)) return;
    old.controller.removeListener(_playbackChanged);
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_playbackChanged);
  }

  void _playbackChanged() {
    final isPlaying = widget.controller.value.isPlaying;
    if (isPlaying != _isPlaying) setState(() => _isPlaying = isPlaying);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_playbackChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CardIconBtn(
          icon: CupertinoIcons.folder,
          semanticLabel: l10n.library,
          onTap: widget.onOpenLibrary,
        ),
        _CardIconBtn(
          icon: CupertinoIcons.backward_end_fill,
          onTap: widget.onSeekPrev,
          size: 40,
          iconSize: 18,
        ),
        GestureDetector(
          onTap: widget.onTogglePlay,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: RRColors.accentViolet,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        _CardIconBtn(
          icon: CupertinoIcons.forward_end_fill,
          onTap: widget.onSeekNext,
          size: 40,
          iconSize: 18,
        ),
        _CardIconBtn(
          icon: CupertinoIcons.gear_alt,
          semanticLabel: l10n.settings,
          onTap: widget.onOpenSettings,
        ),
      ],
    );
  }
}

class _CardIconBtn extends StatelessWidget {
  const _CardIconBtn({
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.size = 44,
    this.iconSize = 20,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}

// ─── Shared seek bar ──────────────────────────────────────────────────────────

class _VideoSeekBar extends StatelessWidget {
  const _VideoSeekBar({
    required this.controller,
    this.accentColor = Colors.white,
    this.showThumb = false,
  });
  final VideoPlayerController controller;
  final Color accentColor;
  final bool showThumb;

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
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
                              color: accentColor,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                        if (showThumb)
                          Positioned(
                            left:
                                (progress * constraints.maxWidth - 6).clamp(
                                    0.0, constraints.maxWidth - 12),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: accentColor, width: 2),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
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
            // ── Video at native ratio ────────────────────────────────────────
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

            // ── Bottom vignette ──────────────────────────────────────────────
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

            // ── Play/pause flash ─────────────────────────────────────────────
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

            // ── Close button (top-left) ──────────────────────────────────────
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

            // ── Seek bar (bottom) ────────────────────────────────────────────
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

class VideoInfoSheet extends StatefulWidget {
  const VideoInfoSheet({required this.asset});
  final AssetEntity asset;

  @override
  State<VideoInfoSheet> createState() => VideoInfoSheetState();
}

class VideoInfoSheetState extends State<VideoInfoSheet> {
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

  String _fmtDate(BuildContext context, DateTime dt) {
    final locale = Localizations.localeOf(context).toString();
    return '${DateFormat.yMMMMd(locale).format(dt)}  ${DateFormat.jm(locale).format(dt)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              asset.title ?? l10n.videoFallbackTitle,
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
          _InfoRow(
              label: l10n.infoDate,
              value: _fmtDate(context, asset.createDateTime)),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(label: l10n.infoDuration, value: _fmtDuration(asset.duration)),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(
            label: l10n.infoResolution,
            value: '${asset.width} × ${asset.height}',
          ),
          const Divider(color: Colors.white12, height: 1),
          _InfoRow(
            label: l10n.infoFileSize,
            value: _fileSizeBytes != null ? _fmtSize(_fileSizeBytes!) : '—',
          ),
          if (asset.mimeType != null) ...[
            const Divider(color: Colors.white12, height: 1),
            _InfoRow(label: l10n.infoFormat, value: asset.mimeType!),
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

