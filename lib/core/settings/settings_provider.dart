import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Keys ────────────────────────────────────────────────────────────────────

const _kLoop = 'settings_loop_short_videos';
const _kAutoPlay = 'settings_auto_play';
const _kDateLabels = 'settings_show_date_labels';
const _kDurationBadges = 'settings_show_duration_badges';

// ─── Model ───────────────────────────────────────────────────────────────────

class AppSettings {
  final bool loopShortVideos;
  final bool autoPlay;
  final bool showDateLabels;
  final bool showDurationBadges;

  const AppSettings({
    this.loopShortVideos = true,
    this.autoPlay = true,
    this.showDateLabels = true,
    this.showDurationBadges = true,
  });

  AppSettings copyWith({
    bool? loopShortVideos,
    bool? autoPlay,
    bool? showDateLabels,
    bool? showDurationBadges,
  }) =>
      AppSettings(
        loopShortVideos: loopShortVideos ?? this.loopShortVideos,
        autoPlay: autoPlay ?? this.autoPlay,
        showDateLabels: showDateLabels ?? this.showDateLabels,
        showDurationBadges: showDurationBadges ?? this.showDurationBadges,
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
      state = AppSettings(
        loopShortVideos: prefs.getBool(_kLoop) ?? true,
        autoPlay: prefs.getBool(_kAutoPlay) ?? true,
        showDateLabels: prefs.getBool(_kDateLabels) ?? true,
        showDurationBadges: prefs.getBool(_kDurationBadges) ?? true,
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
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
