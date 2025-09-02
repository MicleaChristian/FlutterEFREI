import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  String _currentFilter = 'all'; // 'all', 'pending', 'completed', 'high', 'medium', 'low'
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Todo> get todos => _todos;
  List<Todo> get filteredTodos => _filteredTodos;
  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get todos count by status
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;
  int get pendingTodos => _todos.where((todo) => !todo.isCompleted).length;

  // Initialize provider
  TodoProvider() {
    _loadTodos();
  }

  // Load todos from Firestore
  void _loadTodos() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _todoService.getTodosStream().listen(
      (todos) {
        _todos = todos;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Apply current filters and search
  void _applyFilters() {
    List<Todo> filtered = List.from(_todos);

    // Apply status filter
    switch (_currentFilter) {
      case 'pending':
        filtered = filtered.where((todo) => !todo.isCompleted).toList();
        break;
      case 'completed':
        filtered = filtered.where((todo) => todo.isCompleted).toList();
        break;
      case 'high':
      case 'medium':
      case 'low':
        filtered = filtered.where((todo) => todo.priority == _currentFilter).toList();
        break;
      default: // 'all'
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((todo) => todo.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredTodos = filtered;
  }

  // Set filter
  void setFilter(String filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Add new todo
  Future<void> addTodo(String title, {String priority = 'medium', String? description}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _todoService.addTodo(title, priority: priority, description: description);
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Toggle todo completion
  Future<void> toggleTodoCompletion(String todoId, bool isCompleted) async {
    try {
      await _todoService.toggleTodoCompletion(todoId, isCompleted);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update todo title
  Future<void> updateTodoTitle(String todoId, String newTitle) async {
    try {
      await _todoService.updateTodoTitle(todoId, newTitle);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update todo priority
  Future<void> updateTodoPriority(String todoId, String newPriority) async {
    try {
      await _todoService.updateTodoPriority(todoId, newPriority);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _todoService.deleteTodo(todoId);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh todos
  void refreshTodos() {
    _loadTodos();
  }
}
