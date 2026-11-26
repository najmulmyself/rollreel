import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/ads/ads_provider.dart';
import '../../core/ads/player_promotion_schedule.dart';
import '../../core/ads/system_prompt_coordinator.dart';
import '../../core/iap/iap_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/review/review_prompt_provider.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import '../states/loading_state.dart';
import '../states/no_videos_state.dart';
import '../../shared/widgets/date_label.dart';
import 'player_gesture_guide.dart';
import 'settled_video_pager.dart';
import 'video_feed_item.dart';

const _guideSeenKey = 'player_gesture_guide_seen';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({
    super.key,
    required this.onOpenLibrary,
    required this.onOpenSettings,
    this.onOpenBrowse,
    this.onOpenSwipeOffer,
    this.onOpenPaywall,
    this.onVaultChange,
    this.initialAssetId,
    this.onVideoChanged,
    this.isTabActive = true,
    this.onPlayStateChanged,
  });

  final VoidCallback? onOpenBrowse;
  final VoidCallback onOpenLibrary;
  final VoidCallback onOpenSettings;
  final Future<void> Function(VoidCallback onPresented)? onOpenSwipeOffer;
  final Future<void> Function()? onOpenPaywall;
  final Future<void> Function(String, bool)? onVaultChange;
  final String? initialAssetId;
  final void Function(String assetId)? onVideoChanged;
  final bool isTabActive;
  final ValueChanged<bool>? onPlayStateChanged;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  PageController? _controller;
  int _currentIndex = 0;
  int _preloadDirection = 1;

  PageController get _pageController =>
      _controller ??= PageController(initialPage: _currentIndex);
  bool _awaitingDeletion = false;
  bool _showDateLabel = false;
  String _dateLabelText = '';
  String? _readyAssetId;
  bool _filterInitialized = false;
  String? _controlsHiddenForAssetId;
  Timer? _dateLabelTimer;
  late final AppLifecycleListener _lifecycle;
  bool _checkingGuide = true;
  SharedPreferences? _pendingGuide;
  bool _playerOverlayOpen = false;
  bool _checkingOffer = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _maybeShowGuide);
    unawaited(_loadGuidePreference());
  }

  bool get _canPresentOverlay =>
      mounted &&
      widget.isTabActive &&
      !_playerOverlayOpen &&
      ModalRoute.isCurrentOf(context) != false &&
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed &&
      !ref.read(isSystemPromptActiveProvider);

  Future<void> _loadGuidePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final experienced = ref.read(reviewPromptProvider).hasUsedPlayer(prefs);
      setState(() {
        _checkingGuide = false;
        if (!experienced && prefs.getBool(_guideSeenKey) != true) {
          _pendingGuide = prefs;
        }
      });
    } catch (error) {
      debugPrint('[RollReel] Could not load the player guide preference: $error');
      if (mounted) setState(() => _checkingGuide = false);
    }
  }

  void _maybeShowGuide() {
    final prefs = _pendingGuide;
    if (prefs == null || _readyAssetId == null || !_canPresentOverlay) return;
    _pendingGuide = null;
    unawaited(_saveGuideSeen(prefs));
    unawaited(_presentPlayerOverlay(() => showPlayerGestureGuide(context)));
  }

  Future<void> _saveGuideSeen(SharedPreferences prefs) async {
    try {
      if (!await prefs.setBool(_guideSeenKey, true)) {
        debugPrint('[RollReel] Could not save the player guide preference.');
      }
    } catch (error) {
      debugPrint('[RollReel] Could not save the player guide preference: $error');
    }
  }

  Future<void> _presentPlayerOverlay(Future<void> Function() present) async {
    setState(() => _playerOverlayOpen = true);
    try {
      await present();
    } catch (error) {
      debugPrint('[RollReel] Could not open the player overlay: $error');
    } finally {
      if (mounted) setState(() => _playerOverlayOpen = false);
    }
  }

  Future<void> _handleSwipePromotion() async {
    if (!_canPresentOverlay || _checkingGuide || _pendingGuide != null) return;
    await ref.read(isProProvider.notifier).ready;
    if (!_canPresentOverlay || ref.read(isProProvider)) return;

    final ads = ref.read(adsProvider);
    if (ads.isShowingInterstitial ||
        _checkingOffer ||
        ref.read(iapProvider).loading) {
      return;
    }

    final schedule = ref.read(playerPromotionScheduleProvider);
    final promotion = schedule.recordSwipe();
    if (promotion == SwipePromotion.none) return;
    final openOffer = widget.onOpenSwipeOffer;
    if (promotion == SwipePromotion.interstitial || openOffer == null) {
      ads.showInterstitial();
      return;
    }

    _checkingOffer = true;
    try {
      final hasOfferSlot = await schedule.hasOfferSlot();
      if (!_canPresentOverlay ||
          ref.read(isProProvider) ||
          ref.read(iapProvider).loading) {
        return;
      }
      if (!hasOfferSlot) {
        ads.showInterstitial();
        return;
      }

      await _presentPlayerOverlay(
        () => openOffer(() => unawaited(schedule.recordOfferShown())),
      );
    } finally {
      _checkingOffer = false;
    }
  }

  void _initializeDefaultFilter() {
    if (!mounted || _filterInitialized || widget.initialAssetId != null) return;
    _filterInitialized = true;
    final defaultFilter = ref.read(settingsProvider).defaultFilter;
    ref.read(feedFilterProvider.notifier).state = defaultFilter;
  }

  Future<void> _deleteCurrentVideo(List<AssetEntity> videos) async {
    if (_currentIndex >= videos.length) return;
    final asset = videos[_currentIndex];
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final deleted = await PhotoManager.editor.deleteWithIds([asset.id]);
    if (!mounted) return;
    if (deleted.contains(asset.id)) {
      _awaitingDeletion = true;
      ref.invalidate(videoLibraryProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.videoDeleted),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markPlaybackReady(String assetId) {
    if (!mounted || assetId == _readyAssetId) return;
    setState(() => _readyAssetId = assetId);
  }

  void _onPageSettled(int index) {
    final videos = ref.read(feedVideosProvider).valueOrNull;
    if (videos == null ||
        videos.isEmpty ||
        index >= videos.length ||
        index == _currentIndex)
      return;

    final previousIndex = _currentIndex.clamp(0, videos.length - 1);
    final previousDay = videos[previousIndex].createDateTime;
    final next = videos[index];
    final dayChanged = !DateUtils.isSameDay(previousDay, next.createDateTime);
    final showDate = dayChanged && ref.read(settingsProvider).showDateLabels;

    setState(() {
      _preloadDirection = index < previousIndex ? -1 : 1;
      _currentIndex = index;
      _readyAssetId = null;
      _controlsHiddenForAssetId = null;
      if (showDate) {
        _showDateLabel = true;
        _dateLabelText = _fmtDateLabel(next.createDateTime);
      }
    });
    if (showDate) _scheduleDateLabelHide();

    HapticFeedback.mediumImpact();
    widget.onVideoChanged?.call(next.id);
    ref.read(reviewPromptProvider).recordSwipe();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_handleSwipePromotion());
    });
  }

  void _scheduleDateLabelHide() {
    _dateLabelTimer?.cancel();
    _dateLabelTimer = Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _showDateLabel = false);
    });
  }

  void _showInitialDateLabel(List<AssetEntity> videos) {
    if (videos.isEmpty) return;
    final idx = _currentIndex.clamp(0, videos.length - 1);
    final label = _fmtDateLabel(videos[idx].createDateTime);
    setState(() {
      _showDateLabel = true;
      _dateLabelText = label;
    });
    _scheduleDateLabelHide();
  }

  String _fmtDateLabel(DateTime dt) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return l10n.today;
    if (d == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    final locale = Localizations.localeOf(context).toString();
    if (d.year == today.year) return DateFormat.MMMd(locale).format(dt);
    return DateFormat.yMMMd(locale).format(dt);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _dateLabelTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(feedVideosProvider);
    final settings = ref.watch(settingsProvider);
    final systemPromptActive = ref.watch(isSystemPromptActiveProvider);
    final activeFilter = ref.watch(feedFilterProvider);
    final safeTop = MediaQuery.paddingOf(context).top;
    final permission = ref.watch(permissionProvider).valueOrNull;
    final isLimitedAccess = permission == PermissionState.limited;

    if (_pendingGuide != null && _readyAssetId != null && _canPresentOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowGuide());
    }

    ref.listen<bool>(isSystemPromptActiveProvider, (_, active) {
      if (!active) _maybeShowGuide();
    });

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
          if (mounted && _controller?.hasClients == true) {
            _pageController.jumpToPage(idx);
            setState(() => _currentIndex = idx);
          }
        });
      }
      ref.read(feedJumpToAssetProvider.notifier).state = null;
    });

    final openingVideo = _controller == null && widget.initialAssetId != null;
    final videos = openingVideo && videosAsync.isLoading
        ? null
        : videosAsync.valueOrNull;

    if (videos == null) {
      if (videosAsync.hasError) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              AppLocalizations.of(
                context,
              )!.couldNotLoadVideos('${videosAsync.error}'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      return const Scaffold(
        backgroundColor: Colors.black,
        body: LoadingState(),
      );
    }

    if (!_filterInitialized && widget.initialAssetId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeDefaultFilter();
      });
    }

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
                onBackTap: widget.onOpenBrowse,
                onFilterChanged: (f) {
                  ref.read(feedFilterProvider.notifier).state = f;
                  setState(() {
                    _currentIndex = 0;
                    _readyAssetId = null;
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

    if (openingVideo) {
      final index = videos.indexWhere(
        (video) => video.id == widget.initialAssetId,
      );
      _currentIndex = index < 0 ? 0 : index;
    }

    final safeIndex = _currentIndex.clamp(0, videos.length - 1);
    final controlsVisible = _controlsHiddenForAssetId != videos[safeIndex].id;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SettledVideoPager(
            controller: _pageController,
            itemCount: videos.length,
            selectedIndex: safeIndex,
            preloadDirection: _preloadDirection,
            allowPreload:
                _readyAssetId == videos[safeIndex].id && widget.isTabActive,
            onPageSettled: _onPageSettled,
            itemBuilder: (context, index, preload) => VideoFeedItem(
              key: ValueKey(videos[index].id),
              asset: videos[index],
              isActive: index == safeIndex && widget.isTabActive,
              playbackCovered:
                  _checkingGuide ||
                  _pendingGuide != null ||
                  _playerOverlayOpen ||
                  systemPromptActive,
              preload: preload,
              onControllerReady: (controller) {
                if (controller != null) _markPlaybackReady(videos[index].id);
              },
              onDelete: () => _deleteCurrentVideo(videos),
              onPlayStateChanged: widget.onPlayStateChanged,
              onControlsVisibilityChanged: (visible) => setState(() {
                _controlsHiddenForAssetId = visible ? null : videos[index].id;
              }),
              onOpenLibrary: widget.onOpenLibrary,
              onOpenSettings: widget.onOpenSettings,
              onOpenPaywall: widget.onOpenPaywall,
              onVaultChange: widget.onVaultChange,
            ),
          ),
          // ── Filter tabs ────────────────────────────────────────────────────
          Positioned(
            top: safeTop + 8,
            left: 0,
            right: 0,
            child: PlayerControlsVisibility(
              visible: controlsVisible,
              child: _FilterTabs(
                activeFilter: activeFilter,
                onSearchTap: widget.onOpenBrowse,
                onBackTap: widget.onOpenBrowse,
                onFilterChanged: (f) {
                  ref.read(feedFilterProvider.notifier).state = f;
                  setState(() {
                    _currentIndex = 0;
                    _readyAssetId = null;
                  });
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(0);
                  }
                  // Show date label for first video after filter change
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final updated = ref.read(feedVideosProvider).valueOrNull;
                    if (updated != null &&
                        updated.isNotEmpty &&
                        settings.showDateLabels) {
                      _showInitialDateLabel(updated);
                    }
                  });
                },
              ),
            ),
          ),
          // ── Date label ─────────────────────────────────────────────────────
          if (_showDateLabel && settings.showDateLabels)
            Positioned(
              top: safeTop + 56,
              left: 0,
              right: 0,
              child: PlayerControlsVisibility(
                visible: controlsVisible,
                child: Center(child: DateLabel(label: _dateLabelText)),
              ),
            ),
          // ── Limited Photo Library access banner ──────────────────────────
          if (isLimitedAccess)
            Positioned(
              top: safeTop + 52,
              left: 0,
              right: 0,
              child: PlayerControlsVisibility(
                visible: controlsVisible,
                child: _LimitedAccessBanner(accessibleCount: videos.length),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Limited Photo Library access banner ───────────────────────────────────

class _LimitedAccessBanner extends ConsumerWidget {
  const _LimitedAccessBanner({required this.accessibleCount});

  final int accessibleCount;

  Future<void> _manage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.photoLibraryAccess),
        message: Text(l10n.limitedAccessMessage),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'select'),
            child: Text(l10n.selectMoreVideos),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'settings'),
            child: Text(l10n.allowFullAccess),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
      ),
    );

    if (choice == 'select') {
      await PhotoManager.presentLimited();
    } else if (choice == 'settings') {
      // iOS only lets a limited grant be promoted to full access from the
      // system Settings app — there's no in-app API for it.
      await PhotoManager.openSetting();
    } else {
      return;
    }
    // The system picker/Settings mutate the accessible-asset set without
    // notifying the app — force a refetch so the feed reflects the change.
    ref.invalidate(videoLibraryProvider);
    ref.invalidate(permissionProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _manage(context, ref),
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
                  l10n.managingCount(accessibleCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.manage,
                style: const TextStyle(
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
    this.onBackTap,
  });

  final FeedFilter activeFilter;
  final void Function(FeedFilter) onFilterChanged;
  final VoidCallback? onSearchTap;
  final VoidCallback? onBackTap;

  String _filterLabel(FeedFilter f, AppLocalizations l10n) => switch (f) {
        FeedFilter.all => l10n.filterAll,
        FeedFilter.today => l10n.filterToday,
        FeedFilter.shorts => l10n.filterShorts,
        FeedFilter.long => l10n.filterLong,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.chevron_left,
                  color: Colors.white, size: 18),
            ),
          ),
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
                            ? RRColors.accentViolet.withValues(alpha: 0.85)
                            : Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(100),
                        border: isActive
                            ? Border.all(
                                color:
                                    RRColors.accentViolet.withValues(alpha: 0.9),
                                width: 1)
                            : null,
                      ),
                      child: Text(
                        _filterLabel(f, l10n),
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
