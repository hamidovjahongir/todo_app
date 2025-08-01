
import 'package:todo/features/home/domain/entities/todo_entities.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class FilterTodos extends TodoEvent {
  final TodoStatus? status;
  FilterTodos(this.status);
}

class AddTodo extends TodoEvent {
  final String title;
  final String description;
  
  AddTodo({required this.title, required this.description});
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;
  
  UpdateTodoEvent(this.todo);
}

class DeleteTodoEvent extends TodoEvent {
  final int id;
  
  DeleteTodoEvent(this.id);
}