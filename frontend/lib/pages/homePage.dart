import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/pages/taskDialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  http.Client client = http.Client();

  Uri getTasksUrl = Uri.parse("http://10.0.2.2:8000/tasks/");
  Uri deleteTaskUrl(int taskId) {
    return Uri.parse("http://10.0.2.2:8000/tasks/$taskId/delete/");
  }

  Uri createTaskUrl = Uri.parse("http://10.0.2.2:8000/tasks/create/");
  Uri getTaskUrl(int taskId) {
    return Uri.parse("http://10.0.2.2:8000/tasks/$taskId/");
  }

  Uri updateTaskUrl(int taskId) {
    return Uri.parse("http://10.0.2.2:8000/tasks/$taskId/update/");
  }

  List<Task> tasks = [];

  @override
  void initState() {
    _retrieveTasks();
    super.initState();
  }

  _retrieveTasks() async {
    try {
      tasks = [];
      List response = json.decode((await client.get(getTasksUrl)).body);

      response.forEach((element) {
        tasks.add(Task.fromMap(element));
      });

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to retrieve tasks: $e")),
      );
    }
  }

  _addTask(Task newTask) async {
    try {
      final response = await client.post(
        createTaskUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newTask.toMap()),
      );

      if (response.statusCode == 200) {
        final createdTask = Task.fromMap(jsonDecode(response.body));
        setState(() {
          tasks.add(createdTask);
          _retrieveTasks();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task added successfully")),
        );
      } else {
        throw Exception("Failed to add task");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add task: $e")),
      );
    }
  }

  _toggleDone(Task task) async {
    try {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        content: task.content,
        done: !task.done,
        urgent: task.urgent,
      );

      final response = await client.put(
        updateTaskUrl(task.id),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedTask.toMap()),
      );

      if (response.statusCode == 200) {
        setState(() {
          task.done = !task.done;
        });
      } else {
        throw Exception("Failed to update task");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task: $e")),
      );
    }
  }

  _deleteTask(int taskId) async {
    try {
      final response = await client.delete(deleteTaskUrl(taskId));

      if (response.statusCode == 200) {
        setState(() {
          tasks.removeWhere((task) => task.id == taskId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task deleted successfully")),
        );
      } else {
        throw Exception("Failed to delete task");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete task: $e")),
      );
    }
  }

  _updateTask(Task updatedTask) async {
    try {
      final response = await client.put(
        updateTaskUrl(updatedTask.id),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedTask.toMap()),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = tasks.indexWhere((task) => task.id == updatedTask.id);
          if (index != -1) {
            tasks[index] = updatedTask;
          }
          _retrieveTasks();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task updated successfully")),
        );
      } else {
        throw Exception("Failed to update task");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.purple.shade100,
        backgroundColor: Colors.purple.shade300,
        elevation: 2,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: const Text(
          "Task Manager",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await _retrieveTasks();
        },
        color: Colors.purple,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            Task task = tasks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                color: task.done
                    ? Colors.green
                    : task.urgent
                        ? Colors.red
                        : Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.done
                          ? Colors.white
                          : task.urgent
                              ? Colors.white
                              : Colors.purple.shade800,
                    ),
                  ),
                  subtitle: Text(
                    task.content,
                    style: TextStyle(
                      decoration: task.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.done
                          ? Colors.white70
                          : task.urgent
                              ? Colors.white70
                              : Colors.purple.shade600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task.done
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                        ),
                        color: task.done
                            ? Colors.white
                            : task.urgent
                                ? Colors.white
                                : Colors.purple.shade700,
                        onPressed: () => _toggleDone(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: task.done
                            ? Colors.white
                            : task.urgent
                                ? Colors.white
                                : Colors.purple.shade700,
                        onPressed: () {
                          _deleteTask(task.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddTaskDialog(
                        existingTask: task,
                        onTaskAdded: (newTask) {},
                        onTaskUpdated: _updateTask,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade300,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onTaskAdded: _addTask,
              onTaskUpdated: (updatedTask) {},
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
