import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/feedback_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Intern Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: const FeedbackScreen (),
=======
      home: const LoginScreen(),
>>>>>>> 8a5c5fb69ee51272677bae86613cd752a31a06b1
    );
  }
}