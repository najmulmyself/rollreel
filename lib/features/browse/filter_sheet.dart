import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/video/video_library_provider.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late BrowseFilter _temp;

  @override
  void initState() {
    super.initState();
    _temp = ref.read(browseFilterProvider);
  }

  // ─── Section label style ──────────────────────────────────────────────────

  static TextStyle get _sectionLabelStyle => TextStyle(
    color: RRColors.textDisabled,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  // ─── Chip builders ────────────────────────────────────────────────────────

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: RRSpace.sp8, bottom: RRSpace.sp8),
        padding: const EdgeInsets.symmetric(
            horizontal: RRSpace.sp16, vertical: RRSpace.sp8),
        decoration: BoxDecoration(
          gradient: active ? RRColors.gradBrand : null,
          color: active ? null : RRColors.bgElevated,
          borderRadius: BorderRadius.circular(RRSpace.radiusFull),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? RRColors.textPrimary : RRColors.textSecond,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─── Sort row builder ─────────────────────────────────────────────────────

  Widget _sortRow({
    required String label,
    required VideoSortOrder value,
    required bool isLast,
  }) {
    final selected = _temp.sort == value;
    return InkWell(
      onTap: () => setState(() => _temp = _temp.copyWith(sort: value)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: RRSpace.sp16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? RRColors.textPrimary
                          : RRColors.textSecond,
                      fontSize: 15,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    CupertinoIcons.checkmark_circle,
                    color: RRColors.accentCyan,
                    size: 20,
                  ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: RRColors.divider, indent: RRSpace.sp16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: RRColors.bgSurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(RRSpace.radiusXl),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: RRSpace.sp12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: RRColors.textDisabled,
                    borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                  ),
                ),
              ),

              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp16, RRSpace.sp8, RRSpace.sp8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          color: RRColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _temp = const BrowseFilter()),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: RRColors.accentCyan,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── TIME PERIOD ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, RRSpace.sp4),
                child: Text('TIME PERIOD', style: _sectionLabelStyle),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, RRSpace.sp4),
                child: Wrap(
                  children: [
                    _chip(
                      label: 'All',
                      active: _temp.period == VideoTimePeriod.all,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.all)),
                    ),
                    _chip(
                      label: 'Today',
                      active: _temp.period == VideoTimePeriod.today,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.today)),
                    ),
                    _chip(
                      label: 'This Week',
                      active: _temp.period == VideoTimePeriod.thisWeek,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.thisWeek)),
                    ),
                    _chip(
                      label: 'This Month',
                      active: _temp.period == VideoTimePeriod.thisMonth,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.thisMonth)),
                    ),
                    _chip(
                      label: '2026',
                      active: _temp.period == VideoTimePeriod.y2026,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.y2026)),
                    ),
                    _chip(
                      label: '2025',
                      active: _temp.period == VideoTimePeriod.y2025,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.y2025)),
                    ),
                    _chip(
                      label: '2024',
                      active: _temp.period == VideoTimePeriod.y2024,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(period: VideoTimePeriod.y2024)),
                    ),
                  ],
                ),
              ),

              // ── DURATION ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, RRSpace.sp4),
                child: Text('DURATION', style: _sectionLabelStyle),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, RRSpace.sp4),
                child: Row(
                  children: [
                    _chip(
                      label: 'Any',
                      active: _temp.duration == VideoDurationFilter.any,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(duration: VideoDurationFilter.any)),
                    ),
                    _chip(
                      label: '< 1 min',
                      active: _temp.duration == VideoDurationFilter.short,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(duration: VideoDurationFilter.short)),
                    ),
                    _chip(
                      label: '1–5 min',
                      active: _temp.duration == VideoDurationFilter.medium,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(duration: VideoDurationFilter.medium)),
                    ),
                    _chip(
                      label: '> 5 min',
                      active: _temp.duration == VideoDurationFilter.long,
                      onTap: () => setState(
                          () => _temp = _temp.copyWith(duration: VideoDurationFilter.long)),
                    ),
                  ],
                ),
              ),

              // ── SORT BY ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp12, RRSpace.sp16, RRSpace.sp8),
                child: Text('SORT BY', style: _sectionLabelStyle),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, 0, RRSpace.sp16, RRSpace.sp8),
                child: Container(
                  decoration: BoxDecoration(
                    color: RRColors.bgElevated,
                    borderRadius: BorderRadius.circular(RRSpace.radiusLg),
                  ),
                  child: Column(
                    children: [
                      _sortRow(
                          label: 'Newest First',
                          value: VideoSortOrder.newest,
                          isLast: false),
                      _sortRow(
                          label: 'Oldest First',
                          value: VideoSortOrder.oldest,
                          isLast: false),
                      _sortRow(
                          label: 'Shortest First',
                          value: VideoSortOrder.shortest,
                          isLast: false),
                      _sortRow(
                          label: 'Longest First',
                          value: VideoSortOrder.longest,
                          isLast: true),
                    ],
                  ),
                ),
              ),

              // ── Apply button ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RRSpace.sp16, RRSpace.sp8, RRSpace.sp16, RRSpace.sp24),
                child: GestureDetector(
                  onTap: () {
                    ref.read(browseFilterProvider.notifier).state = _temp;
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: RRSpace.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: RRColors.gradBrand,
                      borderRadius:
                          BorderRadius.circular(RRSpace.radiusFull),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: RRColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
