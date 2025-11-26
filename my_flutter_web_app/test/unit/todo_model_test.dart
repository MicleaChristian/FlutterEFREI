import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_web_app/models/todo.dart';

void main() {
  group('Todo Model Tests', () {
    test('should create Todo from Firestore document', () {
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);
      
      final firestoreData = {
        'userId': 'user123',
        'title': 'Test Todo',
        'isCompleted': false,
        'createdAt': timestamp,
        'updatedAt': timestamp,
        'priority': 'high',
        'description': 'Test description',
      };

      final todo = Todo.fromFirestore(firestoreData, 'doc123');

      expect(todo.id, 'doc123');
      expect(todo.userId, 'user123');
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, false);
      expect(todo.priority, 'high');
      expect(todo.description, 'Test description');
    });

    test('should convert Todo to Firestore document', () {
      final now = DateTime.now();
      final todo = Todo(
        id: 'doc123',
        userId: 'user123',
        title: 'Test Todo',
        isCompleted: false,
        createdAt: now,
        priority: 'high',
        description: 'Test description',
      );

      final firestoreData = todo.toFirestore();

      expect(firestoreData['userId'], 'user123');
      expect(firestoreData['title'], 'Test Todo');
      expect(firestoreData['isCompleted'], false);
      expect(firestoreData['priority'], 'high');
      expect(firestoreData['description'], 'Test description');
      expect(firestoreData['createdAt'], isA<Timestamp>());
    });

    test('should return correct priority color', () {
      final highPriorityTodo = Todo(
        id: '1',
        userId: 'user1',
        title: 'High Priority',
        priority: 'high',
        createdAt: DateTime.now(),
      );

      final mediumPriorityTodo = Todo(
        id: '2',
        userId: 'user1',
        title: 'Medium Priority',
        priority: 'medium',
        createdAt: DateTime.now(),
      );

      final lowPriorityTodo = Todo(
        id: '3',
        userId: 'user1',
        title: 'Low Priority',
        priority: 'low',
        createdAt: DateTime.now(),
      );

      expect(highPriorityTodo.priorityColor, 0xFFFF6B6B); // Red
      expect(mediumPriorityTodo.priorityColor, 0xFFFFD93D); // Yellow
      expect(lowPriorityTodo.priorityColor, 0xFF6BCF7F); // Green
    });

    test('should return correct priority icon', () {
      final highPriorityTodo = Todo(
        id: '1',
        userId: 'user1',
        title: 'High Priority',
        priority: 'high',
        createdAt: DateTime.now(),
      );

      final mediumPriorityTodo = Todo(
        id: '2',
        userId: 'user1',
        title: 'Medium Priority',
        priority: 'medium',
        createdAt: DateTime.now(),
      );

      final lowPriorityTodo = Todo(
        id: '3',
        userId: 'user1',
        title: 'Low Priority',
        priority: 'low',
        createdAt: DateTime.now(),
      );

      expect(highPriorityTodo.priorityIcon, '🔥');
      expect(mediumPriorityTodo.priorityIcon, '⚡');
      expect(lowPriorityTodo.priorityIcon, '🌱');
    });

    test('should handle null description', () {
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
        createdAt: DateTime.now(),
      );

      expect(todo.description, isNull);
      
      final firestoreData = todo.toFirestore();
      expect(firestoreData['description'], isNull);
    });

    test('should handle empty description', () {
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
        description: '',
        createdAt: DateTime.now(),
      );

      expect(todo.description, '');
      
      final firestoreData = todo.toFirestore();
      expect(firestoreData['description'], '');
    });
  });
}
