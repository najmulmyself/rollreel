import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks "completed swipe sessions" and install date so an App Store
/// review prompt can be auto-triggered per PRD §13: after 3 completed
/// swipe sessions AND at least 24h post-install.
final reviewPromptProvider = Provider<ReviewPromptController>((ref) {
  return ReviewPromptController();
});

class ReviewPromptController {
  static const _kInstallDate = 'review_install_date';
  static const _kSessionCount = 'review_swipe_sessions';
  static const _kRequested = 'review_requested';
  static const _kSessionThreshold = 3;
  static const _kMinInstallAge = Duration(hours: 24);

  bool _hasSwipedThisSession = false;

  Future<void> ensureInstallDateRecorded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(_kInstallDate) == null) {
      await prefs.setInt(_kInstallDate, DateTime.now().millisecondsSinceEpoch);
    }
  }

  /// Call whenever the user swipes to a new video in the feed.
  void recordSwipe() {
    _hasSwipedThisSession = true;
  }

  /// Call when the app is backgrounded/closed. Counts the current
  /// session toward the threshold only if the user actually swiped.
  Future<void> endSession() async {
    if (!_hasSwipedThisSession) return;
    _hasSwipedThisSession = false;
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_kSessionCount) ?? 0) + 1;
    await prefs.setInt(_kSessionCount, count);
  }

  /// Call when the app becomes active/foreground. Triggers the native
  /// review prompt at most once, when both conditions are satisfied.
  Future<void> maybeRequestReview() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kRequested) ?? false) return;

    final sessionCount = prefs.getInt(_kSessionCount) ?? 0;
    if (sessionCount < _kSessionThreshold) return;

    final installMs = prefs.getInt(_kInstallDate);
    if (installMs == null) return;
    final installedAt = DateTime.fromMillisecondsSinceEpoch(installMs);
    if (DateTime.now().difference(installedAt) < _kMinInstallAge) return;

    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await prefs.setBool(_kRequested, true);
      review.requestReview();
    }
  }
}
