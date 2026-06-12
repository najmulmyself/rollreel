import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../shared/widgets/local_badge.dart';
import '../../shared/widgets/video_thumbnail.dart';
import '../states/empty_state.dart';
import '../states/loading_state.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key, required this.onBack, this.onPlayAt});

  final VoidCallback onBack;
  final void Function(int index)? onPlayAt;

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videoLibraryProvider);
    final activeFilter = ref.watch(videoFilterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RRColors.bgDeep,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(CupertinoIcons.xmark),
        ),
        title: const Text('Your Library'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          videosAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.fromLTRB(RRSpace.sp20, RRSpace.sp16, RRSpace.sp20, RRSpace.sp12),
              child: Text('Loading...', style: RRTypography.title1),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (videos) => Padding(
              padding: const EdgeInsets.fromLTRB(RRSpace.sp20, RRSpace.sp16, RRSpace.sp20, RRSpace.sp12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${videos.length} Videos', style: RRTypography.title1),
                  ),
                  const LocalBadge(label: '100% Local'),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20),
              children: VideoFilter.values.map((f) {
                final (icon, label) = _filterMeta(f);
                return _FilterPill(
                  icon: icon,
                  label: label,
                  active: f == activeFilter,
                  onTap: () => ref.read(videoFilterProvider.notifier).state = f,
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: videosAsync.when(
              loading: () => const LoadingState(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (videos) {
                if (videos.isEmpty) {
                  return EmptyState(
                    icon: CupertinoIcons.search,
                    title: 'No Videos Found',
                    body: 'Try a different filter.',
                    buttonLabel: 'Clear Filters',
                    onPressed: () =>
                        ref.read(videoFilterProvider.notifier).state = VideoFilter.all,
                  );
                }
                return ListView.separated(
                  itemCount: videos.length,
                  separatorBuilder: (_, __) => const Divider(indent: 68, height: 1),
                  itemBuilder: (context, index) => _VideoRow(
                    asset: videos[index],
                    onTap: () {
                      widget.onPlayAt?.call(index);
                      widget.onBack();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String) _filterMeta(VideoFilter f) => switch (f) {
        VideoFilter.all => (CupertinoIcons.rectangle_stack_fill, 'All'),
        VideoFilter.today => (CupertinoIcons.calendar, 'Today'),
        VideoFilter.shorts => (CupertinoIcons.bolt_fill, 'Shorts'),
        VideoFilter.long => (CupertinoIcons.video_camera_solid, 'Long'),
        VideoFilter.recent => (CupertinoIcons.clock_fill, 'Recent'),
      };
}

class _VideoRow extends StatefulWidget {
  const _VideoRow({required this.asset, required this.onTap});

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  State<_VideoRow> createState() => _VideoRowState();
}

class _VideoRowState extends State<_VideoRow> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final bytes = await widget.asset.thumbnailDataWithSize(const ThumbnailSize(150, 150));
    if (mounted) setState(() => _thumb = bytes);
  }

  String _date(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.asset.title ?? _date(widget.asset.createDateTime);
    final subtitle = '${widget.asset.duration ~/ 60}:${(widget.asset.duration % 60).toString().padLeft(2, '0')}'
        ' · ${_date(widget.asset.createDateTime)}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20),
      leading: VideoThumbnail(
        bytes: _thumb,
        durationSeconds: widget.asset.duration,
        size: 48,
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: RRTypography.headline),
      subtitle: Text(subtitle, style: RRTypography.caption),
      trailing: const Icon(CupertinoIcons.ellipsis_circle, color: RRColors.textSecond),
      onTap: widget.onTap,
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
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
        padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp16, vertical: RRSpace.sp8),
        decoration: BoxDecoration(
          gradient: active ? RRColors.gradBrand : null,
          color: active ? null : RRColors.bgElevated,
          borderRadius: BorderRadius.circular(RRSpace.radiusFull),
          border: active ? null : Border.all(color: RRColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: RRSpace.sp8),
            Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
