import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TaskScreen(),
      debugShowCheckedModeBanner: false, // Turn off the debug banner
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  bool isSelected;

  Task(
      {required this.title, this.isCompleted = false, this.isSelected = false});
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }

  void toggleTaskSelection(int index) {
    _tasks[index].isSelected = !_tasks[index].isSelected;
    notifyListeners();
  }

  void removeSelectedTasks() {
    _tasks.removeWhere((task) => task.isSelected);
    notifyListeners();
  }
}

class TaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'New Reminder',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.blue, size: 36),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          value: task.isSelected,
                          onChanged: (bool? value) {
                            taskProvider.toggleTaskSelection(index);
                          },
                        ),
                        title: Text(task.title),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: taskProvider.tasks.any((task) => task.isSelected)
                ? () {
                    taskProvider.removeSelectedTasks();
                  }
                : null,
            child: Icon(Icons.delete),
          );
        },
      ),
    );
  }
}
