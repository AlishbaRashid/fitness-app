// [file name]: workouts_page.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/models/workout.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  String? _selectedLevel; // null = All

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
            const Text(
              'My Workouts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildLevelChip('Beginner', Colors.green),
                _buildLevelChip('Intermediate', Colors.blue),
                _buildLevelChip('Advanced', Colors.red),
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedLevel == null,
                  onSelected: (_) => setState(() => _selectedLevel = null),
                ),
              ],
            ),
            const SizedBox(height: 15),
            StreamBuilder<List<Workout>>(
              stream: _selectedLevel == null
                  ? FirestoreService.instance.watchWorkouts()
                  : FirestoreService.instance.watchWorkoutsByLevel(_selectedLevel!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'No workouts available yet',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No workouts yet'),
                    ),
                  );
                }
                if (_selectedLevel == null) {
                  final beginner = items.where((w) => (w.level ?? '').toLowerCase() == 'beginner').toList();
                  final intermediate = items.where((w) => (w.level ?? '').toLowerCase() == 'intermediate').toList();
                  final advanced = items.where((w) => (w.level ?? '').toLowerCase() == 'advanced').toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (beginner.isNotEmpty) ...[
                        _levelHeader('Beginner', Colors.green),
                        const SizedBox(height: 8),
                        ...beginner.map((w) => _workoutTile(context, w, Colors.green)),
                        const SizedBox(height: 20),
                      ],
                      if (intermediate.isNotEmpty) ...[
                        _levelHeader('Intermediate', Colors.blue),
                        const SizedBox(height: 8),
                        ...intermediate.map((w) => _workoutTile(context, w, Colors.blue)),
                        const SizedBox(height: 20),
                      ],
                      if (advanced.isNotEmpty) ...[
                        _levelHeader('Advanced', Colors.red),
                        const SizedBox(height: 8),
                        ...advanced.map((w) => _workoutTile(context, w, Colors.red)),
                      ],
                    ],
                  );
                }
                final color = _selectedLevel == 'Beginner'
                    ? Colors.green
                    : _selectedLevel == 'Intermediate'
                        ? Colors.blue
                        : Colors.red;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _levelHeader(_selectedLevel!, color),
                    const SizedBox(height: 8),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _workoutTile(context, items[index], color),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
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
            color: Colors.grey.withValues(alpha: 0.1),
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
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.1),
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
    return const SizedBox.shrink();
  }

  void _showCreateWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleCtrl = TextEditingController();
        final descCtrl = TextEditingController();
        final durationCtrl = TextEditingController();
        String level = 'Beginner';
        return AlertDialog(
          title: const Text('Create Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: level,
                decoration: const InputDecoration(labelText: 'Level'),
                items: const [
                  DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                  DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                  DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                ],
                onChanged: (val) => level = val ?? 'Beginner',
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
                final w = Workout(
                  id: '',
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  durationMinutes: int.tryParse(durationCtrl.text.trim()),
                  level: level,
                );
                Navigator.of(context).pop();
                await FirestoreService.instance.createWorkout(w);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  ChoiceChip _buildLevelChip(String label, Color color) {
    final selected = _selectedLevel == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: color.withValues(alpha: 0.15),
      onSelected: (val) {
        setState(() {
          _selectedLevel = val ? label : null;
        });
      },
    );
  }

  Widget _levelHeader(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label Workouts',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _workoutTile(BuildContext context, Workout w, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/workout_detail',
          arguments: {'workoutId': w.id, 'title': w.title},
        );
      },
      child: _buildSavedWorkoutCard(
        w.title,
        w.description ?? (w.level ?? ''),
        w.durationMinutes != null ? '${w.durationMinutes} min' : '',
        color.withValues(alpha: 0.08),
        color,
        Icons.fitness_center,
      ),
    );
  }
}
// [file content end]
