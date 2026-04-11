// This is a basic Flutter widget test for the Mallu Smart app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mallu_smart/main.dart';

void main() {
  testWidgets('Mallu Smart home page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MalluSmartApp());

    // Verify that the app title is displayed in the AppBar or Header.
    // Since we have "MALLU SMART" in both the App Bar and the Header,
    // we check for the presence of the text.
    expect(find.text('MALLU SMART'), findsAtLeastNWidgets(1));

    // Verify that some product names from our sample data are present.
    expect(find.text('Minimalist Ceramic Vase'), findsOneWidget);
  });
}
