import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final Function(Task) onTaskUpdated;
  final Task? existingTask;

  const AddTaskDialog({
    super.key,
    required this.onTaskAdded,
    required this.onTaskUpdated,
    this.existingTask,
  });

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool isUrgent = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      titleController.text = widget.existingTask!.title;
      contentController.text = widget.existingTask!.content;
      isUrgent = widget.existingTask!.urgent;
    }
  }

  _saveTask() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      final updatedTask = Task(
        id: widget.existingTask?.id ?? 0,
        title: titleController.text,
        content: contentController.text,
        done: widget.existingTask?.done ?? false,
        urgent: isUrgent,
      );

      if (widget.existingTask != null) {
        widget.onTaskUpdated(updatedTask);
      } else {
        widget.onTaskAdded(updatedTask);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingTask != null ? "Edit Task" : "Add Task"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter task title...",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter task content...",
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Is this task urgent?"),
              value: isUrgent,
              onChanged: (bool value) {
                setState(() {
                  isUrgent = value;
                });
              },
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _saveTask,
              child: Text(
                widget.existingTask != null ? "Save Changes" : "Add Task",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
