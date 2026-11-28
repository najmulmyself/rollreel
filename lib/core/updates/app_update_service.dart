import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const rollReelAppStoreId = 6781843410;
final rollReelAppStoreUrl = Uri.https(
  'apps.apple.com',
  '/app/id$rollReelAppStoreId',
);

final appUpdateServiceProvider = Provider((ref) => AppUpdateService());

class AvailableAppUpdate {
  const AvailableAppUpdate(this.version);

  final String version;
}

class AppUpdateService {
  static const _dismissedVersionKey = 'updates_dismissed_version';
  static const _dismissedAtKey = 'updates_dismissed_at';
  static const _reminderDelay = Duration(days: 7);
  static const _checkInterval = Duration(hours: 6);

  DateTime? _checkedAt;
  AvailableAppUpdate? _available;
  bool _checking = false;

  Future<AvailableAppUpdate?> check() async {
    if (kIsWeb || !Platform.isIOS || _checking) return null;
    _checking = true;
    try {
      final preferences = await SharedPreferences.getInstance();
      final now = DateTime.now();
      if (_checkedAt == null || now.difference(_checkedAt!) >= _checkInterval) {
        final package = await PackageInfo.fromPlatform();
        _available = await _lookup(package);
        _checkedAt = now;
      }
      final update = _available;
      if (update == null) return null;
      final dismissedVersion = preferences.getString(_dismissedVersionKey);
      final dismissedAt = preferences.getInt(_dismissedAtKey);
      if (dismissedVersion == update.version && dismissedAt != null) {
        final elapsed = now.difference(
          DateTime.fromMillisecondsSinceEpoch(dismissedAt),
        );
        if (!elapsed.isNegative && elapsed < _reminderDelay) return null;
      }
      return update;
    } catch (error) {
      debugPrint('[RollReel] App Store update check unavailable: $error');
      return null;
    } finally {
      _checking = false;
    }
  }

  Future<void> remindLater(AvailableAppUpdate update) async {
    // Suppress another prompt in this process even if saving fails.
    _available = null;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_dismissedVersionKey, update.version);
      await preferences.setInt(
        _dismissedAtKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (error) {
      debugPrint('[RollReel] Could not save the update reminder: $error');
    }
  }

  Future<AvailableAppUpdate?> _lookup(PackageInfo package) async {
    final country =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    final uri = Uri.https('itunes.apple.com', '/lookup', {
      'id': '$rollReelAppStoreId',
      'country': country?.toUpperCase() ?? 'US',
      'entity': 'software',
    });
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);
    try {
      return await (() async {
        final request = await client.getUrl(uri);
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) return null;
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;
        if (results.length != 1) return null;
        final listing = results.single as Map<String, dynamic>;
        if (listing['trackId'] != rollReelAppStoreId ||
            listing['bundleId'] != package.packageName) {
          return null;
        }
        final version = listing['version'] as String;
        return _isNewer(version, package.version)
            ? AvailableAppUpdate(version)
            : null;
      })().timeout(const Duration(seconds: 6));
    } finally {
      client.close(force: true);
    }
  }

  bool _isNewer(String available, String installed) {
    // App Store marketing versions contain up to three numeric components.
    final pattern = RegExp(r'^\d+(\.\d+){0,2}$');
    if (!pattern.hasMatch(available) || !pattern.hasMatch(installed)) {
      return false;
    }
    final latest = available.split('.').map(int.parse).toList();
    final current = installed.split('.').map(int.parse).toList();
    for (var index = 0; index < 3; index++) {
      final next = index < latest.length ? latest[index] : 0;
      final previous = index < current.length ? current[index] : 0;
      if (next != previous) return next > previous;
    }
    return false;
  }
}
