class PhaseInstance {
  const PhaseInstance({
    required this.id,
    required this.name,
    required this.dayOffset,
    required this.date,
    required this.isEnabled,
  });

  final String id;
  final String name;
  final int dayOffset;
  final DateTime date;
  final bool isEnabled;

  PhaseInstance copyWith({
    int? dayOffset,
    DateTime? date,
    bool? isEnabled,
  }) {
    return PhaseInstance(
      id: id,
      name: name,
      dayOffset: dayOffset ?? this.dayOffset,
      date: date ?? this.date,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
