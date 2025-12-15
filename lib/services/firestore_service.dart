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
  Future<void> setUserProfile(UserProfile profile) async {
    try {
      await _users.doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
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
    return _userWorkouts(_uid!).orderBy('createdAt', descending: true).snapshots().map(
          (q) => q.docs.map((d) => Workout.fromMap(d.data())).toList(),
        );
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
