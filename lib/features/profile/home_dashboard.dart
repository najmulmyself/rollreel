import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/favorites/favorites_provider.dart';
import '../../core/permissions/permission_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/video/video_collections_provider.dart';
import '../../core/video/video_library_provider.dart';
import '../../core/video/watch_history_provider.dart';
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

final _activityDateProvider = Provider.autoDispose<DateTime>((ref) {
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final timer = Timer(tomorrow.difference(now), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return now;
});

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key, required this.onPlayAt});

  final ValueChanged<String> onPlayAt;

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
    final now = ref.watch(_activityDateProvider);
    final summary = videos == null ? null : _LibrarySummary(videos, now);
    final history = ref.watch(watchHistoryProvider);
    final watchHistory = history.valueOrNull;
    final watchLoading = loading || history.isLoading;
    final watch = videos == null || watchHistory == null
        ? null
        : _WatchSummary(videos, watchHistory, now);
    final collections = loading ? null : ref.watch(topVideoCollectionsProvider);
    final showAlbums =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

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
        _ActivityRow(
          label: l10n.homeWatchedToday,
          value: valueLabel(watch?.watchedToday, isLoading: watchLoading),
        ),
        _ActivityRow(
          label: l10n.homePlays,
          value: valueLabel(watch?.plays, isLoading: watchLoading),
        ),
        _ActivityRow(
          label: l10n.homeWatchStreak,
          value: watchLoading
              ? l10n.homeLoading
              : watch == null
              ? l10n.homeUnavailable
              : l10n.homeWatchDays(watch.streak),
        ),
        const SizedBox(height: 17),
        _ActivityHeading(l10n.homeMostWatched),
        const SizedBox(height: 6),
        if (watchLoading)
          _ActivityNote(l10n.homeLoading)
        else if (watch == null)
          _ActivityNote(l10n.homeUnavailable)
        else if (watch.mostWatched.isEmpty) ...[
          _ActivityNote(l10n.homeNoWatchHistory),
          if (videos != null && videos.isNotEmpty)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => onPlayAt(videos.first.id),
                child: Text(l10n.homePlay),
              ),
            ),
        ] else
          for (final entry in watch.mostWatched)
            _MostWatchedRow(
              asset: entry.asset,
              plays: entry.plays,
              onTap: () => onPlayAt(entry.asset.id),
            ),
        const SizedBox(height: 17),
        _ActivityHeading(showAlbums ? l10n.homeTopAlbums : l10n.homeTopFolders),
        if (collections == null || collections.isLoading)
          _ActivityNote(l10n.loadingLibrary)
        else if (collections.hasError) ...[
          _ActivityNote(l10n.homeUnavailable),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => ref.invalidate(topVideoCollectionsProvider),
              child: Text(l10n.retry),
            ),
          ),
        ] else if (collections.requireValue.isEmpty) ...[
          if (permission.valueOrNull == PermissionState.limited) ...[
            _ActivityNote(l10n.homeLimitedVideoCollections),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: PhotoManager.openSetting,
                child: Text(l10n.openSettings),
              ),
            ),
          ] else
            _ActivityNote(
              showAlbums ? l10n.homeNoVideoAlbums : l10n.homeNoVideoFolders,
            ),
        ] else
          for (final collection in collections.requireValue)
            _ActivityRow(
              label: collection.name,
              value: l10n.videosCount(collection.count),
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
    for (final video in videos) {
      if (video.createDateSecond == null) continue;
      final date = video.createDateTime;
      if (date.year == today.year) year++;
      if (DateUtils.isSameDay(date, today)) this.today++;
    }
  }

  int today = 0;
  int year = 0;
}

typedef _RankedVideo = ({AssetEntity asset, int plays});

class _WatchSummary {
  _WatchSummary(List<AssetEntity> videos, WatchHistory history, DateTime now) {
    final today = watchDay(now);
    final watchedDays = <String>{};
    final ranked = <_RankedVideo>[];
    for (final asset in videos) {
      final days = history[asset.id];
      if (days == null) continue;
      final count = days.values.fold(0, (total, count) => total + count);
      plays += count;
      if (days.containsKey(today.toString())) watchedToday++;
      watchedDays.addAll(days.keys);
      ranked.add((asset: asset, plays: count));
    }

    var day = watchedDays.contains(today.toString()) ? today : today - 1;
    while (watchedDays.contains(day.toString())) {
      streak++;
      day--;
    }

    ranked.sort((a, b) {
      final byPlays = b.plays.compareTo(a.plays);
      return byPlays != 0
          ? byPlays
          : b.asset.createDateTime.compareTo(a.asset.createDateTime);
    });
    mostWatched = ranked.take(3).toList();
  }

  int watchedToday = 0;
  int plays = 0;
  int streak = 0;
  late final List<_RankedVideo> mostWatched;
}

class _MostWatchedRow extends ConsumerWidget {
  const _MostWatchedRow({
    required this.asset,
    required this.plays,
    required this.onTap,
  });

  final AssetEntity asset;
  final int plays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = ref.watch(homeTitleProvider(asset)).valueOrNull;
    return _ActivityRow(
      label: title ?? l10n.videoFallbackTitle,
      value: l10n.homePlayCount(plays),
      onTap: onTap,
    );
  }
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
  const _ActivityRow({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = RRTypography.body.copyWith(fontSize: 15, color: homeInk);
    final row = Container(
      constraints: const BoxConstraints(minHeight: 44),
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
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(CupertinoIcons.chevron_forward, size: 14, color: homeAccent),
          ],
        ],
      ),
    );
    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }
}
