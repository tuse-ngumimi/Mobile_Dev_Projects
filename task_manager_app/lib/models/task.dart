// models/task.dart

// Simple Task class - just like creating any normal class in Dart
class Task {
  String title;
  String description;
  bool isCompleted;
  String createdAt;

  // Constructor - this is how we create a new task
  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convert task to Map (so we can save it in Hive)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }

  // Create task from Map (when we read from Hive)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'] ?? '',
    );
  }
}