class Workout {
  final String id;
  final String title;
  final String? description;
  final int? durationMinutes;
  final String? level; // 'Beginner' | 'Intermediate' | 'Advanced'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Workout({
    required this.id,
    required this.title,
    this.description,
    this.durationMinutes,
    this.level,
    this.createdAt,
    this.updatedAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'level': level,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      durationMinutes: (map['durationMinutes'] as num?)?.toInt(),
      level: map['level'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }
  Workout copyWith({
    String? id,
    String? title,
    String? description,
    int? durationMinutes,
    String? level,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
