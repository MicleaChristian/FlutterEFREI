import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserChange();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _checkUserChange() {
    final authService = context.read<AuthService>();
    final currentUserId = authService.user?.uid;
    
    if (_lastUserId != null && _lastUserId != currentUserId) {
      // User changed, show notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to account: ${authService.userEmail ?? 'Unknown'}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
    
    _lastUserId = currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStats(),
          _buildFilters(),
          _buildSearchBar(),
          Expanded(child: _buildTodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Todo App'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Consumer<AuthService>(
          builder: (context, authService, _) {
            return Container(
              padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                'Logged in as: ${authService.userEmail ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        Consumer<AuthService>(
          builder: (context, authService, _) {
            return PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'logout') {
                  await authService.signOut();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    authService.user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  todoProvider.totalTodos.toString(),
                  Icons.list,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  todoProvider.pendingTodos.toString(),
                  Icons.schedule,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  todoProvider.completedTodos.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all', todoProvider.currentFilter, todoProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending', todoProvider.currentFilter, todoProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed', todoProvider.currentFilter, todoProvider),
                const SizedBox(width: 8),
                _buildFilterChip('High', 'high', todoProvider.currentFilter, todoProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Medium', 'medium', todoProvider.currentFilter, todoProvider),
                const SizedBox(width: 8),
                _buildFilterChip('Low', 'low', todoProvider.currentFilter, todoProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, String currentFilter, TodoProvider todoProvider) {
    final isSelected = currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        todoProvider.setFilter(value);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search todos...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          context.read<TodoProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildTodoList() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        if (todoProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (todoProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading todos',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  todoProvider.errorMessage!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => todoProvider.refreshTodos(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (todoProvider.filteredTodos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  todoProvider.searchQuery.isNotEmpty
                      ? 'No todos found for "${todoProvider.searchQuery}"'
                      : todoProvider.currentFilter == 'all'
                          ? 'No todos yet!'
                          : 'No ${todoProvider.currentFilter} todos',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first todo',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => todoProvider.refreshTodos(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // Space for FAB
            itemCount: todoProvider.filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.filteredTodos[index];
              return TodoItem(todo: todo);
            },
          ),
        );
      },
    );
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }
}
