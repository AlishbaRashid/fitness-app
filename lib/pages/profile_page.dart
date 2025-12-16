// [file name]: profile_page.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/models/user_profile.dart';
import 'package:term_project/models/workout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Header
            StreamBuilder<UserProfile?>(
              stream: FirestoreService.instance.watchCurrentUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100,
                            border: Border.all(color: Colors.blue.shade300, width: 2),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: SizedBox(
                            height: 20,
                            child: LinearProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final profile = snapshot.data;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                          border: Border.all(color: Colors.blue.shade300, width: 2),
                          image: profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(profile.avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: profile?.avatarUrl == null || profile!.avatarUrl!.isEmpty
                            ? Icon(
                                Icons.person,
                                color: Colors.blue.shade700,
                                size: 40,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.name ?? (FirebaseAuth.instance.currentUser?.email ?? 'User'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              profile?.email ?? (FirebaseAuth.instance.currentUser?.email ?? ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Member',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue.shade700),
                        onPressed: () {
                          _showEditProfileDialog(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              'Your Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            StreamBuilder<UserProfile?>(
              stream: FirestoreService.instance.watchCurrentUserProfile(),
              builder: (context, snapshot) {
                final p = snapshot.data;
                final finished = p?.finishedWorkouts ?? 0;
                final inProgress = p?.workoutsInProgress ?? 0;
                final minutes = p?.timeSpentMinutes ?? 0.0;
                final hours = (minutes / 60).floor();
                final remMins = minutes.round() % 60;
                final timeStr = minutes == 0.0
                    ? '0m'
                    : '${hours > 0 ? '${hours}h ' : ''}${remMins}m';
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildStatCard(
                      'Finished',
                      '$finished',
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'In Progress',
                      '$inProgress',
                      Icons.play_circle_fill,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Time Spent',
                      timeStr,
                      Icons.timer,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Workouts Saved',
                      '—',
                      Icons.bookmark,
                      Colors.purple,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // Achievements
            const Text(
              'Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAchievementCard(
                    'First Workout',
                    'Completed your first exercise',
                    Icons.emoji_events,
                    Colors.amber,
                    true,
                  ),
                  const SizedBox(width: 15),
                  _buildAchievementCard(
                    '5 Day Streak',
                    'Worked out for 5 consecutive days',
                    Icons.star,
                    Colors.blue,
                    true,
                  ),
                  const SizedBox(width: 15),
                  _buildAchievementCard(
                    'Cardio Master',
                    'Complete 10 cardio workouts',
                    Icons.directions_run,
                    Colors.red,
                    false,
                  ),
                  const SizedBox(width: 15),
                  _buildAchievementCard(
                    'Consistency',
                    '30 workouts completed',
                    Icons.trending_up,
                    Colors.green,
                    false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Settings Options
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Column(
              children: [
                _buildSettingOption(
                  'Workout Reminders',
                  Icons.notifications,
                  Colors.blue,
                  () {
                    _showReminderSettings(context);
                  },
                ),
                _buildSettingOption(
                  'Goal Settings',
                  Icons.flag,
                  Colors.green,
                  () {
                    _showGoalSettings(context);
                  },
                ),
                _buildSettingOption(
                  'Health Data',
                  Icons.monitor_heart,
                  Colors.red,
                  () {
                    _showHealthData(context);
                  },
                ),
                _buildSettingOption(
                  'Share Progress',
                  Icons.share,
                  Colors.purple,
                  () {
                    _shareProgress(context);
                  },
                ),
                _buildSettingOption(
                  'Help & Support',
                  Icons.help,
                  Colors.orange,
                  () {
                    _showHelp(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool unlocked,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: unlocked ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: unlocked ? color : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: unlocked ? color : Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: unlocked ? color : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: unlocked ? color.withValues(alpha: 0.8) : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final existing = await FirestoreService.instance.getCurrentUserProfile();
    if (!context.mounted) return;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? (FirebaseAuth.instance.currentUser?.email ?? ''));
    final avatarCtrl = TextEditingController(text: existing?.avatarUrl ?? '');
    final heightCtrl = TextEditingController(text: existing?.heightCm?.toString() ?? '');
    final weightCtrl = TextEditingController(text: existing?.weightKg?.toString() ?? '');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: avatarCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Profile Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) {
                  final nav = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  nav.pop();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Not authenticated'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final nav = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  final height = double.tryParse(heightCtrl.text.trim());
                  final weight = double.tryParse(weightCtrl.text.trim());
                  await FirestoreService.instance.setUserProfile(
                    UserProfile(
                      uid: uid,
                      name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
                      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                      avatarUrl: avatarCtrl.text.trim().isEmpty ? null : avatarCtrl.text.trim(),
                      heightCm: height,
                      weightKg: weight,
                    ),
                  );
                  nav.pop();
                  nav.pop();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  nav.pop();
                  nav.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to update profile: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showReminderSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Reminders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Enable Daily Reminders'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                title: const Text('Reminder Time'),
                subtitle: const Text('8:00 AM'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showGoalSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Your Goals'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Workouts per Week',
                  suffixText: 'workouts',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Daily Workout Time',
                  suffixText: 'minutes',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goals updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save Goals'),
            ),
          ],
        );
      },
    );
  }

  void _showHealthData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Health Data'),
          content: const Text(
            'Connect to Apple Health or Google Fit to track your workouts, heart rate, and calories burned.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to health app...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  void _shareProgress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Progress'),
          content: const Text('Share your workout progress on social media or with friends.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress shared successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem('FAQs', Icons.help_outline),
              _buildHelpItem('Contact Support', Icons.email),
              _buildHelpItem('User Guide', Icons.book),
              _buildHelpItem('Report a Problem', Icons.bug_report),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String text, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: () {},
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landing',
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
// [file content end]
