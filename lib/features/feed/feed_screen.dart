import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

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
  });

  final VoidCallback? onOpenBrowse;
  final VoidCallback? onOpenSettings;
  final String? initialAssetId;
  final void Function(String assetId)? onVideoChanged;
  final bool isTabActive;

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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(feedVideosProvider);
    final settings = ref.watch(settingsProvider);
    final safeTop = MediaQuery.paddingOf(context).top;

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

    if (videos.isEmpty) {
      return Scaffold(
        backgroundColor: RRColors.bgDeep,
        body: NoVideosState(onOpenPhotos: () => PhotoManager.openSetting()),
      );
    }

    final safeIndex = _currentIndex.clamp(0, videos.length - 1);

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
            ),
          ),
          if (_showDateLabel && settings.showDateLabels)
            Positioned(
              top: safeTop + 16,
              left: 0,
              right: 0,
              child: Center(child: DateLabel(label: _dateLabelText)),
            ),
        ],
      ),
    );
  }
}
