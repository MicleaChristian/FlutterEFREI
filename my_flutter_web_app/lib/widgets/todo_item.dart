import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildPriorityIndicator(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailingActions(),
        onTap: () => _toggleCompletion(),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      width: 8,
      height: 40,
      decoration: BoxDecoration(
        color: Color(widget.todo.priorityColor),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitle() {
    if (_isEditing) {
      return TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
          color: widget.todo.isCompleted ? Colors.grey : null,
        ),
        onSubmitted: (_) => _saveTitle(),
        onEditingComplete: _saveTitle,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            widget.todo.title,
            style: TextStyle(
              decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
              color: widget.todo.isCompleted ? Colors.grey : null,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.todo.priorityIcon,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Row(
      children: [
        Text(
          'Priority: ${widget.todo.priority.toUpperCase()}',
          style: TextStyle(
            color: Color(widget.todo.priorityColor),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          _formatDate(widget.todo.createdAt),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button
        IconButton(
          icon: Icon(
            _isEditing ? Icons.check : Icons.edit_outlined,
            color: _isEditing ? Colors.green : Colors.blue,
          ),
          onPressed: _isEditing ? _saveTitle : _startEditing,
        ),
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: _deleteTodo,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _toggleCompletion() {
    if (!_isEditing) {
      final todoProvider = context.read<TodoProvider>();
      todoProvider.toggleTodoCompletion(
        widget.todo.id,
        !widget.todo.isCompleted,
      );
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _titleFocusNode.requestFocus();
  }

  void _saveTitle() async {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) {
      _titleController.text = widget.todo.title;
      setState(() {
        _isEditing = false;
      });
      return;
    }

    if (newTitle != widget.todo.title) {
      try {
        final todoProvider = context.read<TodoProvider>();
        await todoProvider.updateTodoTitle(widget.todo.id, newTitle);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating todo: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    setState(() {
      _isEditing = false;
    });
  }

  void _deleteTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${widget.todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final todoProvider = context.read<TodoProvider>();
                await todoProvider.deleteTodo(widget.todo.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting todo: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
