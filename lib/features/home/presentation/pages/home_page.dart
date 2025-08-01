import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_form.dart';
import '../../domain/entities/todo_entities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    final todoBloc = BlocProvider.of<TodoBloc>(context); 
    showDialog(
      context: context,
      builder: (dialogContext) => TodoForm(
        
        onSubmit: (title, description) {
          todoBloc.add(AddTodo(
            title: title,
            description: description,
          ));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App',
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            final TodoBloc bloc = BlocProvider.of<TodoBloc>(context);
            
            switch (index) {
              case 0:
                bloc.add(FilterTodos(null)); 
                break;
              case 1:
                bloc.add(FilterTodos(TodoStatus.pending)); 
                break;
              case 2:
                bloc.add(FilterTodos(TodoStatus.inProgress)); 
                break;
              case 3:
                bloc.add(FilterTodos(TodoStatus.completed)); 
                break;
            }
          },
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Hammasi'),
            Tab(text: 'Kutilmoqda'),
            Tab(text: 'Jarayonda'),
            Tab(text: 'Bajarilgan'),
          ],
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return  Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is TodoError) {
            return Center(
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                   SizedBox(height: 16),
                  Text(
                    'Xatolik yuz berdi',
                    
                  ),
                   SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 16),
                  
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                    },
                    child: Text('Qayta urinish'),
                  ),
                ],
              ),
            );
          }
          
          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                     SizedBox(height: 16),
                    Text(
                      'Hozircha vazifalar yoq',
                      
                    ),
                     SizedBox(height: 8),
                    
                  ],
                ),
              );
            }
            
            return 
           _tabController.index == 0
    ? RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<TodoBloc>(context).add(LoadTodos());
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.todos.length,
          itemBuilder: (context, index) {
            final todo = state.todos[index];
            return TodoItem(
              todo: todo,
              onStatusChanged: (newStatus) {
                final updatedTodo = todo.copyWith(status: newStatus);
                BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(updatedTodo));
              },
              onEdit: (editedTodo) {
                BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(editedTodo));
              },
              onDelete: () {
                BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(todo.id!));
              },
            );
          },
        ),
      )
    : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.todos.length,
        itemBuilder: (context, index) {
          final todo = state.todos[index];
          return TodoItem(
            todo: todo,
            onStatusChanged: (newStatus) {
              final updatedTodo = todo.copyWith(status: newStatus);
              BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(updatedTodo));
            },
            onEdit: (editedTodo) {
              BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(editedTodo));
            },
            onDelete: () {
              BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(todo.id!));
            },
          );
        },
      );
          }
          
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}