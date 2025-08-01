import 'package:todo/features/home/data/model/todo_model.dart';
import 'package:todo/features/home/domain/entities/todo_entities.dart';
import 'package:todo/features/home/domain/repository/todo_repository.dart';

import '../datasources/database_helper.dart';

class TodoRepositoryImpl implements TodoRepository {
  final DatabaseHelper databaseHelper;

  TodoRepositoryImpl(this.databaseHelper);

  @override
  Future<List<Todo>> getAllTodos() async {
    final maps = await databaseHelper.queryAllRows();
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }

  @override
  Future<List<Todo>> getTodosByStatus(TodoStatus status) async {
    final maps = await databaseHelper.queryRowsByStatus(status.index);
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    final map = todoModel.toMap();
    map.remove('id'); 
    
    final id = await databaseHelper.insert(map);
    return todo.copyWith(id: id);
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    await databaseHelper.update(todoModel.toMap());
    return todo;
  }

  @override
  Future<void> deleteTodo(int id) async {
    await databaseHelper.delete(id);
  }
}