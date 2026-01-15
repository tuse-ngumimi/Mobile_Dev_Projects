// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_app/screens/add_task_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open a box to store our tasks
  await Hive.openBox('taskBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const HomeScreen(),
    );
  }
}