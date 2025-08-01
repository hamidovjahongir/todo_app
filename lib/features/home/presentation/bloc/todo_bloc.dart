import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/usecases/create_todo_usecase.dart';
import 'package:todo/features/home/domain/usecases/delete_todo_usecase.dart';
import 'package:todo/features/home/domain/usecases/get_todos_by_status.dart';
import 'package:todo/features/home/domain/usecases/get_todos_usecase.dart';
import 'package:todo/features/home/domain/usecases/update_todo_usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final GetTodosByStatus getTodosByStatus;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.getTodosByStatus,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<FilterTodos>(_onFilterTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodos();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  
  void _onFilterTodos(FilterTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = event.status == null
          ? await getTodos()
          : await getTodosByStatus(event.status!);
      emit(TodoLoaded(todos: todos, currentFilter: event.status));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final now = DateTime.now();
      final todo = Todo(
        title: event.title,
        description: event.description,
        status: TodoStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      
      await createTodo(todo);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final updatedTodo = event.todo.copyWith(updatedAt: DateTime.now());
      await updateTodo(updatedTodo);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await deleteTodo(event.id);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}