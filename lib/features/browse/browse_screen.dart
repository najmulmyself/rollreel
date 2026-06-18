import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/video/video_library_provider.dart';
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
  });

  final VoidCallback? onBack;
  final void Function(String assetId)? onPlayAt;
  final double initialScrollOffset;
  final void Function(double offset)? onScrollChanged;

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
      label: 'All',
      icon: CupertinoIcons.rectangle_stack_fill,
    ),
    _QuickChip(
      label: 'Today',
      icon: CupertinoIcons.calendar,
    ),
    _QuickChip(
      label: 'Shorts',
      icon: CupertinoIcons.bolt_fill,
    ),
    _QuickChip(
      label: 'Long',
      icon: CupertinoIcons.video_camera_solid,
    ),
    _QuickChip(
      label: 'Recent',
      icon: CupertinoIcons.clock_fill,
    ),
  ];

  bool _isQuickChipActive(String label, BrowseFilter filter) {
    switch (label) {
      case 'All':
        return filter.period == VideoTimePeriod.all &&
            filter.duration == VideoDurationFilter.any;
      case 'Today':
        return filter.period == VideoTimePeriod.today;
      case 'Shorts':
        return filter.duration == VideoDurationFilter.short;
      case 'Long':
        return filter.duration == VideoDurationFilter.long;
      case 'Recent':
        return filter.period == VideoTimePeriod.thisWeek;
      default:
        return false;
    }
  }

  void _onQuickChipTap(String label) {
    final notifier = ref.read(browseFilterProvider.notifier);
    switch (label) {
      case 'All':
        notifier.state = const BrowseFilter();
      case 'Today':
        notifier.state = const BrowseFilter(period: VideoTimePeriod.today);
      case 'Shorts':
        notifier.state = const BrowseFilter(duration: VideoDurationFilter.short);
      case 'Long':
        notifier.state = const BrowseFilter(duration: VideoDurationFilter.long);
      case 'Recent':
        notifier.state = const BrowseFilter(period: VideoTimePeriod.thisWeek);
    }
  }

  Future<void> _showVideoOptions(AssetEntity asset) async {
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
            child: const Text('Get Info'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(asset);
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

  Future<void> _confirmDelete(AssetEntity asset) async {
    // Capture messenger before any async gap
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(asset.title ?? 'This video'),
        message: const Text(
            'This will permanently delete the video from your library.'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Video'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
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
          content: const Text('Video deleted'),
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

  String _groupLabel(DateTime dt, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(dt.year, dt.month, dt.day);

    if (itemDay == today) return 'TODAY';
    if (itemDay == today.subtract(const Duration(days: 1))) return 'YESTERDAY';

    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];

    if (dt.year == now.year) {
      return '${months[dt.month - 1]} ${dt.day}';
    }
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  List<Object> _buildFlatList(List<AssetEntity> videos) {
    final now = DateTime.now();
    final List<Object> flat = [];
    String? lastLabel;

    for (final v in videos) {
      final label = _groupLabel(v.createDateTime, now);
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
                    label: const Text(
                      'Feed',
                      style: TextStyle(
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
                  placeholder: 'Search videos…',
                  placeholderStyle:
                      const TextStyle(color: RRColors.textDisabled),
                  style: const TextStyle(color: RRColors.textPrimary),
                  padding: const EdgeInsets.symmetric(
                      horizontal: RRSpace.sp12, vertical: RRSpace.sp8),
                  decoration: BoxDecoration(
                    color: RRColors.bgElevated,
                    borderRadius:
                        BorderRadius.circular(RRSpace.radiusMd),
                  ),
                  clearButtonMode: OverlayVisibilityMode.editing,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8),
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
                          loading: () => const Text(
                            'Videos',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          error: (_, __) => const Text(
                            'Videos',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          data: (all) => Text(
                            '${all.length} Videos',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: RRColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Your Library',
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
                      const LocalBadge(label: 'Local'),
                      const SizedBox(height: RRSpace.sp8),
                      _FilterBtn(onTap: _openFilterSheet),
                    ],
                  ),
                ],
              ),
            ),

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
                    final active = _isQuickChipActive(chip.label, filter);
                    return _QuickChipTile(
                      chip: chip,
                      active: active,
                      onTap: () => _onQuickChipTap(chip.label),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: RRSpace.sp12),

            // ── Divider ────────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: RRSpace.sp16),
              child: Divider(height: 1, thickness: 1, color: RRColors.divider),
            ),
            const SizedBox(height: RRSpace.sp4),

            // ── Main list ──────────────────────────────────────────────────
            Expanded(
              child: videosAsync.when(
                loading: () => const LoadingState(),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: RRColors.textSecond),
                  ),
                ),
                data: (rawVideos) {
                  final videos = _applySearch(rawVideos);
                  if (videos.isEmpty) {
                    return EmptyState(
                      icon: CupertinoIcons.search,
                      title: _searchQuery.isNotEmpty
                          ? 'No Results'
                          : 'No Videos Found',
                      body: _searchQuery.isNotEmpty
                          ? 'No videos match "$_searchQuery".'
                          : 'Try a different filter.',
                      buttonLabel: _searchQuery.isNotEmpty
                          ? 'Clear Search'
                          : 'Clear Filters',
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

                  final flat = _buildFlatList(videos);

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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              size: 14,
              color: RRColors.textSecond,
            ),
            SizedBox(width: 6),
            Text(
              'Filter',
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

class _QuickChip {
  const _QuickChip({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _QuickChipTile extends StatelessWidget {
  const _QuickChipTile({
    required this.chip,
    required this.active,
    required this.onTap,
  });

  final _QuickChip chip;
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
              chip.label,
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
        style: const TextStyle(
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

  String _relativeDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(dt.year, dt.month, dt.day);

    if (itemDay == today) return 'Today';
    if (itemDay == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    if (dt.year == now.year) {
      return '${months[dt.month - 1]} ${dt.day}';
    }
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
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
        _relativeDate(widget.asset.createDateTime);
    final durationStr = _formatDuration(widget.asset.duration);
    final dateStr = _relativeDate(widget.asset.createDateTime);
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
                    style: const TextStyle(
                      color: RRColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: RRColors.textSecond,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: RRSpace.sp8),
            const Icon(
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
