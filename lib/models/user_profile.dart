class UserProfile {
  final String uid;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final double? heightCm;
  final double? weightKg;
  const UserProfile({
    required this.uid,
    this.name,
    this.email,
    this.avatarUrl,
    this.heightCm,
    this.weightKg,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'heightCm': heightCm,
      'weightKg': weightKg,
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
    );
  }
  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    double? heightCm,
    double? weightKg,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}
