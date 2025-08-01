import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/home/data/datasources/database_helper.dart';
import 'package:todo/features/home/data/repository/todo_repository_Impl.dart';
import 'package:todo/features/home/domain/usecases/create_todo_usecase.dart';
import 'package:todo/features/home/domain/usecases/delete_todo_usecase.dart';
import 'package:todo/features/home/domain/usecases/get_todos_by_status.dart';
import 'package:todo/features/home/domain/usecases/get_todos_usecase.dart';
import 'package:todo/features/home/domain/usecases/update_todo_usecase.dart';
import 'package:todo/features/home/presentation/bloc/todo_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';

final DatabaseHelper db = DatabaseHelper.instance;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      
      home: BlocProvider(
        create: (context) {
          
          final repository = TodoRepositoryImpl(db);
          return TodoBloc(
            getTodos: GetTodos(repository),
            getTodosByStatus: GetTodosByStatus(repository),
            createTodo: CreateTodo(repository),
            updateTodo: UpdateTodo(repository),
            deleteTodo: DeleteTodo(repository),
          );
        },
        child: const HomePage(),
      ),
    );
  }
}