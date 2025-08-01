import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/repository/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getAllTodos();
  }
}