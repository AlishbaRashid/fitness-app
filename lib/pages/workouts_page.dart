// [file name]: workouts_page.dart
// [file content begin]
import 'package:flutter/material.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Workouts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Workouts
            const Text(
              'Saved Workouts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildSavedWorkoutCard(
              'Morning Routine',
              'Cardio + Core',
              '30 min',
              Colors.orange.shade50,
              Colors.orange,
              Icons.sunny,
            ),
            const SizedBox(height: 10),
            _buildSavedWorkoutCard(
              'Evening Stretch',
              'Full Body Stretch',
              '25 min',
              Colors.purple.shade50,
              Colors.purple,
              Icons.nightlight,
            ),
            const SizedBox(height: 10),
            _buildSavedWorkoutCard(
              'Weekend Challenge',
              'HIIT Workout',
              '45 min',
              Colors.red.shade50,
              Colors.red,
              Icons.bolt,
            ),

            const SizedBox(height: 30),

            // Workout Categories
            const Text(
              'Workout Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildCategoryCard(
                  'Beginner',
                  '12 workouts',
                  Colors.green.shade50,
                  Colors.green,
                  Icons.flag,
                ),
                _buildCategoryCard(
                  'Intermediate',
                  '18 workouts',
                  Colors.blue.shade50,
                  Colors.blue,
                  Icons.trending_up,
                ),
                _buildCategoryCard(
                  'Advanced',
                  '8 workouts',
                  Colors.red.shade50,
                  Colors.red,
                  Icons.fitness_center,
                ),
                _buildCategoryCard(
                  'Quick Workouts',
                  '10-15 min',
                  Colors.orange.shade50,
                  Colors.orange,
                  Icons.timer,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Create New Workout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCreateWorkoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.blue),
                label: Text(
                  'Create Custom Workout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedWorkoutCard(
    String title,
    String subtitle,
    String duration,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: textColor, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
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
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              duration,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 40, color: textColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Custom Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This feature will allow you to:'),
              const SizedBox(height: 10),
              _buildFeatureItem('Select exercises from all categories'),
              _buildFeatureItem('Set custom durations and repetitions'),
              _buildFeatureItem('Save and schedule your workouts'),
              _buildFeatureItem('Track your progress over time'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
// [file content end]