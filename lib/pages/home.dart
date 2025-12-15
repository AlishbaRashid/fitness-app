import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Let's check your activity",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.blue.shade300, width: 2),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: Colors.blue.shade700,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Stats Cards
              Row(
                children: [
                  // Finished Card
                  Expanded(
                    child: _buildStatCard(
                      "Finished",
                      "0",
                      "Completed\nWorkouts",
                      Colors.blue.shade50,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // In Progress Card
                  Expanded(
                    child: _buildStatCard(
                      "In progress",
                      "0",
                      "Workouts",
                      Colors.orange.shade50,
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Time Spent Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time spent",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "0.0 Minutes",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.green.shade800,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Discover New Workouts
              Text(
                "Discover new workouts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 15),

              // Workout Cards - Fixed height to prevent overflow
              SizedBox(
                height: 180, // Fixed height for the scrollable row
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Cardio Workout Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/workout_detail',
                            arguments: {
                              'workoutType': 'Cardio',
                              'exercises': _getCardioExercises(),
                            },
                          );
                        },
                        child: _buildWorkoutCard(
                          "Cardio",
                          "4 Exercises",
                          "30 Minutes",
                          Colors.orange.shade100,
                          Colors.orange,
                          Icons.directions_run,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Arm Workout Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/workout_detail',
                            arguments: {
                              'workoutType': 'Arm',
                              'exercises': _getArmExercises(),
                            },
                          );
                        },
                        child: _buildWorkoutCard(
                          "Arm",
                          "4 Exercises",
                          "25 Minutes",
                          Colors.blue.shade100,
                          Colors.blue,
                          Icons.fitness_center,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Leg Workout Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/workout_detail',
                            arguments: {
                              'workoutType': 'Leg',
                              'exercises': _getLegExercises(),
                            },
                          );
                        },
                        child: _buildWorkoutCard(
                          "Leg",
                          "4 Exercises",
                          "28 Minutes",
                          Colors.purple.shade100,
                          Colors.purple,
                          Icons.directions_walk,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Core Workout Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/workout_detail',
                            arguments: {
                              'workoutType': 'Core',
                              'exercises': _getCoreExercises(),
                            },
                          );
                        },
                        child: _buildWorkoutCard(
                          "Core",
                          "4 Exercises",
                          "22 Minutes",
                          Colors.green.shade100,
                          Colors.green,
                          Icons.self_improvement,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Full Body Workout Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/workout_detail',
                            arguments: {
                              'workoutType': 'Full Body',
                              'exercises': _getFullBodyExercises(),
                            },
                          );
                        },
                        child: _buildWorkoutCard(
                          "Full Body",
                          "4 Exercises",
                          "35 Minutes",
                          Colors.red.shade100,
                          Colors.red,
                          Icons.accessibility_new,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Top Workouts
              Text(
                "Top Workouts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 15),

              // Workout List - Make clickable
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/exercise_detail',
                        arguments: {'exercise': _getSquatExercise()},
                      );
                    },
                    child: _buildWorkoutItem(
                      "Squats",
                      "2 sets | 10 Repetition",
                      "10:00",
                      Icons.fitness_center,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/exercise_detail',
                        arguments: {'exercise': _getPushUpExercise()},
                      );
                    },
                    child: _buildWorkoutItem(
                      "Push Ups",
                      "3 sets | 15 Repetition",
                      "15:00",
                      Icons.self_improvement,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/exercise_detail',
                        arguments: {'exercise': _getPlankExercise()},
                      );
                    },
                    child: _buildWorkoutItem(
                      "Plank",
                      "3 sets | 30 Seconds",
                      "5:00",
                      Icons.timer,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Update the onTap method in home.dart (bottomNavigationBar)
bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  currentIndex: 0,
  onTap: (index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/home', 
        (route) => false
      );
    } else if (index == 1) {
      Navigator.pushNamed(context, '/search');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/workouts');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    }
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, color: Colors.blue),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search, color: Colors.grey),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center, color: Colors.grey),
      label: 'Workouts',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Colors.grey),
      label: 'Profile',
    ),
  ],
),
    );
  }

  // Exercise data methods
  List<Map<String, dynamic>> _getCardioExercises() {
    return [
      {
        'name': 'Jumping Jacks',
        'duration': '30 seconds',
        'reps': '30 reps',
        'description':
            'A full-body cardiovascular exercise that improves heart health and coordination.',
        'instructions':
            'Stand with feet together and arms at sides. Jump while spreading legs and raising arms overhead. Return to starting position.',
        'benefits':
            'Improves cardiovascular endurance, burns calories, enhances coordination',
        'difficulty': 'Beginner',
        'icon': Icons.directions_run,
        'category': 'Cardio',
      },
      {
        'name': 'High Knees',
        'duration': '45 seconds',
        'reps': '40 reps',
        'description': 'Running in place while bringing knees up to hip level.',
        'instructions':
            'Stand tall and run in place, bringing knees up to waist level. Pump arms for balance.',
        'benefits':
            'Strengthens core, improves running form, boosts heart rate',
        'difficulty': 'Beginner',
        'icon': Icons.directions_run,
        'category': 'Cardio',
      },
      {
        'name': 'Burpees',
        'duration': '60 seconds',
        'reps': '10 reps',
        'description': 'A full-body exercise combining squat, plank, and jump.',
        'instructions':
            'From standing, drop into squat, kick feet back to plank, do pushup, return to squat, and jump up.',
        'benefits':
            'Full-body workout, builds strength and endurance, burns maximum calories',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
        'category': 'Cardio',
      },
      {
        'name': 'Mountain Climbers',
        'duration': '40 seconds',
        'reps': '20 reps per side',
        'description':
            'Dynamic core exercise that also provides cardio benefits.',
        'instructions':
            'Start in plank position. Bring one knee toward chest, then switch legs in running motion.',
        'benefits':
            'Strengthens core, improves cardiovascular fitness, enhances coordination',
        'difficulty': 'Intermediate',
        'icon': Icons.self_improvement,
        'category': 'Cardio',
      },
    ];
  }

  List<Map<String, dynamic>> _getArmExercises() {
    return [
      {
        'name': 'Push Ups',
        'duration': '30 seconds',
        'reps': '15 reps',
        'description':
            'Classic bodyweight exercise for chest, shoulders, and triceps.',
        'instructions':
            'Start in plank position. Lower body until chest nearly touches floor, then push back up.',
        'benefits':
            'Builds upper body strength, improves core stability, no equipment needed',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
        'category': 'Arm',
      },
      {
        'name': 'Tricep Dips',
        'duration': '45 seconds',
        'reps': '12 reps',
        'description':
            'Targets triceps using body weight and a bench or chair.',
        'instructions':
            'Sit on edge of bench, place hands beside hips. Slide off bench and lower body by bending elbows.',
        'benefits':
            'Strengthens triceps, improves arm definition, can be done anywhere',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
        'category': 'Arm',
      },
      {
        'name': 'Bicep Curls',
        'duration': '40 seconds',
        'reps': '10 reps each arm',
        'description': 'Isolation exercise for bicep muscles.',
        'instructions':
            'Hold weights with palms facing forward. Curl weights toward shoulders while keeping elbows stationary.',
        'benefits': 'Builds bicep strength and size, improves arm definition',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
        'category': 'Arm',
      },
      {
        'name': 'Shoulder Press',
        'duration': '35 seconds',
        'reps': '12 reps',
        'description': 'Compound exercise for shoulder development.',
        'instructions':
            'Sit or stand with weights at shoulder height. Press weights overhead until arms are fully extended.',
        'benefits':
            'Builds shoulder strength, improves upper body power, enhances posture',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
        'category': 'Arm',
      },
    ];
  }

  List<Map<String, dynamic>> _getLegExercises() {
    return [
      {
        'name': 'Squats',
        'duration': '30 seconds',
        'reps': '15 reps',
        'description':
            'Fundamental lower body exercise targeting quads, glutes, and hamstrings.',
        'instructions':
            'Stand with feet shoulder-width apart. Lower hips as if sitting in chair, keeping chest up.',
        'benefits':
            'Builds leg strength, improves mobility, enhances athletic performance',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
        'category': 'Leg',
      },
      {
        'name': 'Lunges',
        'duration': '45 seconds',
        'reps': '10 reps each leg',
        'description':
            'Unilateral exercise that improves balance and leg strength.',
        'instructions':
            'Step forward with one leg, lower hips until both knees are bent at 90-degree angle.',
        'benefits':
            'Improves balance, strengthens legs individually, enhances coordination',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
        'category': 'Leg',
      },
      {
        'name': 'Calf Raises',
        'duration': '30 seconds',
        'reps': '20 reps',
        'description': 'Isolation exercise for calf muscles.',
        'instructions':
            'Stand tall and raise heels off ground, balancing on balls of feet. Lower back down.',
        'benefits':
            'Strengthens calves, improves ankle stability, enhances leg definition',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
        'category': 'Leg',
      },
      {
        'name': 'Glute Bridges',
        'duration': '40 seconds',
        'reps': '15 reps',
        'description': 'Targets glute muscles and improves hip mobility.',
        'instructions':
            'Lie on back with knees bent. Lift hips toward ceiling, squeezing glutes at the top.',
        'benefits':
            'Activates glutes, improves hip mobility, helps with lower back pain',
        'difficulty': 'Beginner',
        'icon': Icons.directions_walk,
        'category': 'Leg',
      },
    ];
  }

  List<Map<String, dynamic>> _getCoreExercises() {
    return [
      {
        'name': 'Plank',
        'duration': '30 seconds',
        'reps': '3 sets',
        'description':
            'Isometric core exercise that strengthens entire abdominal region.',
        'instructions':
            'Hold push-up position with body straight from head to heels. Engage core muscles.',
        'benefits': 'Strengthens core, improves posture, reduces back pain',
        'difficulty': 'Beginner',
        'icon': Icons.timer,
        'category': 'Core',
      },
      {
        'name': 'Russian Twists',
        'duration': '45 seconds',
        'reps': '20 reps',
        'description': 'Rotational core exercise targeting obliques.',
        'instructions':
            'Sit with knees bent, lean back slightly. Twist torso from side to side.',
        'benefits':
            'Strengthens obliques, improves rotational strength, enhances balance',
        'difficulty': 'Intermediate',
        'icon': Icons.rotate_right,
        'category': 'Core',
      },
      {
        'name': 'Leg Raises',
        'duration': '40 seconds',
        'reps': '12 reps',
        'description': 'Targets lower abdominal muscles.',
        'instructions':
            'Lie on back, raise legs to 90 degrees, then lower slowly without touching floor.',
        'benefits':
            'Strengthens lower abs, improves core stability, enhances hip flexibility',
        'difficulty': 'Intermediate',
        'icon': Icons.arrow_upward,
        'category': 'Core',
      },
      {
        'name': 'Bicycle Crunches',
        'duration': '50 seconds',
        'reps': '30 reps',
        'description': 'Dynamic core exercise that mimics cycling motion.',
        'instructions':
            'Lie on back, bring opposite elbow to knee while extending other leg.',
        'benefits': 'Works entire core, improves coordination, burns calories',
        'difficulty': 'Beginner',
        'icon': Icons.pedal_bike,
        'category': 'Core',
      },
    ];
  }

  List<Map<String, dynamic>> _getFullBodyExercises() {
    return [
      {
        'name': 'Burpees',
        'duration': '60 seconds',
        'reps': '8 reps',
        'description':
            'Full-body explosive movement combining multiple exercises.',
        'instructions':
            'Squat, kick back to plank, do pushup, return to squat, and jump up.',
        'benefits':
            'Full-body workout, maximum calorie burn, improves endurance',
        'difficulty': 'Advanced',
        'icon': Icons.fitness_center,
        'category': 'Full Body',
      },
      {
        'name': 'Kettlebell Swings',
        'duration': '45 seconds',
        'reps': '15 reps',
        'description':
            'Dynamic hip-hinging movement that works entire posterior chain.',
        'instructions':
            'Swing kettlebell from between legs to chest height using hip power.',
        'benefits':
            'Builds explosive power, strengthens glutes and hamstrings, improves cardio',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
        'category': 'Full Body',
      },
      {
        'name': 'Renegade Rows',
        'duration': '50 seconds',
        'reps': '10 reps per side',
        'description': 'Combines plank stability with upper body pulling.',
        'instructions':
            'In plank position with hands on weights, row one weight to side while balancing.',
        'benefits':
            'Works core and back simultaneously, improves stability, builds arm strength',
        'difficulty': 'Advanced',
        'icon': Icons.fitness_center,
        'category': 'Full Body',
      },
      {
        'name': 'Thrusters',
        'duration': '40 seconds',
        'reps': '12 reps',
        'description':
            'Combines front squat with overhead press in one fluid movement.',
        'instructions':
            'Perform front squat, then use momentum to press weights overhead as you stand.',
        'benefits':
            'Full-body coordination, builds leg and shoulder strength, metabolic conditioning',
        'difficulty': 'Intermediate',
        'icon': Icons.fitness_center,
        'category': 'Full Body',
      },
    ];
  }

  Map<String, dynamic> _getSquatExercise() {
    return {
      'name': 'Squats',
      'duration': '10:00',
      'sets': '2 sets',
      'reps': '10 Repetition',
      'description':
          'Fundamental lower body exercise that targets quads, glutes, hamstrings, and core.',
      'instructions':
          '1. Stand with feet shoulder-width apart\n2. Keep chest up and back straight\n3. Lower hips as if sitting in a chair\n4. Go until thighs are parallel to ground\n5. Push through heels to return to start',
      'benefits':
          '• Builds leg strength\n• Improves mobility\n• Enhances athletic performance\n• Burns calories\n• Strengthens core',
      'difficulty': 'Beginner',
      'musclesTargeted': 'Quadriceps, Glutes, Hamstrings, Core',
      'equipment': 'None required',
      'category': 'Leg',
    };
  }

  Map<String, dynamic> _getPushUpExercise() {
    return {
      'name': 'Push Ups',
      'duration': '15:00',
      'sets': '3 sets',
      'reps': '15 Repetition',
      'description':
          'Classic upper body exercise targeting chest, shoulders, triceps, and core.',
      'instructions':
          '1. Start in plank position with hands under shoulders\n2. Keep body straight from head to heels\n3. Lower chest to floor by bending elbows\n4. Push back up to starting position\n5. Keep core engaged throughout movement',
      'benefits':
          '• Builds upper body strength\n• Improves core stability\n• No equipment needed\n• Enhances pushing power\n• Improves bone density',
      'difficulty': 'Beginner',
      'musclesTargeted': 'Chest, Shoulders, Triceps, Core',
      'equipment': 'None required',
      'category': 'Arm',
    };
  }

  Map<String, dynamic> _getPlankExercise() {
    return {
      'name': 'Plank',
      'duration': '5:00',
      'sets': '3 sets',
      'reps': '30 Seconds hold',
      'description':
          'Isometric core exercise that strengthens the entire abdominal region and improves posture.',
      'instructions':
          '1. Place forearms on ground with elbows under shoulders\n2. Extend legs back and rise onto toes\n3. Keep body straight from head to heels\n4. Engage core and glutes\n5. Hold position without sagging hips',
      'benefits':
          '• Strengthens entire core\n• Improves posture\n• Reduces back pain\n• Enhances stability\n• No equipment needed',
      'difficulty': 'Beginner',
      'musclesTargeted': 'Abs, Obliques, Lower Back, Shoulders',
      'equipment': 'None required',
      'category': 'Core',
    };
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String exercises,
    String time,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      width: 160, // Slightly narrower to fit better
      height: 160, // Fixed height
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exercises,
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(icon, size: 40, color: textColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: color),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
