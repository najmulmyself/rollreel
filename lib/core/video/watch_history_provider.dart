import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Asset IDs mapped to play counts per local calendar day.
typedef WatchHistory = Map<String, Map<String, int>>;

// Use UTC midnight as a day number so consecutive local dates stay one day
// apart across daylight saving changes.
int watchDay(DateTime localDate) =>
    DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
    ).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

const _historyKey = 'video_watch_history';

final watchHistoryProvider =
    StateNotifierProvider<WatchHistoryNotifier, AsyncValue<WatchHistory>>(
      (_) => WatchHistoryNotifier(),
    );

class WatchHistoryNotifier extends StateNotifier<AsyncValue<WatchHistory>> {
  WatchHistoryNotifier() : super(const AsyncLoading()) {
    _ready = _load();
  }

  late final Future<void> _ready;
  Future<void> _writes = Future.value();

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data =
          jsonDecode(prefs.getString(_historyKey) ?? '{}')
              as Map<String, dynamic>;
      final history = data.map(
        (assetId, days) =>
            MapEntry(assetId, Map<String, int>.from(days as Map)),
      );
      if (mounted) state = AsyncData(history);
    } catch (error, stack) {
      if (mounted) state = AsyncError(error, stack);
    }
  }

  void recordPlay(String assetId) {
    final day = watchDay(DateTime.now()).toString();
    _writes = _writes
        .then((_) async {
          await _ready;
          if (!mounted || state.valueOrNull == null) return;
          final history = state.requireValue;
          final days = history[assetId] ?? const <String, int>{};
          final next = {
            ...history,
            assetId: {...days, day: (days[day] ?? 0) + 1},
          };
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString(_historyKey, jsonEncode(next))) {
            throw StateError('Could not save watch history');
          }
          if (mounted) state = AsyncData(next);
        })
        .catchError((Object error) {
          debugPrint('[RollReel] Could not record a play: $error');
        });
  }
}
