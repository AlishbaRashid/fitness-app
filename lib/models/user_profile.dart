class UserProfile {
  final String uid;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final double? heightCm;
  final double? weightKg;
  final int? finishedWorkouts;
  final int? workoutsInProgress;
  final double? timeSpentMinutes;
  const UserProfile({
    required this.uid,
    this.name,
    this.email,
    this.avatarUrl,
    this.heightCm,
    this.weightKg,
    this.finishedWorkouts,
    this.workoutsInProgress,
    this.timeSpentMinutes,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'finishedWorkouts': finishedWorkouts,
      'workoutsInProgress': workoutsInProgress,
      'timeSpentMinutes': timeSpentMinutes,
    };
  }
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      heightCm: (map['heightCm'] as num?)?.toDouble(),
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      finishedWorkouts: (map['finishedWorkouts'] as num?)?.toInt(),
      workoutsInProgress: (map['workoutsInProgress'] as num?)?.toInt(),
      timeSpentMinutes: (map['timeSpentMinutes'] as num?)?.toDouble(),
    );
  }
  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    double? heightCm,
    double? weightKg,
    int? finishedWorkouts,
    int? workoutsInProgress,
    double? timeSpentMinutes,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      finishedWorkouts: finishedWorkouts ?? this.finishedWorkouts,
      workoutsInProgress: workoutsInProgress ?? this.workoutsInProgress,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
    );
  }
}
