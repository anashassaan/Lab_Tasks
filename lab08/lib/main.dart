import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'Girly Todo App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
    required id,
  });
}

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title) {
    _todos.add(Todo(
      title: title,
    ));
    notifyListeners();
  }

  void toggleTodoStatus(int index) {
    _todos[index].isCompleted = !_todos[index].isCompleted;
    notifyListeners();
  }
}

class TodoListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Girly Todo App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(_controller.text);
                _controller.clear();
              }
            },
            child: Text('Add Task'),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ListView.builder(
                  itemCount: todoProvider.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoProvider.todos[index];
                    return ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          todo.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.pink,
                        ),
                        onPressed: () {
                          todoProvider.toggleTodoStatus(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
