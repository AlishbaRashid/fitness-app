import 'package:flutter/material.dart';
import 'package:term_project/pages/landing.dart';
import 'package:term_project/pages/login.dart';
import 'package:term_project/pages/signup_screen.dart';
import 'package:term_project/pages/home.dart';
import 'package:term_project/pages/workout_detail.dart';
import 'package:term_project/pages/exercise_detail.dart';
import 'package:term_project/pages/search_page.dart';
import 'package:term_project/pages/workout_session.dart';
import 'package:term_project/pages/workouts_page.dart';
import 'package:term_project/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:term_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("🔥 Firebase Connected Successfully");
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
        '/workout_session': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
          final workoutType = args['workoutType'] as String? ?? 'Workout';
          final exercises = (args['exercises'] as List<Map<String, dynamic>>?) ?? <Map<String, dynamic>>[];
          final onWorkoutCompleted = args['onWorkoutCompleted'] as Function(int, double)?;
          return WorkoutSessionPage(
            workoutType: workoutType,
            exercises: exercises,
            onWorkoutCompleted: onWorkoutCompleted,
          );
        },
      },
    );
  }
}
