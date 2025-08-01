
import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/repository/todo_repository.dart';

class GetTodosByStatus {
  final TodoRepository repository;

  GetTodosByStatus(this.repository);

  Future<List<Todo>> call(TodoStatus status) async {
    return await repository.getTodosByStatus(status);
  }
}