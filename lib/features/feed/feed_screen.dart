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
import '../../core/video/video_library_provider.dart';
import '../../core/theme/logo_variant.dart';
import '../states/loading_state.dart';
import '../states/no_videos_state.dart';
import '../../shared/widgets/date_label.dart';
import 'video_feed_item.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({
    super.key,
    required this.onOpenBrowse,
    required this.onOpenSettings,
    this.initialAssetId,
    this.onVideoChanged,
  });

  final VoidCallback onOpenBrowse;
  final VoidCallback onOpenSettings;
  final String? initialAssetId;
  final void Function(String assetId)? onVideoChanged;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Resolve initial page from asset ID using cached provider data
    int startPage = 0;
    if (widget.initialAssetId != null) {
      final cached = ref.read(feedVideosProvider).valueOrNull;
      if (cached != null) {
        final idx = cached.indexWhere((v) => v.id == widget.initialAssetId);
        if (idx >= 0) startPage = idx;
      }
    }
    _currentIndex = startPage;
    _pageController = PageController(initialPage: startPage);
  }
  bool _showDateLabel = false;
  String _dateLabelText = '';
  VideoPlayerController? _activeController;

  void _handleControllerReady(VideoPlayerController? ctrl) {
    if (mounted) setState(() => _activeController = ctrl);
  }

  void _onPageChanged(int index, List<AssetEntity> videos) {
    HapticFeedback.mediumImpact();

    final prev = videos[_currentIndex];
    final next = videos[index];
    final prevDay = prev.createDateTime;
    final nextDay = next.createDateTime;
    final sameDay = prevDay.year == nextDay.year &&
        prevDay.month == nextDay.month &&
        prevDay.day == nextDay.day;

    setState(() {
      _currentIndex = index;
      _activeController = null;
      if (!sameDay) {
        _showDateLabel = true;
        _dateLabelText = _fmtDateLabel(nextDay);
      }
    });

    widget.onVideoChanged?.call(videos[index].id);

    if (!sameDay) {
      Future.delayed(const Duration(milliseconds: 1700), () {
        if (mounted) setState(() => _showDateLabel = false);
      });
    }
  }

  String _fmtDateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (d.year == today.year) return '${m[dt.month - 1]} ${dt.day}';
    return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(feedVideosProvider);
    final variant = ref.watch(logoVariantProvider);
    final settings = ref.watch(settingsProvider);
    final safeTop = MediaQuery.paddingOf(context).top;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: videosAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) => Center(
          child: Text('Could not load videos: $e',
              style: const TextStyle(color: Colors.white)),
        ),
        data: (videos) {
          if (videos.isEmpty) {
            return NoVideosState(
              onOpenPhotos: () => PhotoManager.openSetting(),
            );
          }

          return Column(
            children: [
              // ── Video feed ──────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: videos.length,
                      onPageChanged: (i) => _onPageChanged(i, videos),
                      itemBuilder: (context, index) => VideoFeedItem(
                        key: ValueKey(videos[index].id),
                        asset: videos[index],
                        isActive: index == _currentIndex,
                        onControllerReady: _handleControllerReady,
                      ),
                    ),

                    // Top nav
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _TopNav(
                        safeTop: safeTop,
                        variant: variant,
                        onBrowse: widget.onOpenBrowse,
                        onSettings: widget.onOpenSettings,
                      ),
                    ),

                    // Scroll dots
                    if (videos.length > 1)
                      Positioned(
                        right: 6,
                        bottom: 80,
                        child: _ScrollDots(
                          current: _currentIndex,
                          total: videos.length,
                        ),
                      ),

                    // Date label
                    if (_showDateLabel && settings.showDateLabels)
                      Positioned(
                        top: safeTop + 64,
                        left: 0,
                        right: 0,
                        child: Center(child: DateLabel(label: _dateLabelText)),
                      ),
                  ],
                ),
              ),

              // ── Bottom player ───────────────────────────────────────────
              if (videos.isNotEmpty)
                _BottomPlayer(
                  asset: videos[_currentIndex],
                  controller: _activeController,
                  safeBottom: safeBottom,
                  onPrev: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                  onNext: () {
                    if (_currentIndex < videos.length - 1) {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Top nav ─────────────────────────────────────────────────────────────────

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.safeTop,
    required this.variant,
    required this.onBrowse,
    required this.onSettings,
  });

  final double safeTop;
  final LogoVariant variant;
  final VoidCallback onBrowse;
  final VoidCallback onSettings;

  String get _iconAsset => variant == LogoVariant.iconic
      ? 'assets/icons/icon.png'
      : 'assets/icons/icon_sec.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: safeTop),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xBB000000), Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
        child: Row(
          children: [
            // Browse button
            _NavBtn(icon: CupertinoIcons.square_grid_2x2, onTap: onBrowse),
            const Spacer(),
            // Logo
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(_iconAsset, width: 24, height: 24,
                      fit: BoxFit.cover),
                ),
                const SizedBox(width: RRSpace.sp8),
                const Text(
                  'RollReel',
                  style: TextStyle(
                    color: RRColors.accentCoral,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Settings button
            _NavBtn(icon: CupertinoIcons.line_horizontal_3_decrease,
                onTap: onSettings),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.50),
          borderRadius: BorderRadius.circular(RRSpace.radiusMd),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ─── Scroll dots ──────────────────────────────────────────────────────────────

class _ScrollDots extends StatelessWidget {
  const _ScrollDots({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final hasPrev = current > 0;
    final hasNext = current < total - 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(active: false, visible: hasPrev),
        const SizedBox(height: 5),
        _dot(active: true, visible: true),
        const SizedBox(height: 5),
        _dot(active: false, visible: hasNext),
      ],
    );
  }

  Widget _dot({required bool active, required bool visible}) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? RRColors.accentCoral
              : Colors.white.withValues(alpha: 0.40),
        ),
      ),
    );
  }
}

