import 'package:flutter/material.dart';
import 'package:flutter_integration_test/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Integration Tests', () {
    testWidgets('should display login form elements', (tester) async {
      // Load the app
      await tester.pumpWidget(const MyApp());

      // Verify login form elements are present
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byKey(const ValueKey('email_field')), findsOneWidget);
      expect(find.byKey(const ValueKey('password_field')), findsOneWidget);
      expect(find.byKey(const ValueKey('login_button')), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Find and tap the login button without entering any data
      final loginButton = find.byKey(const ValueKey('login_button'));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Enter invalid email and valid password
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        'password123',
      );

      // Tap login button
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Enter valid email and short password
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        '123',
      );

      // Tap login button
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pumpAndSettle();

      // Verify password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should show error message for invalid credentials', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Enter invalid credentials
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'wrong@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        'wrongpassword',
      );

      // Tap login button
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pumpAndSettle();

      // Wait for the simulated API call to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify error message appears
      expect(find.byKey(const ValueKey('error_message')), findsOneWidget);
      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('should successfully login with valid credentials', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Enter valid credentials
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        'password123',
      );

      // Tap login button
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pumpAndSettle();

      // Wait for the simulated API call and navigation
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation to home page
      expect(find.byKey(const ValueKey('success_message')), findsOneWidget);
      expect(find.text('Login Successful!'), findsOneWidget);
    });

    testWidgets('should show loading indicator during login', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Enter valid credentials
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        'password123',
      );

      // Tap login button
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pump(); // Trigger one frame

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for login to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should logout and return to login page', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Login first
      await tester.enterText(
        find.byKey(const ValueKey('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const ValueKey('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on home page
      expect(find.text('Login Successful!'), findsOneWidget);

      // Tap logout button
      await tester.tap(find.byKey(const ValueKey('logout_button')));
      await tester.pumpAndSettle();

      // Verify we're back on login page
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byKey(const ValueKey('email_field')), findsOneWidget);
    });
  });
}

/*
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter', (
        tester,
        ) async {
      // Load app widget.
      await tester.pumpWidget(const MyApp());


      // Verify the counter starts at 0.
      expect(find.text('0'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('increment'));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);
    });
  });
}*/
