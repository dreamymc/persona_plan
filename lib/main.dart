import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_screen.dart';
import 'screens/goal_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PersonaPlan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(username: ''), // Pass username dynamically
        '/tasks': (context) => TaskScreen(username: ''), // Pass username dynamically
        '/goals': (context) => GoalScreen(username: ''), // Pass username dynamically
        '/about': (context) => AboutScreen(),
      },
    );
  }
}
