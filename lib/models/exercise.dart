class Exercise {
  final String id;
  final String name;
  final int? sets;
  final int? reps;
  final double? weightKg;
  final String? notes;
  const Exercise({
    required this.id,
    required this.name,
    this.sets,
    this.reps,
    this.weightKg,
    this.notes,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weightKg': weightKg,
      'notes': notes,
    };
  }
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      sets: (map['sets'] as num?)?.toInt(),
      reps: (map['reps'] as num?)?.toInt(),
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
    );
  }
  Exercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    double? weightKg,
    String? notes,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      notes: notes ?? this.notes,
    );
  }
}
