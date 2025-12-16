import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term_project/models/user_profile.dart';
import 'package:term_project/models/workout.dart';
import 'package:term_project/models/exercise.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? get _uid => _auth.currentUser?.uid;
  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');
  CollectionReference<Map<String, dynamic>> _userWorkouts(String uid) =>
      _users.doc(uid).collection('workouts');
  CollectionReference<Map<String, dynamic>> _workoutExercises(
          String uid, String workoutId) =>
      _userWorkouts(uid).doc(workoutId).collection('exercises');
  CollectionReference<Map<String, dynamic>> _userSessions(String uid) =>
      _users.doc(uid).collection('sessions');
  Future<void> setUserProfile(UserProfile profile) async {
    try {
      final data = <String, dynamic>{'uid': profile.uid};
      if (profile.name != null) data['name'] = profile.name;
      if (profile.email != null) data['email'] = profile.email;
      if (profile.avatarUrl != null) data['avatarUrl'] = profile.avatarUrl;
      if (profile.heightCm != null) data['heightCm'] = profile.heightCm;
      if (profile.weightKg != null) data['weightKg'] = profile.weightKg;
      if (profile.finishedWorkouts != null) {
        data['finishedWorkouts'] = profile.finishedWorkouts;
      }
      if (profile.workoutsInProgress != null) {
        data['workoutsInProgress'] = profile.workoutsInProgress;
      }
      if (profile.timeSpentMinutes != null) {
        data['timeSpentMinutes'] = profile.timeSpentMinutes;
      }
      await _users.doc(profile.uid).set(data, SetOptions(merge: true));
    } catch (_) {
      rethrow;
    }
  }
  Future<void> logSession({
    required String workoutType,
    required int exercisesCount,
    required double timeMinutes,
    required bool completed,
  }) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      await _userSessions(_uid!).add({
        'workoutType': workoutType,
        'exercisesCount': exercisesCount,
        'timeMinutes': timeMinutes,
        'completed': completed,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (_) {
      rethrow;
    }
  }
  Future<void> incrementUserStats({
    int finishedDelta = 0,
    int inProgressDelta = 0,
    double timeDelta = 0.0,
  }) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      await _users.doc(_uid!).set({
        'uid': _uid,
        'finishedWorkouts': FieldValue.increment(finishedDelta),
        'workoutsInProgress': FieldValue.increment(inProgressDelta),
        'timeSpentMinutes': FieldValue.increment(timeDelta),
      }, SetOptions(merge: true));
    } catch (_) {
      rethrow;
    }
  }
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      if (_uid == null) return null;
      final snap = await _users.doc(_uid).get();
      final data = snap.data();
      if (data == null) return null;
      return UserProfile.fromMap(data);
    } catch (_) {
      rethrow;
    }
  }
  Stream<UserProfile?> watchCurrentUserProfile() {
    if (_uid == null) return const Stream.empty();
    return _users.doc(_uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserProfile.fromMap(data);
    });
  }
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _users.doc(uid).delete();
    } catch (_) {
      rethrow;
    }
  }
  Future<String> createWorkout(Workout workout) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      final id = workout.id.isEmpty ? _userWorkouts(_uid!).doc().id : workout.id;
      final now = DateTime.now();
      final toSave = workout.copyWith(id: id, createdAt: now, updatedAt: now);
      await _userWorkouts(_uid!).doc(id).set(toSave.toMap());
      return id;
    } catch (_) {
      rethrow;
    }
  }
  Future<Workout?> getWorkout(String workoutId) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      final snap = await _userWorkouts(_uid!).doc(workoutId).get();
      final data = snap.data();
      if (data == null) return null;
      return Workout.fromMap(data);
    } catch (_) {
      rethrow;
    }
  }
  Stream<List<Workout>> watchWorkouts() {
    if (_uid == null) return const Stream.empty();
    return _userWorkouts(_uid!)
        .snapshots()
        .map((q) {
          final list = q.docs.map((d) => Workout.fromMap(d.data())).toList();
          list.sort((a, b) {
            final aTime = a.updatedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
          return list;
        });
  }
  Stream<List<Workout>> watchWorkoutsByLevel(String level) {
    if (_uid == null) return const Stream.empty();
    return _userWorkouts(_uid!)
        .where('level', isEqualTo: level)
        .snapshots()
        .map((q) {
          final list = q.docs.map((d) => Workout.fromMap(d.data())).toList();
          list.sort((a, b) {
            final aTime = a.updatedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
          return list;
        });
  }
  Future<void> updateWorkout(Workout workout) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      final updated = workout.copyWith(updatedAt: DateTime.now());
      await _userWorkouts(_uid!).doc(workout.id).update(updated.toMap());
    } catch (_) {
      rethrow;
    }
  }
  Future<void> deleteWorkout(String workoutId) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      await _userWorkouts(_uid!).doc(workoutId).delete();
    } catch (_) {
      rethrow;
    }
  }
  Future<String> createExercise(String workoutId, Exercise exercise) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      final id =
          exercise.id.isEmpty ? _workoutExercises(_uid!, workoutId).doc().id : exercise.id;
      final toSave = exercise.copyWith(id: id);
      await _workoutExercises(_uid!, workoutId).doc(id).set(toSave.toMap());
      return id;
    } catch (_) {
      rethrow;
    }
  }
  Future<Exercise?> getExercise(String workoutId, String exerciseId) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      final snap =
          await _workoutExercises(_uid!, workoutId).doc(exerciseId).get();
      final data = snap.data();
      if (data == null) return null;
      return Exercise.fromMap(data);
    } catch (_) {
      rethrow;
    }
  }
  Stream<List<Exercise>> watchExercises(String workoutId) {
    if (_uid == null) return const Stream.empty();
    return _workoutExercises(_uid!, workoutId).snapshots().map(
          (q) => q.docs.map((d) => Exercise.fromMap(d.data())).toList(),
        );
  }
  Future<void> updateExercise(String workoutId, Exercise exercise) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      await _workoutExercises(_uid!, workoutId)
          .doc(exercise.id)
          .update(exercise.toMap());
    } catch (_) {
      rethrow;
    }
  }
  Future<void> deleteExercise(String workoutId, String exerciseId) async {
    try {
      if (_uid == null) throw Exception('Not authenticated');
      await _workoutExercises(_uid!, workoutId).doc(exerciseId).delete();
    } catch (_) {
      rethrow;
    }
  }
}
