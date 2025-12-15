import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allExercises = [];
  List<Map<String, dynamic>> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _loadAllExercises();
    _filteredExercises = _allExercises;
  }

  void _loadAllExercises() {
    // Combine all exercises from different workout categories
    _allExercises = [
      // Cardio Exercises
      {
        'name': 'Jumping Jacks',
        'category': 'Cardio',
        'duration': '30 seconds',
        'reps': '30 reps',
        'description':
            'A full-body cardiovascular exercise that improves heart health and coordination.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_run,
      },
      {
        'name': 'High Knees',
        'category': 'Cardio',
        'duration': '45 seconds',
        'reps': '40 reps',
        'description': 'Running in place while bringing knees up to hip level.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_run,
      },
      {
        'name': 'Burpees',
        'category': 'Cardio',
        'duration': '60 seconds',
        'reps': '10 reps',
        'description': 'A full-body exercise combining squat, plank, and jump.',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Mountain Climbers',
        'category': 'Cardio',
        'duration': '40 seconds',
        'reps': '20 reps per side',
        'description':
            'Dynamic core exercise that also provides cardio benefits.',
        'difficulty': 'Intermediate',
        'icon': Icons.self_improvement,
      },

      // Arm Exercises
      {
        'name': 'Push Ups',
        'category': 'Arm',
        'duration': '30 seconds',
        'reps': '15 reps',
        'description':
            'Classic bodyweight exercise for chest, shoulders, and triceps.',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Tricep Dips',
        'category': 'Arm',
        'duration': '45 seconds',
        'reps': '12 reps',
        'description':
            'Targets triceps using body weight and a bench or chair.',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Bicep Curls',
        'category': 'Arm',
        'duration': '40 seconds',
        'reps': '10 reps each arm',
        'description': 'Isolation exercise for bicep muscles.',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Shoulder Press',
        'category': 'Arm',
        'duration': '35 seconds',
        'reps': '12 reps',
        'description': 'Compound exercise for shoulder development.',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
      },

      // Leg Exercises
      {
        'name': 'Squats',
        'category': 'Leg',
        'duration': '30 seconds',
        'reps': '15 reps',
        'description':
            'Fundamental lower body exercise targeting quads, glutes, and hamstrings.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
      },
      {
        'name': 'Lunges',
        'category': 'Leg',
        'duration': '45 seconds',
        'reps': '10 reps each leg',
        'description':
            'Unilateral exercise that improves balance and leg strength.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
      },
      {
        'name': 'Calf Raises',
        'category': 'Leg',
        'duration': '30 seconds',
        'reps': '20 reps',
        'description': 'Isolation exercise for calf muscles.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
      },
      {
        'name': 'Glute Bridges',
        'category': 'Leg',
        'duration': '40 seconds',
        'reps': '15 reps',
        'description': 'Targets glute muscles and improves hip mobility.',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
      },

      // Core Exercises
      {
        'name': 'Plank',
        'category': 'Core',
        'duration': '30 seconds',
        'reps': '3 sets',
        'description':
            'Isometric core exercise that strengthens entire abdominal region.',
        'difficulty': 'Beginner',
        'icon': Icons.timer,
      },
      {
        'name': 'Russian Twists',
        'category': 'Core',
        'duration': '45 seconds',
        'reps': '20 reps',
        'description': 'Rotational core exercise targeting obliques.',
        'difficulty': 'Intermediate',
        'icon': Icons.rotate_right,
      },
      {
        'name': 'Leg Raises',
        'category': 'Core',
        'duration': '40 seconds',
        'reps': '12 reps',
        'description': 'Targets lower abdominal muscles.',
        'difficulty': 'Intermediate',
        'icon': Icons.arrow_upward,
      },
      {
        'name': 'Bicycle Crunches',
        'category': 'Core',
        'duration': '50 seconds',
        'reps': '30 reps',
        'description': 'Dynamic core exercise that mimics cycling motion.',
        'difficulty': 'Beginner',
        'icon': Icons.pedal_bike,
      },

      // Full Body Exercises
      {
        'name': 'Burpees',
        'category': 'Full Body',
        'duration': '60 seconds',
        'reps': '8 reps',
        'description':
            'Full-body explosive movement combining multiple exercises.',
        'difficulty': 'Advanced',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Kettlebell Swings',
        'category': 'Full Body',
        'duration': '45 seconds',
        'reps': '15 reps',
        'description':
            'Dynamic hip-hinging movement that works entire posterior chain.',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Renegade Rows',
        'category': 'Full Body',
        'duration': '50 seconds',
        'reps': '10 reps per side',
        'description': 'Combines plank stability with upper body pulling.',
        'difficulty': 'Advanced',
        'icon': Icons.fitness_center,
      },
      {
        'name': 'Thrusters',
        'category': 'Full Body',
        'duration': '40 seconds',
        'reps': '12 reps',
        'description':
            'Combines front squat with overhead press in one fluid movement.',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
      },
    ];
  }

  void _filterExercises(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredExercises = _allExercises;
      });
    } else {
      setState(() {
        _filteredExercises = _allExercises.where((exercise) {
          final name = exercise['name'].toString().toLowerCase();
          final category = exercise['category'].toString().toLowerCase();
          final description = exercise['description'].toString().toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              category.contains(searchLower) ||
              description.contains(searchLower);
        }).toList();
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search Exercises'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterExercises,
              decoration: InputDecoration(
                hintText: 'Search exercises, categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          // Search Results
          Expanded(
            child: _filteredExercises.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No exercises found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          'Try different keywords',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/exercise_detail',
                            arguments: {'exercise': exercise},
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    exercise['category'],
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  exercise['icon'],
                                  color: _getCategoryColor(
                                    exercise['category'],
                                  ),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${exercise['category']} • ${exercise['duration']} • ${exercise['reps']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    exercise['category'],
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  exercise['difficulty'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getCategoryColor(
                                      exercise['category'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
