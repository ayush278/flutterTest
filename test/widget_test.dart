import 'package:flutter_test/flutter_test.dart';
import 'package:testflutter/view/home_view.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeView());
  });
}