// ─── Bottom player ────────────────────────────────────────────────────────────

class _BottomPlayer extends StatelessWidget {
  const _BottomPlayer({
    required this.asset,
    required this.controller,
    required this.safeBottom,
    required this.onPrev,
    required this.onNext,
  });

  final AssetEntity asset;
  final VideoPlayerController? controller;
  final double safeBottom;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _relDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${m[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return _buildContent(context, null);
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller!,
      builder: (context, value, _) => _buildContent(context, value),
    );
  }

  Widget _buildContent(BuildContext context, VideoPlayerValue? value) {
    final title = asset.title ?? _relDate(asset.createDateTime);
    final assetDuration = Duration(seconds: asset.duration);
    final total = (value?.duration.inMilliseconds ?? 0) > 0
        ? value!.duration
        : assetDuration;
    final position = value?.position ?? Duration.zero;
    final isPlaying = value?.isPlaying ?? false;
    final progress = total.inMilliseconds > 0
        ? (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      color: const Color(0xFF080810),
      padding: EdgeInsets.fromLTRB(
          RRSpace.sp20, RRSpace.sp16, RRSpace.sp20, safeBottom + RRSpace.sp12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_relDate(asset.createDateTime)} · ${_fmt(assetDuration)}',
                      style: const TextStyle(
                          fontSize: 13, color: RRColors.textSecond),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final file = await asset.file;
                  if (file != null) {
                    await Share.shareXFiles([XFile(file.path)]);
                  }
                },
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 40, height: 40),
                icon: const Icon(CupertinoIcons.share,
                    color: Colors.white, size: 20),
              ),
            ],
          ),

          const SizedBox(height: RRSpace.sp12),

          // Gradient seek bar
          _SeekBar(
            progress: progress.toDouble(),
            onSeek: (fraction) {
              final ms =
                  (fraction * total.inMilliseconds).toInt();
              controller?.seekTo(Duration(milliseconds: ms));
            },
          ),

          // Time labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(position),
                    style: const TextStyle(
                        fontSize: 11, color: RRColors.textSecond)),
                Text(_fmt(total),
                    style: const TextStyle(
                        fontSize: 11, color: RRColors.textSecond)),
              ],
            ),
          ),

          const SizedBox(height: RRSpace.sp8),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 44, height: 44),
                icon: const Icon(CupertinoIcons.heart,
                    color: Colors.white, size: 22),
              ),
              IconButton(
                onPressed: onPrev,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 44, height: 44),
                icon: const Icon(CupertinoIcons.chevron_left_2,
                    color: Colors.white, size: 20),
              ),
              GestureDetector(
                onTap: () {
                  if (isPlaying) {
                    controller?.pause();
                  } else {
                    controller?.play();
                  }
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2A2A3A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNext,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 44, height: 44),
                icon: const Icon(CupertinoIcons.chevron_right_2,
                    color: Colors.white, size: 20),
              ),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 44, height: 44),
                icon: const Icon(CupertinoIcons.ellipsis,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Seek bar ─────────────────────────────────────────────────────────────────

class _SeekBar extends StatelessWidget {
  const _SeekBar({required this.progress, required this.onSeek});
  final double progress;
  final void Function(double fraction) onSeek;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) =>
              onSeek((d.localPosition.dx / width).clamp(0.0, 1.0)),
          onHorizontalDragUpdate: (d) =>
              onSeek((d.localPosition.dx / width).clamp(0.0, 1.0)),
          child: SizedBox(
            height: 20,
            child: Center(
              child: Stack(
                children: [
                  // Track
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  // Gradient fill
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [RRColors.accentCyan, RRColors.accentCoral],
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
