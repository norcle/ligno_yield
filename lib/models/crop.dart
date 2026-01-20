class Crop {
  const Crop({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Crop.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Crop id is missing or invalid.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Crop name is missing or invalid.');
    }
    return Crop(id: id, name: name);
  }
}
