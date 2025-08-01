import 'package:todo/features/home/domain/entities/todo_entities.dart';

abstract class TodoRepository  {
   Future<List<Todo>> getAllTodos();
   Future<List<Todo>> getTodosByStatus(TodoStatus status);
   Future<Todo> createTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}