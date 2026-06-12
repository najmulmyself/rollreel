import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/spacing.dart';
import '../../core/video/video_library_provider.dart';
import '../states/empty_state.dart';
import '../states/loading_state.dart';
import '../../shared/widgets/date_label.dart';
import 'video_feed_item.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({
    super.key,
    required this.onOpenBrowse,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenBrowse;
  final VoidCallback onOpenSettings;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;
  bool _showDateLabel = false;
  String _dateLabelText = '';

  void _onPageChanged(int index, List<AssetEntity> videos) {
    final prev = videos[_currentIndex];
    final next = videos[index];
    final prevDate = prev.createDateTime;
    final nextDate = next.createDateTime;
    final sameDay = prevDate.year == nextDate.year &&
        prevDate.month == nextDate.month &&
        prevDate.day == nextDate.day;

    setState(() {
      _currentIndex = index;
      if (!sameDay) {
        _showDateLabel = true;
        _dateLabelText = _formatDateLabel(nextDate);
      }
    });

    if (!sameDay) {
      Future.delayed(const Duration(milliseconds: 1700), () {
        if (mounted) setState(() => _showDateLabel = false);
      });
    }
  }

  String _formatDateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (d.year == today.year) return '${months[dt.month - 1]} ${dt.day}';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videoLibraryProvider);
    final safeTop = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: videosAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) => Center(
          child: Text('Could not load videos: $e', style: const TextStyle(color: Colors.white)),
        ),
        data: (videos) {
          if (videos.isEmpty) {
            return EmptyState(
              icon: CupertinoIcons.film,
              title: 'No Videos Yet',
              body: 'Your camera roll videos will appear here.\nGrant access in Settings → Privacy → Photos.',
              buttonLabel: 'Open Settings',
              onPressed: () => PhotoManager.openSetting(),
            );
          }

          return Stack(
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
                  onShare: () {},
                  onMoreOptions: () {},
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: safeTop + 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xAA000000), Colors.transparent],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RRSpace.sp12,
                        vertical: RRSpace.sp8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: widget.onOpenBrowse,
                            icon: const Icon(CupertinoIcons.rectangle_stack_fill, color: Colors.white),
                          ),
                          const Spacer(),
                          const Text('RollReel',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17)),
                          const Spacer(),
                          IconButton(
                            onPressed: widget.onOpenSettings,
                            icon: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_showDateLabel)
                Positioned(
                  top: safeTop + RRSpace.sp16,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _showDateLabel ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Center(child: DateLabel(label: _dateLabelText)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
