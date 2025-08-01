import 'package:flutter/material.dart';
import '../../domain/entities/todo_entities.dart';
import 'todo_form.dart';


class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(TodoStatus) onStatusChanged;
  final Function(Todo) onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onStatusChanged,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.orange;
      case TodoStatus.inProgress:
        return Colors.blue;
      case TodoStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Kutilmoqda';
      case TodoStatus.inProgress:
        return 'Jarayonda';
      case TodoStatus.completed:
        return 'Bajarilgan';
    }
  }

  IconData _getStatusIcon(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Icons.schedule;
      case TodoStatus.inProgress:
        return Icons.work;
      case TodoStatus.completed:
        return Icons.check_circle;
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => TodoForm(
        initialTitle: todo.title,
        initialDescription: todo.description,
        onSubmit: (title, description) {
          final updatedTodo = todo.copyWith(
            title: title,
            description: description,
          );
          onEdit(updatedTodo);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Status ozgartirish'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TodoStatus.values.map((status) {
            return ListTile(
              leading: Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
              ),
              title: Text(_getStatusText(status)),
              trailing: todo.status == status
                  ?  Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                onStatusChanged(status);
                Navigator.of(dialogContext).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:  Text('Ochirish'),
        content: Text('Bu vazifani ochirasizmi'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Bekor qilish'),
          ),
          
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child:  Text('Ochirish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getStatusColor(todo.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: todo.status == TodoStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(todo.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(todo.status).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(todo.status),
                        size: 14,
                        color: _getStatusColor(todo.status),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(todo.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(todo.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (todo.description.isNotEmpty) ...[
               SizedBox(height: 8),
              
              
              Text(
                todo.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ],
             SizedBox(height: 12),
            
            Row(
              children: [
                Text(
                  'Yaratilgan: ${_formatDate(todo.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                Spacer(),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showStatusDialog(context),
                      icon: const Icon(Icons.swap_horiz),
                      iconSize: 20,
                      color: Colors.blue,
                      tooltip: 'edit status',
                    ),
                    IconButton(
                      onPressed: () => _showEditDialog(context),
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      color: Colors.orange,
                      tooltip: 'etit todo',
                    ),
                    IconButton(
                      onPressed: () => _showDeleteDialog(context),
                      icon: const Icon(Icons.delete),
                      iconSize: 20,
                      color: Colors.red,
                      tooltip: 'delate',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}