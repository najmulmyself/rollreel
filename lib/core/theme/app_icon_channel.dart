import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'logo_variant.dart';

/// Bridges to native iOS alternate-icon APIs. No-op on platforms that
/// don't support it (Android, web, etc.) — the in-app logo variant still
/// switches even if the home-screen icon can't.
class AppIconChannel {
  const AppIconChannel._();

  static const _channel = MethodChannel('rollreel/app_icon');

  /// `null` selects the primary (default) icon.
  static const Map<LogoVariant, String?> _iconNames = {
    LogoVariant.iconic: null,
    LogoVariant.classic: 'AppIcon-Alt',
  };

  static Future<void> setIcon(LogoVariant variant) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<bool>('setIcon', {
        'iconName': _iconNames[variant],
      });
    } catch (e) {
      debugPrint('AppIconChannel.setIcon error: $e');
    }
  }
}
