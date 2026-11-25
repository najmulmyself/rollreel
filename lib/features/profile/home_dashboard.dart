import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_library_provider.dart';
import '../../l10n/app_localizations.dart';
import 'home_video_sections.dart';

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
    final permission = ref.watch(permissionProvider);
    if (permission.hasError) {
      return HomeLibraryError(
        onRetry: () => ref.invalidate(permissionProvider),
      );
    }
    if (!permission.isLoading && permission.valueOrNull?.hasAccess != true) {
      return const HomePhotosAccess();
    }
    final library = ref.watch(visibleVideosProvider);
    final favorites = ref.watch(_visibleFavoritesCountProvider);
    if (library.hasError && !permission.isLoading) {
      return HomeLibraryError(
        onRetry: () => ref.invalidate(videoLibraryProvider),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final numbers = NumberFormat.decimalPattern(locale);
    final loading = permission.isLoading || library.isLoading;
    final videos = loading ? null : library.valueOrNull;
    final summary = videos == null
        ? null
        : _LibrarySummary(videos, DateTime.now());

    String valueLabel(int? value, {bool isLoading = false}) {
      if (loading || isLoading) return l10n.homeLoading;
      return value == null ? l10n.homeUnavailable : numbers.format(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActivityHeading(l10n.homeYourActivity),
        _ActivityRow(
          label: l10n.homeRecordedToday,
          value: valueLabel(summary?.today),
        ),
        _ActivityRow(
          label: l10n.videosTitle,
          value: valueLabel(videos?.length),
        ),
        _ActivityRow(
          label: l10n.favorites,
          value: valueLabel(
            favorites.valueOrNull,
            isLoading: favorites.isLoading,
          ),
        ),
        const SizedBox(height: 17),
        _ActivityHeading(l10n.homeWatchActivity),
        const SizedBox(height: 6),
        _ActivityNote(l10n.homeNoWatchHistory),
        const SizedBox(height: 17),
        _ActivityHeading(l10n.homeTopFolders),
        if (loading)
          _ActivityNote(l10n.loadingLibrary)
        else if (summary == null || summary.folders.isEmpty)
          _ActivityNote(l10n.homeFolderDetailsUnavailable)
        else
          for (final folder in summary.folders)
            _ActivityRow(
              label: folder.name,
              value: l10n.videosCount(folder.count),
            ),
        const SizedBox(height: 17),
        _ActivityHeading(l10n.homeVideoRecap),
        _ActivityRow(
          label: l10n.homeRecordedThisYear,
          value: valueLabel(summary?.year),
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

class _ActivityHeading extends StatelessWidget {
  const _ActivityHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Semantics(header: true, child: Text(title, style: homeHeading)),
    );
  }
}

class _ActivityNote extends StatelessWidget {
  const _ActivityNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: RRTypography.subheadline.copyWith(
        height: 1.5,
        color: RRColors.isDark.value
            ? RRColors.textSecond
            : RRColors.brandMutedInk,
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final style = RRTypography.body.copyWith(fontSize: 15, color: homeInk);
    return Container(
      constraints: const BoxConstraints(minHeight: 43),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: homeRule)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: style.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
