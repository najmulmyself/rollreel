import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../core/ads/ads_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/video/video_library_provider.dart';
import '../states/loading_state.dart';
import '../states/no_videos_state.dart';
import '../../shared/widgets/date_label.dart';
import 'video_feed_item.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({
    super.key,
    this.onOpenBrowse,
    this.onOpenSettings,
    this.initialAssetId,
    this.onVideoChanged,
    this.isTabActive = true,
    this.onPlayStateChanged,
  });

  final VoidCallback? onOpenBrowse;
  final VoidCallback? onOpenSettings;
  final String? initialAssetId;
  final void Function(String assetId)? onVideoChanged;
  final bool isTabActive;
  final ValueChanged<bool>? onPlayStateChanged;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _awaitingDeletion = false;
  bool _showDateLabel = false;
  String _dateLabelText = '';
  VideoPlayerController? _activeController;
  bool _filterInitialized = false;
  bool _navVisible = true;
  Timer? _navHideTimer;

  @override
  void initState() {
    super.initState();
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

  void _initializeDefaultFilter() {
    if (_filterInitialized) return;
    _filterInitialized = true;
    final defaultFilter = ref.read(settingsProvider).defaultFilter;
    if (defaultFilter != FeedFilter.all) {
      ref.read(feedFilterProvider.notifier).state = defaultFilter;
    }
  }

  Future<void> _deleteCurrentVideo(List<AssetEntity> videos) async {
    if (_currentIndex >= videos.length) return;
    final asset = videos[_currentIndex];
    final messenger = ScaffoldMessenger.of(context);
    final deleted = await PhotoManager.editor.deleteWithIds([asset.id]);
    if (!mounted) return;
    if (deleted.contains(asset.id)) {
      _awaitingDeletion = true;
      ref.invalidate(videoLibraryProvider);
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Video deleted'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleControllerReady(VideoPlayerController? ctrl) {
    if (mounted) setState(() => _activeController = ctrl);
  }

  void _handlePlayStateChanged(bool playing) {
    widget.onPlayStateChanged?.call(playing);
    _navHideTimer?.cancel();
    if (playing) {
      _navHideTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _navVisible = false);
      });
    } else if (mounted) {
      setState(() => _navVisible = true);
    }
  }

  void _onPageChanged(int index, List<AssetEntity> videos) {
    HapticFeedback.mediumImpact();
    ref.read(adsProvider.notifier).registerSwipe();

    final prev = videos[_currentIndex];
    final next = videos[index];
    final prevDay = prev.createDateTime;
    final nextDay = next.createDateTime;
    final sameDay = prevDay.year == nextDay.year &&
        prevDay.month == nextDay.month &&
        prevDay.day == nextDay.day;

    _navHideTimer?.cancel();
    setState(() {
      _currentIndex = index;
      _activeController = null;
      _navVisible = true;
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

  void _showInitialDateLabel(List<AssetEntity> videos) {
    if (videos.isEmpty) return;
    final idx = _currentIndex.clamp(0, videos.length - 1);
    final label = _fmtDateLabel(videos[idx].createDateTime);
    setState(() {
      _showDateLabel = true;
      _dateLabelText = label;
    });
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _showDateLabel = false);
    });
  }

  @override
  void didUpdateWidget(FeedScreen old) {
    super.didUpdateWidget(old);
    if (widget.isTabActive == old.isTabActive) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isTabActive) {
        _activeController?.pause();
      } else {
        _activeController?.play();
      }
    });
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
    _navHideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(feedVideosProvider);
    final settings = ref.watch(settingsProvider);
    final activeFilter = ref.watch(feedFilterProvider);
    final safeTop = MediaQuery.paddingOf(context).top;
    final permission = ref.watch(permissionProvider).valueOrNull;
    final isLimitedAccess = permission == PermissionState.limited;

    ref.listen<AsyncValue<List<AssetEntity>>>(feedVideosProvider, (_, next) {
      if (_awaitingDeletion && next.hasValue && !next.isLoading) {
        _awaitingDeletion = false;
        final newVideos = next.requireValue;
        if (newVideos.isNotEmpty && _currentIndex >= newVideos.length) {
          final idx = newVideos.length - 1;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _pageController.hasClients) {
              _pageController.jumpToPage(idx);
              setState(() => _currentIndex = idx);
            }
          });
        }
      }
    });

    ref.listen<String?>(feedJumpToAssetProvider, (_, assetId) {
      if (assetId == null) return;
      final cached = ref.read(feedVideosProvider).valueOrNull;
      if (cached == null) return;
      final idx = cached.indexWhere((v) => v.id == assetId);
      if (idx >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(idx);
            setState(() => _currentIndex = idx);
          }
        });
      }
      ref.read(feedJumpToAssetProvider.notifier).state = null;
    });

    final videos = videosAsync.valueOrNull;

    if (videos == null) {
      if (videosAsync.hasError) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text('Could not load videos: ${videosAsync.error}',
                style: const TextStyle(color: Colors.white)),
          ),
        );
      }
      return const Scaffold(
        backgroundColor: Colors.black,
        body: LoadingState(),
      );
    }

    // Initialize default filter once videos are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDefaultFilter();
    });

    if (videos.isEmpty) {
      return Scaffold(
        backgroundColor: RRColors.bgDeep,
        body: Stack(
          children: [
            NoVideosState(onOpenPhotos: () => PhotoManager.openSetting()),
            Positioned(
              top: safeTop + 8,
              left: 0,
              right: 0,
              child: _FilterTabs(
                activeFilter: activeFilter,
                onFilterChanged: (f) {
                  ref.read(feedFilterProvider.notifier).state = f;
                  setState(() {
                    _currentIndex = 0;
                    _activeController = null;
                  });
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(0);
                  }
                },
              ),
            ),
            if (isLimitedAccess)
              Positioned(
                top: safeTop + 52,
                left: 0,
                right: 0,
                child: const _LimitedAccessBanner(accessibleCount: 0),
              ),
          ],
        ),
      );
    }

    final safeIndex = _currentIndex.clamp(0, videos.length - 1);

    // Show initial date label once when videos first become available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showDateLabel && settings.showDateLabels && videos.isNotEmpty) {
        // Only on first render — we rely on a flag set in _onPageChanged for subsequent
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            onPageChanged: (i) => _onPageChanged(i, videos),
            itemBuilder: (context, index) => VideoFeedItem(
              key: ValueKey(videos[index].id),
              asset: videos[index],
              isActive: index == safeIndex,
              onControllerReady: _handleControllerReady,
              onDelete: () => _deleteCurrentVideo(videos),
              onPlayStateChanged: _handlePlayStateChanged,
              onOpenLibrary: widget.onOpenBrowse,
              onOpenSettings: widget.onOpenSettings,
            ),
          ),
          // ── Filter tabs ────────────────────────────────────────────────────
          Positioned(
            top: safeTop + 8,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_navVisible,
              child: AnimatedOpacity(
                opacity: _navVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _FilterTabs(
                  activeFilter: activeFilter,
                  onSearchTap: widget.onOpenBrowse,
                  onFilterChanged: (f) {
                    ref.read(feedFilterProvider.notifier).state = f;
                    setState(() {
                      _currentIndex = 0;
                      _activeController = null;
                    });
                    if (_pageController.hasClients) {
                      _pageController.jumpToPage(0);
                    }
                    // Show date label for first video after filter change
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final updated = ref.read(feedVideosProvider).valueOrNull;
                      if (updated != null && updated.isNotEmpty && settings.showDateLabels) {
                        _showInitialDateLabel(updated);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          // ── Date label ─────────────────────────────────────────────────────
          if (_showDateLabel && settings.showDateLabels)
            Positioned(
              top: safeTop + 56,
              left: 0,
              right: 0,
              child: Center(child: DateLabel(label: _dateLabelText)),
            ),
          // ── Limited Photo Library access banner ──────────────────────────
          if (isLimitedAccess)
            Positioned(
              top: safeTop + 52,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_navVisible,
                child: AnimatedOpacity(
                  opacity: _navVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: _LimitedAccessBanner(accessibleCount: videos.length),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Limited Photo Library access banner ───────────────────────────────────

class _LimitedAccessBanner extends StatelessWidget {
  const _LimitedAccessBanner({required this.accessibleCount});

  final int accessibleCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => PhotoManager.presentLimited(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Managing $accessibleCount of your videos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Manage',
                style: TextStyle(
                  color: RRColors.accentCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.chevron_right, color: RRColors.accentCyan, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Filter tabs ──────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.activeFilter,
    required this.onFilterChanged,
    this.onSearchTap,
  });

  final FeedFilter activeFilter;
  final void Function(FeedFilter) onFilterChanged;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: FeedFilter.values.map((f) {
                  final isActive = f == activeFilter;
                  return GestureDetector(
                    onTap: () => onFilterChanged(f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(100),
                        border: isActive
                            ? Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 1)
                            : null,
                      ),
                      child: Text(
                        f.label,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.white60,
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSearchTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
