import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rollreel/features/onboarding/onboarding_screen.dart';
import 'package:rollreel/features/splash/splash_screen.dart';
import 'package:rollreel/l10n/app_localizations.dart';
import 'package:rollreel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('first launch advances from splash to onboarding', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('photo access can be retried and returns the native result', (
    tester,
  ) async {
    const photos = MethodChannel('com.fluttercandies/photo_manager');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final permission = Completer<int>();
    var requests = 0;
    messenger.setMockMethodCallHandler(photos, (call) async {
      expect(call.method, 'requestPermissionExtend');
      if (++requests == 1) throw PlatformException(code: 'photos-unavailable');
      return permission.future;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(photos, null));

    PermissionState? result;
    await _pumpOnboarding(tester, (value) => result = value);
    await _tap(tester, 'Get Started');
    await _tap(tester, 'Continue');
    await _tap(tester, 'Allow Access');

    expect(
      find.text('Couldn’t request access. Try again or skip for now.'),
      findsOneWidget,
    );
    expect(result, isNull);

    await tester.tap(find.text('Allow Access'));
    await tester.pump();
    expect(find.text('Requesting…'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    expect(result, isNull);

    permission.complete(PermissionState.limited.index);
    await tester.pumpAndSettle();

    expect(requests, 2);
    expect(result, PermissionState.limited);
  });

  testWidgets('swipe, back and skip work on a small phone with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PermissionState? result;
    await _pumpOnboarding(tester, (value) => result = value, textScale: 1.8);
    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    expect(find.text('Allow Access'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);

    await _tap(tester, 'Skip');
    expect(result, PermissionState.notDetermined);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpOnboarding(
  WidgetTester tester,
  ValueChanged<PermissionState> onDone, {
  double textScale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: OnboardingScreen(onDone: onDone),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}
