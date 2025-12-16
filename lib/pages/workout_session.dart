// [file name]: workout_session.dart
// [file content begin]
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/models/user_profile.dart';

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
  bool _hasIncrementedInProgress = false;

  @override
  void initState() {
    super.initState();
    if (widget.exercises.isNotEmpty) {
      _secondsRemaining = _getExerciseDuration(widget.exercises[_currentExerciseIndex]);
    } else {
      _secondsRemaining = 0;
      _isRunning = false;
      _isExerciseTime = true;
    }
    _loadProgress();
    Future.microtask(_bootstrapAuthAndMarkInProgress);
  }

  Future<void> _bootstrapAuthAndMarkInProgress() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        final cred = await FirebaseAuth.instance.signInAnonymously();
        await FirestoreService.instance.setUserProfile(
          UserProfile(
            uid: cred.user!.uid,
            finishedWorkouts: 0,
            workoutsInProgress: 0,
            timeSpentMinutes: 0.0,
          ),
        );
        user = cred.user;
      } catch (_) {}
    }
    if (user != null) {
      await FirestoreService.instance.incrementUserStats(inProgressDelta: 1);
      _hasIncrementedInProgress = true;
      if (mounted) setState(() {});
    }
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
    final dynamic raw = exercise['duration'];
    if (raw == null) return 30;
    final String duration = raw.toString().trim().toLowerCase();
    // Formats supported:
    // - "30 seconds"
    // - "45 sec" / "45 s"
    // - "1:30" (mm:ss)
    // - "10:00" (mm:ss)
    // - "2 minutes" / "2 min"
    // - plain number treated as seconds
    if (duration.contains('second')) {
      final n = int.tryParse(duration.split(' ').first);
      return n ?? 30;
    }
    if (duration.endsWith(' sec') || duration.endsWith(' s')) {
      final n = int.tryParse(duration.split(' ').first);
      return n ?? 30;
    }
    if (duration.contains('minute')) {
      final n = int.tryParse(duration.split(' ').first);
      return n != null ? n * 60 : 60;
    }
    if (duration.endsWith(' min')) {
      final n = int.tryParse(duration.split(' ').first);
      return n != null ? n * 60 : 60;
    }
    if (RegExp(r'^\d+:\d{2}$').hasMatch(duration)) {
      final parts = duration.split(':');
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    }
    final asInt = int.tryParse(duration);
    return asInt ?? 30;
  }

  void _startTimer() {
    if (!_hasIncrementedInProgress) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirestoreService.instance.incrementUserStats(inProgressDelta: 1);
        _hasIncrementedInProgress = true;
      }
    }
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

    // Persist stats
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirestoreService.instance.incrementUserStats(
        finishedDelta: 1,
        inProgressDelta: _hasIncrementedInProgress ? -1 : 0,
        timeDelta: totalTimeMinutes,
      );
      FirestoreService.instance.logSession(
        workoutType: widget.workoutType,
        exercisesCount: widget.exercises.length,
        timeMinutes: totalTimeMinutes,
        completed: true,
      );
    }

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
    final hasExercises = widget.exercises.isNotEmpty;
    final currentExercise = hasExercises ? widget.exercises[_currentExerciseIndex] : null;

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
                          // Persist partial progress on exit
                          final minutes = _totalTimeSpent / 60.0;
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            if (_hasIncrementedInProgress) {
                              FirestoreService.instance.incrementUserStats(
                                inProgressDelta: -1,
                                timeDelta: minutes,
                              );
                            } else {
                              FirestoreService.instance.incrementUserStats(
                                timeDelta: minutes,
                              );
                            }
                            FirestoreService.instance.logSession(
                              workoutType: widget.workoutType,
                              exercisesCount: widget.exercises.length,
                              timeMinutes: minutes,
                              completed: false,
                            );
                          }
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
            LinearProgressIndicator(
              value: hasExercises ? (_currentExerciseIndex + 1) / widget.exercises.length : 0,
              backgroundColor: Colors.grey[200],
              color: _getWorkoutColor(widget.workoutType),
              minHeight: 8,
            ),
            const SizedBox(height: 10),
            Text(
              hasExercises ? 'Exercise ${_currentExerciseIndex + 1} of ${widget.exercises.length}' : 'No exercises available',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 30),
                    if (hasExercises)
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
                                    currentExercise?['icon'] ?? Icons.fitness_center,
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
                                        currentExercise?['name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${currentExercise?['duration'] ?? ''} • ${currentExercise?['reps'] ?? ''}',
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
                              currentExercise?['description'] ?? '',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (hasExercises && _currentExerciseIndex < widget.exercises.length - 1)
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
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: hasExercises ? (_isRunning ? _pauseTimer : _startTimer) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Start',
                      style: TextStyle(
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
                    onPressed: hasExercises ? _skipExercise : null,
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: hasExercises ? _completeWorkout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getWorkoutColor(widget.workoutType),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Finish Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
