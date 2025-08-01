enum TodoStatus { pending, inProgress, completed }

class Todo {
  final int? id;
  final String title;
  final String description;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}