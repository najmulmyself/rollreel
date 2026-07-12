import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/memories/on_this_day_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/colors.dart';
import '../feed/video_feed_item.dart';
import '../states/loading_state.dart';

/// Full-screen memories viewer: videos taken on today's month/day in
/// previous years, swiped vertically like the main feed.
class OnThisDayScreen extends ConsumerStatefulWidget {
  const OnThisDayScreen({super.key});

  @override
  ConsumerState<OnThisDayScreen> createState() => _OnThisDayScreenState();
}

class _OnThisDayScreenState extends ConsumerState<OnThisDayScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _yearsAgoLabel(AppLocalizations l10n, AssetEntity asset) {
    final years = DateTime.now().year - asset.createDateTime.year;
    return years == 1 ? l10n.yearsAgoOne : l10n.yearsAgoMany(years);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final videosAsync = ref.watch(onThisDayProvider);
    final safeTop = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: videosAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) => Center(
          child: Text(l10n.couldNotLoadMemories('$e'),
              style: const TextStyle(color: Colors.white)),
        ),
        data: (videos) {
          if (videos.isEmpty) {
            // Library changed underneath us (e.g. video deleted) — bail out.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) Navigator.of(context).maybePop();
            });
            return const SizedBox.shrink();
          }
          final safeIndex = _currentIndex.clamp(0, videos.length - 1);

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                allowImplicitScrolling: true,
                itemCount: videos.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) => VideoFeedItem(
                  key: ValueKey('otd_${videos[index].id}'),
                  asset: videos[index],
                  isActive: index == safeIndex,
                  onControllerReady: (_) {},
                ),
              ),
              // ── Header: back button + "On This Day — N years ago" ─────────
              Positioned(
                top: safeTop + 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.chevron_left,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.calendar_today,
                              color: RRColors.accentCyan, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            l10n.onThisDayHeader(
                                _yearsAgoLabel(l10n, videos[safeIndex])),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
              // ── Counter: "2 of 5" ──────────────────────────────────────────
              Positioned(
                top: safeTop + 52,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    l10n.positionCounter(safeIndex + 1, videos.length),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
