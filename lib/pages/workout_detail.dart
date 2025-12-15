import 'package:flutter/material.dart';

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String workoutType = args['workoutType'];
    final List<Map<String, dynamic>> exercises = args['exercises'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$workoutType Workout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
            Text(
              '${exercises.length} exercises to complete',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
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
                              color: _getWorkoutColor(
                                workoutType,
                              ).withOpacity(0.2),
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
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  exercise['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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
                  // Start workout functionality
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

  void _startWorkout(
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
                // Navigate to workout session page or start timer
                _showWorkoutStarted(context);
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

  String _calculateTotalTime(List<Map<String, dynamic>> exercises) {
    int totalSeconds = 0;
    for (var exercise in exercises) {
      String duration = exercise['duration'];
      // Extract seconds from duration string (e.g., "30 seconds" -> 30)
      try {
        int seconds = int.tryParse(duration.split(' ')[0]) ?? 0;
        totalSeconds += seconds;
      } catch (e) {
        totalSeconds += 30; // Default to 30 seconds if parsing fails
      }
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
}
