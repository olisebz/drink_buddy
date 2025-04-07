import 'package:flutter/material.dart';
import 'package:drink_buddy/screens/goal_input_screen.dart';

void main() {
  runApp(const DrinkBuddyApp());
}

class DrinkBuddyApp extends StatelessWidget {
  const DrinkBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkBuddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.lightBlue,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const GoalInputScreen(),
    );
  }
}
