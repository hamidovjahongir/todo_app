import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/repository/todo_repository.dart';

class CreateTodo {
  final TodoRepository repository;

  CreateTodo(this.repository);

  Future<Todo> call(Todo todo) async {
    return await repository.createTodo(todo);
  }
}