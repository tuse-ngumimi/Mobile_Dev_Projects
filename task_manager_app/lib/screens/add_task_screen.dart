// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get our box where tasks are stored
    final box = Hive.box('taskBox');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        // Listen to changes in the box
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          // Count total and completed tasks
          int totalTasks = box.length;
          int completedTasks = 0;

          for (int i = 0; i < box.length; i++) {
            var taskMap = box.getAt(i);
            if (taskMap['isCompleted'] == true) {
              completedTasks++;
            }
          }

          return Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF6C63FF),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedTasks of $totalTasks completed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        if (totalTasks > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${((completedTasks / totalTasks) * 100).toInt()}%',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Task list
              Expanded(
                child: box.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tasks yet!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add a new task',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    // Get task data from box
                    var taskMap = box.getAt(index);
                    Task task = Task.fromMap(taskMap);

                    return _buildTaskCard(context, task, index, box);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to add task screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build each task card
  Widget _buildTaskCard(BuildContext context, Task task, int index, Box box) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            // Toggle completion status
            task.isCompleted = !task.isCompleted;
            box.putAt(index, task.toMap());
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  task.createdAt,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF6C63FF)),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
              onTap: () {
                // Wait a moment then navigate to edit
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                        task: task,
                        index: index,
                      ),
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
              onTap: () {
                // Delete the task
                box.deleteAt(index);
              },
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}