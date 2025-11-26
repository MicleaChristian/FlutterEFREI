import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_web_app/providers/todo_provider.dart';
import 'package:my_flutter_web_app/services/auth_service.dart';

/// Test configuration and helper functions for the todo app tests
class TestConfig {
  /// Creates a test app with the necessary providers
  static Widget createTestApp({
    required Widget child,
    TodoProvider? todoProvider,
    AuthService? authService,
  }) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TodoProvider>.value(
            value: todoProvider ?? TodoProvider(),
          ),
          ChangeNotifierProvider<AuthService>.value(
            value: authService ?? AuthService(),
          ),
        ],
        child: child,
      ),
    );
  }

  /// Creates a test app with only AuthService provider
  static Widget createAuthTestApp({
    required Widget child,
    AuthService? authService,
  }) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthService>.value(
        value: authService ?? AuthService(),
        child: child,
      ),
    );
  }

  /// Waits for the widget to settle and handles common test timing issues
  static Future<void> waitForWidgetToSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
    // Additional wait to ensure all animations and async operations complete
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Creates a mock todo for testing
  static Map<String, dynamic> createMockTodoData({
    String id = 'test-id',
    String userId = 'user123',
    String title = 'Test Todo',
    bool isCompleted = false,
    String priority = 'medium',
    String? description,
  }) {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority,
      'description': description,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }
}
