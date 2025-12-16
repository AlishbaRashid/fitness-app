import 'package:flutter/material.dart';
import 'package:term_project/pages/workout_session.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/models/exercise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term_project/models/user_profile.dart';

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? workoutId = args['workoutId'] as String?;
    final String workoutType = args['workoutType'] ?? args['title'];
    final List<Map<String, dynamic>> exercises = args['exercises'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$workoutType Workout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButton: workoutId == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                _showAddExerciseDialog(context, workoutId);
              },
              backgroundColor: _getWorkoutColor(workoutType),
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$workoutType Exercises',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            workoutId == null
                ? Text(
                    '${exercises.length} exercises to complete',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  )
                : StreamBuilder<List<Exercise>>(
                    stream: FirestoreService.instance.watchExercises(workoutId),
                    builder: (context, snapshot) {
                      final count = (snapshot.data ?? []).length;
                      return Text(
                        '$count exercises to complete',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Expanded(
              child: workoutId == null
                  ? ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return _exerciseTile(context, workoutType, exercise);
                      },
                    )
                  : StreamBuilder<List<Exercise>>(
                      stream: FirestoreService.instance.watchExercises(
                        workoutId,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Failed to load exercises'),
                          );
                        }
                        final items = snapshot.data ?? [];
                        if (items.isEmpty) {
                          return const Center(child: Text('No exercises yet'));
                        }
                        return ListView(
                          children: items
                              .map(
                                (e) => _exerciseTile(context, workoutType, {
                                  'name': e.name,
                                  'duration': e.sets != null
                                      ? '${e.sets} sets'
                                      : '',
                                  'reps': e.reps != null
                                      ? '${e.reps} reps'
                                      : '',
                                  'description': e.notes ?? '',
                                }),
                              )
                              .toList(),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  _startWorkout(context, workoutType, exercises);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getWorkoutColor(workoutType),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Start Workout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getWorkoutColor(String workoutType) {
    switch (workoutType) {
      case 'Cardio':
        return Colors.orange;
      case 'Arm':
        return Colors.blue;
      case 'Leg':
        return Colors.purple;
      case 'Core':
        return Colors.green;
      case 'Full Body':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Update in workout_detail.dart, replace the _startWorkout method:

  void _startWorkout(
    BuildContext context,
    String workoutType,
    List<Map<String, dynamic>> exercises,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      FirebaseAuth.instance.signInAnonymously().then((cred) async {
        await FirestoreService.instance.setUserProfile(
          UserProfile(
            uid: cred.user!.uid,
            finishedWorkouts: 0,
            workoutsInProgress: 0,
            timeSpentMinutes: 0.0,
          ),
        );
        Navigator.of(context).pop();
        _showStartDialog(context, workoutType, exercises);
      }).catchError((e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to prepare tracking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    _showStartDialog(context, workoutType, exercises);
  }

  void _showStartDialog(
    BuildContext context,
    String workoutType,
    List<Map<String, dynamic>> exercises,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Start $workoutType Workout?"),
          content: Text(
            "This workout contains ${exercises.length} exercises and will take approximately ${_calculateTotalTime(exercises)} minutes to complete.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to workout session page
                // In workout_detail.dart, update the navigation to WorkoutSessionPage:

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutSessionPage(
                      workoutType: workoutType,
                      exercises: exercises,
                      onWorkoutCompleted: (workoutsCompleted, timeSpent) {
                        // This would ideally update the home screen
                        // For now, we'll just show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $workoutsCompleted workout, spent ${timeSpent.toStringAsFixed(1)} minutes',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _getWorkoutColor(workoutType),
              ),
              child: const Text(
                "Start Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _exerciseTile(
    BuildContext context,
    String workoutType,
    Map<String, dynamic> exercise,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/exercise_detail',
          arguments: {'exercise': exercise},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getWorkoutColor(workoutType).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                exercise['icon'] ?? Icons.fitness_center,
                color: _getWorkoutColor(workoutType),
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${exercise['duration']} • ${exercise['reps']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    exercise['description'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  String _calculateTotalTime(List<Map<String, dynamic>> exercises) {
    int totalSeconds = 0;
    for (var exercise in exercises) {
      final dynamic raw = exercise['duration'];
      if (raw == null) {
        totalSeconds += 30;
        continue;
      }
      final String duration = raw.toString().trim().toLowerCase();
      if (duration.contains('second')) {
        final n = int.tryParse(duration.split(' ').first) ?? 30;
        totalSeconds += n;
        continue;
      }
      if (duration.endsWith(' sec') || duration.endsWith(' s')) {
        final n = int.tryParse(duration.split(' ').first) ?? 30;
        totalSeconds += n;
        continue;
      }
      if (duration.contains('minute')) {
        final n = int.tryParse(duration.split(' ').first) ?? 1;
        totalSeconds += n * 60;
        continue;
      }
      if (duration.endsWith(' min')) {
        final n = int.tryParse(duration.split(' ').first) ?? 1;
        totalSeconds += n * 60;
        continue;
      }
      if (RegExp(r'^\d+:\d{2}$').hasMatch(duration)) {
        final parts = duration.split(':');
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        totalSeconds += minutes * 60 + seconds;
        continue;
      }
      final asInt = int.tryParse(duration);
      totalSeconds += asInt ?? 30;
    }
    int totalMinutes = (totalSeconds / 60).ceil();
    return totalMinutes.toString();
  }

  void _showWorkoutStarted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Workout started! Good luck!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, String workoutId) {
    final nameCtrl = TextEditingController();
    final setsCtrl = TextEditingController();
    final repsCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: setsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sets'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: repsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ex = Exercise(
                  id: '',
                  name: nameCtrl.text.trim(),
                  sets: int.tryParse(setsCtrl.text.trim()),
                  reps: int.tryParse(repsCtrl.text.trim()),
                  notes: notesCtrl.text.trim().isEmpty
                      ? null
                      : notesCtrl.text.trim(),
                );
                Navigator.of(context).pop();
                await FirestoreService.instance.createExercise(workoutId, ex);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
