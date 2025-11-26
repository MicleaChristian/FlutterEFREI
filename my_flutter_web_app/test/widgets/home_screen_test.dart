import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_web_app/screens/home_screen.dart';
import 'package:my_flutter_web_app/providers/todo_provider.dart';
import 'package:my_flutter_web_app/services/auth_service.dart';
import 'package:my_flutter_web_app/models/todo.dart';
import '../test_setup.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MockTodoProvider mockTodoProvider;
    late MockAuthService mockAuthService;

    setUp(() {
      mockTodoProvider = MockTodoProvider();
      mockAuthService = MockAuthService();
    });

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>.value(value: mockTodoProvider),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('Todo App'), findsOneWidget);
    });

    testWidgets('should display floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>.value(value: mockTodoProvider),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display stats cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>.value(value: mockTodoProvider),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Should find the stats section - use findsAtLeastNWidgets since there might be multiple instances
      expect(find.text('Total'), findsAtLeastNWidgets(1));
      expect(find.text('Pending'), findsAtLeastNWidgets(1));
      expect(find.text('Completed'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>.value(value: mockTodoProvider),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Should find filter chips - use findsAtLeastNWidgets since there might be multiple instances
      expect(find.text('All'), findsAtLeastNWidgets(1));
      expect(find.text('Pending'), findsAtLeastNWidgets(1));
      expect(find.text('Completed'), findsAtLeastNWidgets(1));
      expect(find.text('High'), findsAtLeastNWidgets(1));
      expect(find.text('Medium'), findsAtLeastNWidgets(1));
      expect(find.text('Low'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display search bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>.value(value: mockTodoProvider),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search todos...'), findsOneWidget);
    });
  });
}
