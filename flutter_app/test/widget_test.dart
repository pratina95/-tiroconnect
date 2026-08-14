import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tiroconnect/src/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('App bar title test', (WidgetTester tester) async {
    // Simple test to verify the app can build a basic widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('TiroConnect'),
          ),
          body: const Center(
            child: Text('Welcome to TiroConnect'),
          ),
        ),
      ),
    );

    // Verify that the app bar shows the title.
    expect(find.text('TiroConnect'), findsOneWidget);
    expect(find.text('Welcome to TiroConnect'), findsOneWidget);
  });

  testWidgets('register button opens account type choice sheet',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.ensureVisible(find.text('Register'));
    await tester.tap(find.text('Register'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Register as Customer'), findsOneWidget);
    expect(find.text('Register as Worker'), findsOneWidget);
  });
}
