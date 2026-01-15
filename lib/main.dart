import 'package:flutter/material.dart';
import 'login.dart';
import 'colours.dart';

void main() {
  runApp(const MyApp());
}

//stateless widgets don't change overtime
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clover App',
      theme: ThemeData(
        primaryColor: AppColors.blushPink,
        scaffoldBackgroundColor: AppColors.cream,//default background colour
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




