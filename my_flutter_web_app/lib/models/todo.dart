import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String userId;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String priority; // 'low', 'medium', 'high'
  final String? description;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
    this.priority = 'medium',
    this.description,
  });

  // Create Todo from Firestore document
  factory Todo.fromFirestore(Map<String, dynamic> doc, String id) {
    return Todo(
      id: id,
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      isCompleted: doc['isCompleted'] ?? false,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: doc['updatedAt'] != null 
          ? (doc['updatedAt'] as Timestamp).toDate() 
          : null,
      priority: doc['priority'] ?? 'medium',
      description: doc['description'],
    );
  }

  // Convert Todo to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'priority': priority,
      'description': description,
    };
  }

  // Create a copy of Todo with updated values
  Todo copyWith({
    String? id,
    String? userId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? priority,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }

  // Get priority color
  int get priorityColor {
    switch (priority) {
      case 'high':
        return 0xFFFF6B6B; // Red
      case 'medium':
        return 0xFFFFD93D; // Yellow
      case 'low':
        return 0xFF6BCF7F; // Green
      default:
        return 0xFF6BCF7F; // Default green
    }
  }

  // Get priority icon
  String get priorityIcon {
    switch (priority) {
      case 'high':
        return '🔥';
      case 'medium':
        return '⚡';
      case 'low':
        return '🌱';
      default:
        return '⚡';
    }
  }
}