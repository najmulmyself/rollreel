import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/local_badge.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final videos = List.generate(12, (index) => 'Camera Clip ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RRColors.bgDeep,
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(CupertinoIcons.xmark),
        ),
        title: const Text('Your Library'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(RRSpace.sp20, RRSpace.sp16, RRSpace.sp20, RRSpace.sp12),
            child: Row(
              children: [
                Expanded(
                  child: Text('847 Videos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                ),
                LocalBadge(label: '100% Local'),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20),
              children: const [
                _FilterPill(icon: CupertinoIcons.rectangle_stack_fill, label: 'All', active: true),
                _FilterPill(icon: CupertinoIcons.calendar, label: 'Today'),
                _FilterPill(icon: CupertinoIcons.bolt_fill, label: 'Shorts'),
                _FilterPill(icon: CupertinoIcons.video_camera_solid, label: 'Long'),
                _FilterPill(icon: CupertinoIcons.clock_fill, label: 'Recent'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: videos.length,
              separatorBuilder: (_, __) => const Divider(indent: 68, height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(RRSpace.radiusMd),
                    child: Container(
                      width: 48,
                      height: 48,
                      color: RRColors.bgElevated,
                      child: const Icon(CupertinoIcons.play_fill, size: 18),
                    ),
                  ),
                  title: Text(videos[index], maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: const Text('0:32 · June 5, 2024'),
                  trailing: const Icon(CupertinoIcons.ellipsis_circle),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.icon, required this.label, this.active = false});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final fg = active ? RRColors.textPrimary : RRColors.textSecond;

    return Container(
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
    );
  }
}
