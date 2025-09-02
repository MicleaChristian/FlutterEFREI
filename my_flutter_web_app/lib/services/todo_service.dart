import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get todos stream for current user
  Stream<List<Todo>> getTodosStream() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromFirestore(doc.data(), doc.id))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt))); // Sort in memory instead
  }

  // Add new todo
  Future<void> addTodo(String title, {String priority = 'medium', String? description}) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final todo = Todo(
      id: '', // Will be set by Firestore
      userId: currentUserId!,
      title: title.trim(),
      priority: priority,
      description: description?.trim(),
      createdAt: DateTime.now(),
    );

    await _firestore.collection('todos').add(todo.toFirestore());
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('todos')
        .doc(todo.id)
        .update(todo.toFirestore());
  }

  // Toggle todo completion status
  Future<void> toggleTodoCompletion(String todoId, bool isCompleted) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('todos')
        .doc(todoId)
        .update({
          'isCompleted': isCompleted,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore.collection('todos').doc(todoId).delete();
  }

  // Update todo title
  Future<void> updateTodoTitle(String todoId, String newTitle) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('todos')
        .doc(todoId)
        .update({
          'title': newTitle.trim(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
  }

  // Update todo priority
  Future<void> updateTodoPriority(String todoId, String newPriority) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('todos')
        .doc(todoId)
        .update({
          'priority': newPriority,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
  }

  // Get todos by priority
  Stream<List<Todo>> getTodosByPriority(String priority) {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .where('priority', isEqualTo: priority)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromFirestore(doc.data(), doc.id))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt))); // Sort in memory instead
  }

  // Get completed todos
  Stream<List<Todo>> getCompletedTodos() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromFirestore(doc.data(), doc.id))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt))); // Sort in memory instead
  }

  // Get pending todos
  Stream<List<Todo>> getPendingTodos() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromFirestore(doc.data(), doc.id))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt))); // Sort in memory instead
  }

  // Search todos by title
  Stream<List<Todo>> searchTodos(String searchQuery) {
    if (currentUserId == null) return Stream.value([]);
    if (searchQuery.trim().isEmpty) return getTodosStream();

    // Note: Firestore doesn't support full-text search out of the box
    // This is a simple prefix search implementation
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromFirestore(doc.data(), doc.id))
            .where((todo) => todo.title.toLowerCase().contains(searchQuery.trim().toLowerCase()))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt))); // Sort in memory instead
  }
}
