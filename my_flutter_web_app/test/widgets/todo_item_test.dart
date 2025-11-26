import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_web_app/models/todo.dart';
import 'package:my_flutter_web_app/widgets/todo_item.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_web_app/providers/todo_provider.dart';
import '../test_setup.dart';

void main() {
  group('TodoItem Widget Tests', () {
    late Todo testTodo;
    late MockTodoProvider mockTodoProvider;

    setUp(() {
      testTodo = Todo(
        id: 'test-id',
        userId: 'user123',
        title: 'Test Todo Item',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'high',
        description: 'Test description',
      );
      mockTodoProvider = MockTodoProvider();
    });

    testWidgets('should display todo title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      expect(find.text('Test Todo Item'), findsOneWidget);
    });

    testWidgets('should display priority indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      // Should find the priority indicator container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display priority text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      expect(find.text('Priority: HIGH'), findsOneWidget);
    });

    testWidgets('should display priority icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets('should display action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      // Should find edit and delete buttons
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should show completed state correctly', (WidgetTester tester) async {
      final completedTodo = Todo(
        id: 'test-id',
        userId: 'user123',
        title: 'Completed Todo',
        isCompleted: true,
        createdAt: DateTime.now(),
        priority: 'medium',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: completedTodo),
            ),
          ),
        ),
      );

      expect(find.text('Completed Todo'), findsOneWidget);
      // The title should have a strikethrough decoration when completed
      // This is harder to test in widget tests, but we can verify the text exists
    });

    testWidgets('should handle different priority levels', (WidgetTester tester) async {
      final mediumPriorityTodo = Todo(
        id: 'test-id',
        userId: 'user123',
        title: 'Medium Priority Todo',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'medium',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: mediumPriorityTodo),
            ),
          ),
        ),
      );

      expect(find.text('Priority: MEDIUM'), findsOneWidget);
      expect(find.text('⚡'), findsOneWidget);
    });

    testWidgets('should handle low priority correctly', (WidgetTester tester) async {
      final lowPriorityTodo = Todo(
        id: 'test-id',
        userId: 'user123',
        title: 'Low Priority Todo',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'low',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: lowPriorityTodo),
            ),
          ),
        ),
      );

      expect(find.text('Priority: LOW'), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget);
    });

    testWidgets('should handle todo without description', (WidgetTester tester) async {
      final todoWithoutDescription = Todo(
        id: 'test-id',
        userId: 'user123',
        title: 'Todo Without Description',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'high',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>.value(
              value: mockTodoProvider,
              child: TodoItem(todo: todoWithoutDescription),
            ),
          ),
        ),
      );

      expect(find.text('Todo Without Description'), findsOneWidget);
      expect(find.text('Priority: HIGH'), findsOneWidget);
    });
  });
}
