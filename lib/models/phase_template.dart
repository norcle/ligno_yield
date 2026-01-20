class PhaseTemplate {
  const PhaseTemplate({
    required this.id,
    required this.name,
    required this.dayOffset,
    required this.defaultEnabled,
  });

  final String id;
  final String name;
  final int dayOffset;
  final bool defaultEnabled;
}
