import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';

final _visibleFavoritesCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final videos = ref.watch(visibleVideosProvider.future);
  final favorites = ref.watch(favoritesIdsProvider.notifier);
  ref.watch(favoritesIdsProvider);
  await favorites.ready;
  return (await videos).where((video) => favorites.contains(video.id)).length;
});

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final library = ref.watch(visibleVideosProvider);
    final favorites = ref.watch(_visibleFavoritesCountProvider);
    final locale = Localizations.localeOf(context).toString();
    final numbers = NumberFormat.decimalPattern(locale);
    final now = DateTime.now();
    final videos = library.isLoading ? null : library.asData?.value;
    final summary = videos == null ? null : _LibrarySummary(videos, now);

    String valueLabel(int? value, {required bool loading}) {
      if (loading) return l10n.homeLoading;
      return value == null ? l10n.homeUnavailable : numbers.format(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DashboardCard(
          title: l10n.today,
          children: [
            _DashboardRow(
              label: l10n.homeRecordedToday,
              value: valueLabel(summary?.today, loading: library.isLoading),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 10.0;
            final width = (constraints.maxWidth - gap) / 2;
            final metrics = [
              (
                icon: CupertinoIcons.videocam,
                label: l10n.videosTitle,
                value: valueLabel(videos?.length, loading: library.isLoading),
              ),
              (
                icon: CupertinoIcons.heart,
                label: l10n.favorites,
                value: valueLabel(
                  favorites.asData?.value,
                  loading: favorites.isLoading,
                ),
              ),
              (
                icon: CupertinoIcons.play,
                label: l10n.homePlays,
                value: l10n.homeUnavailable,
              ),
              (
                icon: CupertinoIcons.device_phone_portrait,
                label: l10n.homeStorage,
                value: l10n.homeUnavailable,
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: _DashboardSurface(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(metric.icon, color: _accent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(metric.label, style: _secondary),
                                const SizedBox(height: 3),
                                Text(metric.value, style: _headline),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        _DashboardCard(
          title: l10n.homeWatchActivity,
          children: [
            Text(l10n.homeNoWatchHistory, style: _secondary),
            const SizedBox(height: 10),
            _DashboardRow(
              label: l10n.homeWatchStreak,
              value: l10n.homeUnavailable,
            ),
            _DashboardRow(
              label: l10n.homeMostWatched,
              value: l10n.homeUnavailable,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _DashboardCard(
          title: l10n.homeTopFolders,
          children: [
            if (library.isLoading)
              Text(l10n.loadingLibrary, style: _secondary)
            else if (summary == null || summary.folders.isEmpty)
              Text(l10n.homeFolderDetailsUnavailable, style: _secondary)
            else
              for (final folder in summary.folders)
                _DashboardRow(
                  label: folder.name,
                  value: l10n.videosCount(folder.count),
                ),
          ],
        ),
        const SizedBox(height: 14),
        _DashboardCard(
          title: l10n.homeVideoRecap,
          children: [
            _DashboardRow(
              label: l10n.homeRecordedThisYear,
              value: valueLabel(summary?.year, loading: library.isLoading),
            ),
          ],
        ),
      ],
    );
  }
}

class _LibrarySummary {
  _LibrarySummary(List<AssetEntity> videos, DateTime today) {
    final byPath = <String, ({String name, int count})>{};

    for (final video in videos) {
      if (video.createDateSecond != null) {
        final date = video.createDateTime;
        if (date.year == today.year) {
          year++;
          if (date.month == today.month && date.day == today.day) {
            this.today++;
          }
        }
      }

      final path = video.relativePath?.trim();
      if (path == null || path.isEmpty) continue;
      final parts = path
          .split(RegExp(r'[/\\]+'))
          .where((part) => part.isNotEmpty);
      if (parts.isEmpty) continue;
      final key = parts.join('/');
      byPath[key] = (name: parts.last, count: (byPath[key]?.count ?? 0) + 1);
    }

    final ranked = byPath.values.toList()
      ..sort((a, b) {
        final countOrder = b.count.compareTo(a.count);
        return countOrder == 0 ? a.name.compareTo(b.name) : countOrder;
      });
    folders = ranked.take(3).toList();
  }

  int today = 0;
  int year = 0;
  late final List<({String name, int count})> folders;
}

Color get _ink =>
    RRColors.isDark.value ? RRColors.textPrimary : RRColors.brandInk;
Color get _accent =>
    RRColors.isDark.value ? RRColors.accentCyan : RRColors.brandBlue;

TextStyle get _headline => RRTypography.headline.copyWith(color: _ink);
TextStyle get _secondary => RRTypography.subheadline.copyWith(
  color: RRColors.isDark.value ? RRColors.textSecond : RRColors.brandMutedInk,
);

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _DashboardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(title, style: _headline)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DashboardRow extends StatelessWidget {
  const _DashboardRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: _secondary)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: RRTypography.subheadline.copyWith(
                color: _ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSurface extends StatelessWidget {
  const _DashboardSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = RRColors.isDark.value;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RRColors.bgSurface,
        border: Border.all(
          color: isDark ? RRColors.divider : RRColors.brandOutline,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}
