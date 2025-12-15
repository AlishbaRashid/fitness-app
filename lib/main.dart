import 'package:flutter/material.dart';
import 'package:term_project/pages/landing.dart';
import 'package:term_project/pages/login.dart';
import 'package:term_project/pages/signup_screen.dart';
import 'package:term_project/pages/home.dart';
import 'package:term_project/pages/workout_detail.dart';
import 'package:term_project/pages/exercise_detail.dart';
import 'package:term_project/pages/search_page.dart';
import 'package:term_project/pages/workouts_page.dart';
import 'package:term_project/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const Home(),
        '/workout_detail': (context) => const WorkoutDetailPage(),
        '/exercise_detail': (context) => const ExerciseDetailPage(),
        '/search': (context) => const SearchPage(),
        '/workouts': (context) => const WorkoutsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
