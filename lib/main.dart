import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'ui/colours.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clover App',
      theme: ThemeData(
        primaryColor: AppColors.blushPink,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blushPink,
          primary: AppColors.blushPink,
          secondary: AppColors.lavenderPurple,
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




