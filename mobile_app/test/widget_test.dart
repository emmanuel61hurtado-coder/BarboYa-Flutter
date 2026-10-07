import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('BarboYa app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BarboYaApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(BarboYaApp), findsOneWidget);
  });
}
