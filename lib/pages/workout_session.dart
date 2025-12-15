// [file name]: workout_session.dart
// [file content begin]
import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String workoutType;
  final List<Map<String, dynamic>> exercises;
  final Function(int, double)? onWorkoutCompleted;

  const WorkoutSessionPage({
    super.key,
    required this.workoutType,
    required this.exercises,
    this.onWorkoutCompleted,
  });

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  int _currentExerciseIndex = 0;
  bool _isExerciseTime = true;
  int _secondsRemaining = 60; // Default 60 seconds for exercise
  bool _isRunning = false;
  Timer? _timer;
  int _totalWorkoutsCompleted = 0;
  int _totalTimeSpent = 0; // in seconds

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _getExerciseDuration(
      widget.exercises[_currentExerciseIndex],
    );
    _loadProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadProgress() {
    // Load saved progress (in a real app, this would be from shared preferences or database)
    // For now, we'll use placeholder values
  }

  int _getExerciseDuration(Map<String, dynamic> exercise) {
    String duration = exercise['duration'];
    try {
      // Extract seconds from duration string (e.g., "30 seconds" -> 30)
      return int.tryParse(duration.split(' ')[0]) ?? 30;
    } catch (e) {
      return 30; // Default to 30 seconds if parsing fails
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          if (_isExerciseTime) {
            _totalTimeSpent++;
          }
        } else {
          if (_isExerciseTime) {
            // Exercise time finished, start break
            _isExerciseTime = false;
            _secondsRemaining = 20; // 20 second break
          } else {
            // Break finished, move to next exercise
            _moveToNextExercise();
          }
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _moveToNextExercise() {
    if (_currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _isExerciseTime = true;
        _secondsRemaining = _getExerciseDuration(
          widget.exercises[_currentExerciseIndex],
        );
      });
    } else {
      // Workout completed
      _completeWorkout();
    }
  }

  void _skipExercise() {
    if (_currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _isExerciseTime = true;
        _secondsRemaining = _getExerciseDuration(
          widget.exercises[_currentExerciseIndex],
        );
        if (_isRunning) {
          _timer?.cancel();
          _startTimer();
        }
      });
    } else {
      _completeWorkout();
    }
  }

  void _completeWorkout() {
    _timer?.cancel();

    // Calculate total workout time in minutes
    double totalTimeMinutes = _totalTimeSpent / 60.0;

    // Call the callback if provided
    if (widget.onWorkoutCompleted != null) {
      widget.onWorkoutCompleted!(1, totalTimeMinutes);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 60, color: Colors.green),
              const SizedBox(height: 20),
              Text(
                'You completed ${widget.exercises.length} exercises!',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Total time: ${(_totalTimeSpent / 60).toStringAsFixed(1)} minutes',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Update home screen stats
                _updateHomeScreenStats();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _updateHomeScreenStats() {
    // In a real app, you would save this to shared preferences or database
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Workout progress saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[_currentExerciseIndex];

    return Scaffold(
      backgroundColor: _isExerciseTime ? Colors.white : Colors.blue.shade50,
      appBar: AppBar(
        title: Text('${widget.workoutType} Workout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exit Workout?'),
                    content: const Text(
                      'Are you sure you want to exit? Your progress will be saved.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          _updateHomeScreenStats();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Exit'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentExerciseIndex + 1) / widget.exercises.length,
              backgroundColor: Colors.grey[200],
              color: _getWorkoutColor(widget.workoutType),
              minHeight: 8,
            ),
            const SizedBox(height: 10),
            Text(
              'Exercise ${_currentExerciseIndex + 1} of ${widget.exercises.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 40),

            // Timer Circle
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isExerciseTime
                    ? _getWorkoutColor(widget.workoutType).withValues(alpha: 0.1)
                    : Colors.blue.withValues(alpha: 0.1),
                border: Border.all(
                  color: _isExerciseTime
                      ? _getWorkoutColor(widget.workoutType)
                      : Colors.blue,
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExerciseTime ? 'EXERCISE' : 'BREAK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isExerciseTime
                          ? _getWorkoutColor(widget.workoutType)
                          : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_secondsRemaining',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'seconds',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Current Exercise Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getWorkoutColor(
                            widget.workoutType,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          currentExercise['icon'] ?? Icons.fitness_center,
                          color: _getWorkoutColor(widget.workoutType),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentExercise['name'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${currentExercise['duration']} • ${currentExercise['reps']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentExercise['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? Colors.orange
                          : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isRunning ? 'Pause' : 'Start',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _skipExercise,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _getWorkoutColor(widget.workoutType),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(
                      Icons.skip_next,
                      color: _getWorkoutColor(widget.workoutType),
                    ),
                    label: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _getWorkoutColor(widget.workoutType),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Next Exercise Preview
            if (_currentExerciseIndex < widget.exercises.length - 1)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upcoming, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      'Next: ${widget.exercises[_currentExerciseIndex + 1]['name']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
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
}
// [file content end]
