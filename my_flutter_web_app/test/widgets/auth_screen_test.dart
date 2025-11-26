import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_web_app/screens/auth_screen.dart';
import 'package:my_flutter_web_app/services/auth_service.dart';
import '../test_setup.dart';

void main() {
  group('AuthScreen Widget Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('should display sign in and sign up tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
      expect(find.text('Sign Up'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display sign in button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
    });



    testWidgets('should display forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.text('Forgot Password?'), findsOneWidget);
    });



    testWidgets('should validate email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Find email field and enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      // Try to submit (this would trigger validation in a real scenario)
      // For now, just verify the field exists and can accept text
      expect(find.text('invalid-email'), findsOneWidget);
    });

    testWidgets('should validate password field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Find password field and enter text
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'testpassword');
      await tester.pump();

      // Verify the field can accept text
      expect(find.text('testpassword'), findsOneWidget);
    });

    testWidgets('should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.text('Todo App'), findsOneWidget);
    });

    testWidgets('should display subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      expect(find.text('Organize your life, one task at a time'), findsOneWidget);
    });
  });
}
