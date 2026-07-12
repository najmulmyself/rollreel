import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../l10n/app_localizations.dart';

import '../../core/iap/iap_provider.dart';
import '../../core/memories/on_this_day_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/video/video_library_provider.dart';
import '../memories/on_this_day_screen.dart';
import '../../shared/widgets/local_badge.dart';
import '../feed/video_feed_item.dart' show VideoInfoSheet;
import '../states/empty_state.dart';
import '../states/loading_state.dart';
import 'filter_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BrowseScreen
// ─────────────────────────────────────────────────────────────────────────────

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({
    super.key,
    this.onBack,
    this.onPlayAt,
    this.initialScrollOffset = 0.0,
    this.onScrollChanged,
    this.onOpenPaywall,
  });

  final VoidCallback? onBack;
  final void Function(String assetId)? onPlayAt;
  final double initialScrollOffset;
  final void Function(double offset)? onScrollChanged;
  final VoidCallback? onOpenPaywall;

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  late final ScrollController _scrollController;
  final TextEditingController _searchCtrl = TextEditingController();
  bool _searchActive = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: widget.initialScrollOffset);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchCtrl.clear();
        _searchQuery = '';
      }
    });
  }

  List<AssetEntity> _applySearch(List<AssetEntity> videos) {
    if (_searchQuery.isEmpty) return videos;
    return videos
        .where((v) =>
            (v.title ?? '').toLowerCase().contains(_searchQuery))
        .toList();
  }

  // ── Quick chip definitions ────────────────────────────────────────────────

  static const List<_QuickChip> _quickChips = [
    _QuickChip(
      id: _QuickChipId.all,
      icon: CupertinoIcons.rectangle_stack_fill,
    ),
    _QuickChip(
      id: _QuickChipId.today,
      icon: CupertinoIcons.calendar,
    ),
    _QuickChip(
      id: _QuickChipId.shorts,
      icon: CupertinoIcons.bolt_fill,
    ),
    _QuickChip(
      id: _QuickChipId.long,
      icon: CupertinoIcons.video_camera_solid,
    ),
    _QuickChip(
      id: _QuickChipId.recent,
      icon: CupertinoIcons.clock_fill,
    ),
  ];

  String _quickChipLabel(_QuickChipId id, AppLocalizations l10n) {
    switch (id) {
      case _QuickChipId.all:
        return l10n.filterAll;
      case _QuickChipId.today:
        return l10n.filterToday;
      case _QuickChipId.shorts:
        return l10n.filterShorts;
      case _QuickChipId.long:
        return l10n.filterLong;
      case _QuickChipId.recent:
        return l10n.filterRecent;
    }
  }

  bool _isQuickChipActive(_QuickChipId id, BrowseFilter filter) {
    switch (id) {
      case _QuickChipId.all:
        return filter.period == VideoTimePeriod.all &&
            filter.duration == VideoDurationFilter.any;
      case _QuickChipId.today:
        return filter.period == VideoTimePeriod.today;
      case _QuickChipId.shorts:
        return filter.duration == VideoDurationFilter.short;
      case _QuickChipId.long:
        return filter.duration == VideoDurationFilter.long;
      case _QuickChipId.recent:
        return filter.period == VideoTimePeriod.thisWeek;
    }
  }

  void _onQuickChipTap(_QuickChipId id) {
    final notifier = ref.read(browseFilterProvider.notifier);
    switch (id) {
      case _QuickChipId.all:
        notifier.state = const BrowseFilter();
      case _QuickChipId.today:
        notifier.state = const BrowseFilter(period: VideoTimePeriod.today);
      case _QuickChipId.shorts:
        notifier.state = const BrowseFilter(duration: VideoDurationFilter.short);
      case _QuickChipId.long:
        notifier.state = const BrowseFilter(duration: VideoDurationFilter.long);
      case _QuickChipId.recent:
        notifier.state = const BrowseFilter(period: VideoTimePeriod.thisWeek);
    }
  }

  Future<void> _showVideoOptions(AssetEntity asset) async {
    final l10n = AppLocalizations.of(context)!;
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
                builder: (_) => VideoInfoSheet(asset: asset),
              );
            },
            child: Text(l10n.getInfo),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(asset);
            },
            child: Text(l10n.deleteVideo),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(AssetEntity asset) async {
    // Capture messenger before any async gap
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(asset.title ?? l10n.thisVideo),
        message: Text(l10n.deleteVideoWarning),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteVideo),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    final deleted = await PhotoManager.editor.deleteWithIds([asset.id]);
    if (!mounted) return;
    if (deleted.contains(asset.id)) {
      ref.invalidate(videoLibraryProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.videoDeleted),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  // ── Date grouping helpers ─────────────────────────────────────────────────

  String _groupLabel(BuildContext context, DateTime dt, DateTime now) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(dt.year, dt.month, dt.day);

    if (itemDay == today) return l10n.today.toUpperCase();
    if (itemDay == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday.toUpperCase();
    }

    final locale = Localizations.localeOf(context).toString();
    if (dt.year == now.year) {
      return DateFormat.MMMd(locale).format(dt).toUpperCase();
    }
    return DateFormat.yMMMd(locale).format(dt).toUpperCase();
  }

  List<Object> _buildFlatList(BuildContext context, List<AssetEntity> videos) {
    final now = DateTime.now();
    final List<Object> flat = [];
    String? lastLabel;

    for (final v in videos) {
      final label = _groupLabel(context, v.createDateTime, now);
      if (label != lastLabel) {
        flat.add(label);
        lastLabel = label;
      }
      flat.add(v);
    }
    return flat;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(browseFilterProvider);
    final videosAsync = ref.watch(browseVideosProvider);
    final allAsync = ref.watch(videoLibraryProvider);

    return Scaffold(
      backgroundColor: RRColors.bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top navigation row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: RRSpace.sp4, vertical: RRSpace.sp4),
              child: Row(
                children: [
                  if (widget.onBack != null)
                  TextButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(
                      CupertinoIcons.chevron_left,
                      size: 16,
                      color: RRColors.accentCyan,
                    ),
                    label: Text(
                      l10n.feed,
                      style: const TextStyle(
                        color: RRColors.accentCyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: RRSpace.sp8, vertical: RRSpace.sp4),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleSearch,
                    child: Padding(
                      padding: const EdgeInsets.only(right: RRSpace.sp12),
                      child: Icon(
                        _searchActive
                            ? CupertinoIcons.xmark_circle_fill
                            : CupertinoIcons.search,
                        color: _searchActive
                            ? RRColors.accentCoral
                            : RRColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search field ───────────────────────────────────────────────
            if (_searchActive)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, 0, RRSpace.sp16, RRSpace.sp8),
                child: CupertinoTextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  placeholder: l10n.searchVideos,
                  placeholderStyle:
                      TextStyle(color: RRColors.textDisabled),
                  style: TextStyle(color: RRColors.textPrimary),
                  padding: const EdgeInsets.symmetric(
                      horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
                  decoration: BoxDecoration(
                    color: RRColors.bgElevated,
                    borderRadius:
                        BorderRadius.circular(RRSpace.radiusMd),
                  ),
                  clearButtonMode: OverlayVisibilityMode.editing,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(CupertinoIcons.search,
                        color: RRColors.textDisabled, size: 16),
                  ),
                ),
              ),

            // ── Header section ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, RRSpace.sp8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        allAsync.when(
                          loading: () => Text(
                            l10n.videosTitle,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          error: (_, __) => Text(
                            l10n.videosTitle,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          data: (all) => Text(
                            l10n.videosCount(all.length),
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.yourLibrary,
                          style: TextStyle(
                            fontSize: 14,
                            color: RRColors.textSecond,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LocalBadge(label: l10n.localBadge),
                      const SizedBox(height: RRSpace.sp8),
                      _FilterBtn(onTap: _openFilterSheet),
                    ],
                  ),
                ],
              ),
            ),

            // ── On This Day memories card ──────────────────────────────────
            _OnThisDayCard(onOpenPaywall: widget.onOpenPaywall),

            // ── Quick filter chips ─────────────────────────────────────────
            SizedBox(
              height: 44,
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.centerRight,
                  end: const Alignment(0.82, 0),
                  colors: const [Colors.transparent, Colors.white],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(
                      RRSpace.sp16, 0, RRSpace.sp32, 0),
                  itemCount: _quickChips.length,
                  itemBuilder: (context, i) {
                    final chip = _quickChips[i];
                    final active = _isQuickChipActive(chip.id, filter);
                    return _QuickChipTile(
                      chip: chip,
                      label: _quickChipLabel(chip.id, l10n),
                      active: active,
                      onTap: () => _onQuickChipTap(chip.id),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: RRSpace.sp12),

            // ── Divider ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp16),
              child: Divider(height: 1, thickness: 1, color: RRColors.divider),
            ),
            const SizedBox(height: RRSpace.sp4),

            // ── Main list ──────────────────────────────────────────────────
            Expanded(
              child: videosAsync.when(
                loading: () => const LoadingState(),
                error: (e, _) => Center(
                  child: Text(
                    l10n.couldNotLoadVideos('$e'),
                    style: TextStyle(color: RRColors.textSecond),
                  ),
                ),
                data: (rawVideos) {
                  final videos = _applySearch(rawVideos);
                  if (videos.isEmpty) {
                    return EmptyState(
                      icon: CupertinoIcons.search,
                      title: _searchQuery.isNotEmpty
                          ? l10n.noResults
                          : l10n.noVideosFound,
                      body: _searchQuery.isNotEmpty
                          ? l10n.noSearchMatches(_searchQuery)
                          : l10n.tryDifferentFilter,
                      buttonLabel: _searchQuery.isNotEmpty
                          ? l10n.clearSearch
                          : l10n.clearFilters,
                      onPressed: () {
                        if (_searchQuery.isNotEmpty) {
                          _searchCtrl.clear();
                        } else {
                          ref.read(browseFilterProvider.notifier).state =
                              const BrowseFilter();
                        }
                      },
                    );
                  }

                  final flat = _buildFlatList(context, videos);

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: flat.length,
                    itemBuilder: (context, index) {
                      final item = flat[index];
                      if (item is String) {
                        return _SectionHeader(label: item);
                      }
                      final asset = item as AssetEntity;
                      return _VideoRow(
                        asset: asset,
                        onTap: () {
                          widget.onScrollChanged?.call(_scrollController.offset);
                          widget.onPlayAt?.call(asset.id);
                          widget.onBack?.call();
                        },
                        onLongPress: () => _showVideoOptions(asset),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OnThisDayCard — memories entry point (Pro perk; teaser shown to everyone)
// ─────────────────────────────────────────────────────────────────────────────

class _OnThisDayCard extends ConsumerWidget {
  const _OnThisDayCard({this.onOpenPaywall});

  final VoidCallback? onOpenPaywall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(onThisDayProvider).valueOrNull ?? const [];
    if (memories.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final isPro = ref.watch(isProProvider);
    final years = DateTime.now().year - memories.first.createDateTime.year;
    final yearsAgo = years == 1 ? l10n.yearsAgoOne : l10n.yearsAgoMany(years);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          RRSpace.sp16, 0, RRSpace.sp16, RRSpace.sp12),
      child: GestureDetector(
        onTap: () {
          if (isPro) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const OnThisDayScreen()),
            );
          } else {
            onOpenPaywall?.call();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(RRSpace.sp12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                const Color(0xFF00D4FF).withValues(alpha: 0.18),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(RRSpace.radiusLg),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(CupertinoIcons.calendar_today,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: RRSpace.sp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onThisDay,
                      style: TextStyle(
                        color: RRColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      memories.length == 1
                          ? l10n.onThisDaySubtitleOne(yearsAgo)
                          : l10n.onThisDaySubtitleMany(memories.length),
                      style: TextStyle(
                        color: RRColors.textSecond,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isPro ? CupertinoIcons.chevron_right : CupertinoIcons.lock_fill,
                color: isPro ? RRColors.textDisabled : RRColors.accentAmber,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FilterBtn
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBtn extends StatelessWidget {
  const _FilterBtn({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
        decoration: BoxDecoration(
          color: RRColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              size: 14,
              color: RRColors.textSecond,
            ),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.filter,
              style: TextStyle(
                fontSize: 13,
                color: RRColors.textSecond,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick chip data + tile
// ─────────────────────────────────────────────────────────────────────────────

enum _QuickChipId { all, today, shorts, long, recent }

class _QuickChip {
  const _QuickChip({required this.id, required this.icon});

  final _QuickChipId id;
  final IconData icon;
}

class _QuickChipTile extends StatelessWidget {
  const _QuickChipTile({
    required this.chip,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final _QuickChip chip;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? RRColors.textPrimary : RRColors.textSecond;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: RRSpace.sp8),
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp16, vertical: RRSpace.sp8),
        decoration: BoxDecoration(
          gradient: active ? RRColors.gradBrand : null,
          color: active ? null : RRColors.bgElevated,
          borderRadius: BorderRadius.circular(RRSpace.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(chip.icon, size: 14, color: fg),
            const SizedBox(width: RRSpace.sp8),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionHeader
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          RRSpace.sp16, 20, RRSpace.sp16, RRSpace.sp8),
      child: Text(
        label,
        style: TextStyle(
          color: RRColors.textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoRow
// ─────────────────────────────────────────────────────────────────────────────

class _VideoRow extends StatefulWidget {
  const _VideoRow({
    required this.asset,
    required this.onTap,
    this.onLongPress,
  });

  final AssetEntity asset;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  State<_VideoRow> createState() => _VideoRowState();
}

class _VideoRowState extends State<_VideoRow> {
  Uint8List? _thumb;
  String? _title;

  @override
  void initState() {
    super.initState();
    _loadThumb();
    _loadTitle();
  }

  Future<void> _loadThumb() async {
    final bytes = await widget.asset
        .thumbnailDataWithSize(const ThumbnailSize(160, 160));
    if (mounted) setState(() => _thumb = bytes);
  }

  Future<void> _loadTitle() async {
    final title = await widget.asset.titleAsync;
    if (mounted && title.isNotEmpty) setState(() => _title = title);
  }

  String _relativeDate(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(dt.year, dt.month, dt.day);

    if (itemDay == today) return l10n.today;
    if (itemDay == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    }

    final locale = Localizations.localeOf(context).toString();
    if (dt.year == now.year) {
      return DateFormat.MMMd(locale).format(dt);
    }
    return DateFormat.yMMMd(locale).format(dt);
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final title = _title ??
        widget.asset.title ??
        _relativeDate(context, widget.asset.createDateTime);
    final durationStr = _formatDuration(widget.asset.duration);
    final dateStr = _relativeDate(context, widget.asset.createDateTime);
    final subtitle = '$durationStr · $dateStr';

    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp16, vertical: RRSpace.sp12),
        child: Row(
          children: [
            _BrowseThumbnail(
              bytes: _thumb,
              durationSeconds: widget.asset.duration,
            ),
            const SizedBox(width: RRSpace.sp12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: RRColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: RRColors.textSecond,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: RRSpace.sp8),
            Icon(
              CupertinoIcons.chevron_right,
              color: RRColors.textDisabled,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BrowseThumbnail
// ─────────────────────────────────────────────────────────────────────────────

class _BrowseThumbnail extends StatelessWidget {
  const _BrowseThumbnail({
    required this.bytes,
    required this.durationSeconds,
  });

  final Uint8List? bytes;
  final int durationSeconds;

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail image or placeholder
            if (bytes != null)
              Image.memory(bytes!, fit: BoxFit.cover)
            else
              Container(color: RRColors.bgElevated),

            // Duration badge — bottom left
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(RRSpace.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _formatDuration(durationSeconds),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
