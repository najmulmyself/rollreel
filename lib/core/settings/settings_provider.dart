import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';

// ─── Keys ────────────────────────────────────────────────────────────────────

const _kLoop = 'settings_loop_short_videos';
const _kAutoPlay = 'settings_auto_play';
const _kDateLabels = 'settings_show_date_labels';
const _kDurationBadges = 'settings_show_duration_badges';
const _kDefaultFilter = 'settings_default_filter';
const _kDarkMode = 'settings_dark_mode';

// ─── Feed filter enum ─────────────────────────────────────────────────────────

enum FeedFilter { all, today, shorts, long }

extension FeedFilterLabel on FeedFilter {
  String get label {
    switch (this) {
      case FeedFilter.all:
        return 'All';
      case FeedFilter.today:
        return 'Today';
      case FeedFilter.shorts:
        return 'Shorts';
      case FeedFilter.long:
        return 'Long';
    }
  }
}

// ─── Model ───────────────────────────────────────────────────────────────────

class AppSettings {
  final bool loopShortVideos;
  final bool autoPlay;
  final bool showDateLabels;
  final bool showDurationBadges;
  final FeedFilter defaultFilter;
  final bool darkMode;

  const AppSettings({
    this.loopShortVideos = true,
    this.autoPlay = true,
    this.showDateLabels = true,
    this.showDurationBadges = true,
    this.defaultFilter = FeedFilter.all,
    this.darkMode = true,
  });

  AppSettings copyWith({
    bool? loopShortVideos,
    bool? autoPlay,
    bool? showDateLabels,
    bool? showDurationBadges,
    FeedFilter? defaultFilter,
    bool? darkMode,
  }) =>
      AppSettings(
        loopShortVideos: loopShortVideos ?? this.loopShortVideos,
        autoPlay: autoPlay ?? this.autoPlay,
        showDateLabels: showDateLabels ?? this.showDateLabels,
        showDurationBadges: showDurationBadges ?? this.showDurationBadges,
        defaultFilter: defaultFilter ?? this.defaultFilter,
        darkMode: darkMode ?? this.darkMode,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterIndex = prefs.getInt(_kDefaultFilter) ?? 0;
      final darkMode = prefs.getBool(_kDarkMode) ?? true;
      RRColors.isDark.value = darkMode;
      state = AppSettings(
        loopShortVideos: prefs.getBool(_kLoop) ?? true,
        autoPlay: prefs.getBool(_kAutoPlay) ?? true,
        showDateLabels: prefs.getBool(_kDateLabels) ?? true,
        showDurationBadges: prefs.getBool(_kDurationBadges) ?? true,
        defaultFilter: FeedFilter.values[filterIndex.clamp(0, FeedFilter.values.length - 1)],
        darkMode: darkMode,
      );
    } catch (_) {}
  }

  Future<void> setLoopShortVideos(bool value) async {
    state = state.copyWith(loopShortVideos: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoop, value);
  }

  Future<void> setAutoPlay(bool value) async {
    state = state.copyWith(autoPlay: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoPlay, value);
  }

  Future<void> setShowDateLabels(bool value) async {
    state = state.copyWith(showDateLabels: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDateLabels, value);
  }

  Future<void> setShowDurationBadges(bool value) async {
    state = state.copyWith(showDurationBadges: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDurationBadges, value);
  }

  Future<void> setDefaultFilter(FeedFilter value) async {
    state = state.copyWith(defaultFilter: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDefaultFilter, value.index);
  }

  Future<void> setDarkMode(bool value) async {
    state = state.copyWith(darkMode: value);
    RRColors.isDark.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, value);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
