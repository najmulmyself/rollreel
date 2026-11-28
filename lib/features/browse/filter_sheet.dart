import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import 'library_widgets.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initialFilter});

  final BrowseFilter initialFilter;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late BrowseFilter _draft = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.libraryFilters,
                      style: libraryHeading.copyWith(fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _draft = const BrowseFilter());
                  },
                  style: TextButton.styleFrom(foregroundColor: libraryAccent),
                  child: Text(l10n.reset),
                ),
              ],
            ),
            _SectionLabel(l10n.timePeriod),
            Wrap(
              spacing: 6,
              children: [
                for (final period in VideoTimePeriod.values)
                  LibraryChip(
                    label: libraryPeriodLabel(l10n, period),
                    selected: _draft.period == period,
                    onPressed: () => setState(
                      () => _draft = _draft.copyWith(period: period),
                    ),
                    inSheet: true,
                  ),
              ],
            ),
            _SectionLabel(l10n.duration),
            Wrap(
              spacing: 6,
              children: [
                for (final duration in VideoDurationFilter.values)
                  LibraryChip(
                    label: libraryDurationLabel(l10n, duration),
                    selected: _draft.duration == duration,
                    onPressed: () => setState(
                      () => _draft = _draft.copyWith(duration: duration),
                    ),
                    inSheet: true,
                  ),
              ],
            ),
            _SectionLabel(l10n.sortBy),
            for (final sort in VideoSortOrder.values)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: libraryLine)),
                ),
                child: Semantics(
                  selected: _draft.sort == sort,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() => _draft = _draft.copyWith(sort: sort));
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsetsDirectional.fromSTEB(2, 6, 2, 6),
                      foregroundColor: _draft.sort == sort
                          ? libraryAccent
                          : libraryInk,
                      textStyle: RRTypography.subheadline.copyWith(
                        fontWeight: _draft.sort == sort
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(librarySortLabel(l10n, sort))),
                        if (_draft.sort == sort)
                          const Icon(CupertinoIcons.check_mark, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, _draft);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 49),
                backgroundColor: libraryAccent,
                textStyle: RRTypography.headline.copyWith(fontSize: 16),
                foregroundColor: libraryOnAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(l10n.applyFilters),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 4),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: RRTypography.headline.copyWith(
          color: libraryInk,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
