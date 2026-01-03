import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_up/src/app.dart';

void main() {
  testWidgets('App builds verification', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We need a ProviderScope for Riverpod
    await tester.pumpWidget(
      const ProviderScope(
        child: LevelUpApp(),
      ),
    );

    // Verify that the Dashboard is present
    expect(find.text('DASHBOARD'), findsOneWidget);
  });
}
