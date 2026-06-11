import 'package:flutter_test/flutter_test.dart';

import 'package:rollreel/app/rollreel_app.dart';

void main() {
  testWidgets('app boots to splash', (WidgetTester tester) async {
    await tester.pumpWidget(const RollReelApp());
    expect(find.text('RollReel'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();
  });
}
