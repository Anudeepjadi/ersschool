// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:ersschool/main.dart';
import 'package:ersschool/screens/splash/splash_screen.dart';
import 'package:ersschool/screens/login/login_screen.dart';

void main() {
  testWidgets('Splash screen loads and navigates to login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ERPApp());

    // Verify that the SplashScreen is present.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Pump to let the 3-second timer and animation complete
    await tester.pump(const Duration(seconds: 3));
    // Re-pump to let transition/navigation finish
    await tester.pumpAndSettle();

    // Verify that the LoginScreen is now active.
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
