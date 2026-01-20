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

  factory PhaseTemplate.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final dayOffset = json['dayOffset'];
    final defaultEnabled = json['defaultEnabled'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Phase template id is missing or invalid.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Phase template name is missing or invalid.');
    }
    if (dayOffset is! num) {
      throw const FormatException(
        'Phase template dayOffset is missing or invalid.',
      );
    }
    if (defaultEnabled is! bool) {
      throw const FormatException(
        'Phase template defaultEnabled is missing or invalid.',
      );
    }
    return PhaseTemplate(
      id: id,
      name: name,
      dayOffset: dayOffset.toInt(),
      defaultEnabled: defaultEnabled,
    );
  }
}
