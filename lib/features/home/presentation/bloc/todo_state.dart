
import 'package:todo/features/home/domain/entities/todo_entities.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final TodoStatus? currentFilter;
  
  TodoLoaded({required this.todos, this.currentFilter});
}

class TodoError extends TodoState {
  final String message;
  
  TodoError(this.message);
}