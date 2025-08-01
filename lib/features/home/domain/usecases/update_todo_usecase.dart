import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/repository/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<Todo> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}