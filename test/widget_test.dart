import 'package:flutter_test/flutter_test.dart';
import 'package:water_leakage_app/main.dart';

void main() {
  testWidgets('App loads and displays title smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WaterLeakageApp());
    await tester.pumpAndSettle();

    // Verify that AquaReport brand and overview are present
    expect(find.text('AquaReport'), findsWidgets);
    expect(find.text('Complaint Overview'), findsOneWidget);
  });
}
