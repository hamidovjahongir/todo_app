import 'package:todo/features/home/domain/repository/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteTodo(id);
  }
}