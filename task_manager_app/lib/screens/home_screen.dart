// screens/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // If editing, this will have the task
  final int? index; // Position in the box

  const AddTaskScreen({super.key, this.task, this.index});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Text controllers for input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If editing, fill in the existing data
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTask() {
    // Check if fields are not empty
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Get our box
    final box = Hive.box('taskBox');

    if (widget.task != null && widget.index != null) {
      // Editing existing task
      Task updatedTask = Task(
        title: titleController.text,
        description: descriptionController.text,
        isCompleted: widget.task!.isCompleted,
        createdAt: widget.task!.createdAt,
      );
      box.putAt(widget.index!, updatedTask.toMap());
    } else {
      // Creating new task
      Task newTask = Task(
        title: titleController.text,
        description: descriptionController.text,
        createdAt: _getFormattedDate(),
      );
      box.add(newTask.toMap());
    }

    // Go back to home screen
    Navigator.pop(context);
  }

  // Get current date in readable format
  String _getFormattedDate() {
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title label
            const Text(
              'Task Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Title input field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description label
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Description input field
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter task description',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.task != null ? 'Update Task' : 'Add Task',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}