enum ProductForm {
  liquid,
  dry;

  static ProductForm fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'liquid':
        return ProductForm.liquid;
      case 'dry':
        return ProductForm.dry;
      default:
        throw FormatException('Unknown product form: $value');
    }
  }
}

enum ProductUnit {
  liters,
  kilograms;

  static ProductUnit fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'l':
        return ProductUnit.liters;
      case 'kg':
        return ProductUnit.kilograms;
      default:
        throw FormatException('Unknown product unit: $value');
    }
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.form,
    required this.unit,
    this.description,
    this.composition,
    this.instructions,
    this.faq,
    this.warnings,
    this.isActive,
  });

  final String id;
  final String name;
  final ProductForm form;
  final ProductUnit unit;
  final String? description;
  final String? composition;
  final String? instructions;
  final String? faq;
  final String? warnings;
  final bool? isActive;

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final form = json['form'];
    final unit = json['unit'];
    final isActive = json['isActive'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Product id is missing or invalid.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Product name is missing or invalid.');
    }
    if (form is! String) {
      throw const FormatException('Product form is missing or invalid.');
    }
    if (unit is! String) {
      throw const FormatException('Product unit is missing or invalid.');
    }
    return Product(
      id: id,
      name: name,
      form: ProductForm.fromJson(form),
      unit: ProductUnit.fromJson(unit),
      description: _asOptionalString(json['description']),
      composition: _asOptionalString(json['composition']),
      instructions: _asOptionalString(json['instructions']),
      faq: _asOptionalString(json['faq']),
      warnings: _asOptionalString(json['warnings']),
      isActive: isActive is bool ? isActive : null,
    );
  }
}

String? _asOptionalString(Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is List) {
    final items = value.whereType<String>().map((item) => item.trim());
    final filtered = items.where((item) => item.isNotEmpty).toList();
    if (filtered.isEmpty) {
      return null;
    }
    return filtered.join('\n');
  }
  return null;
}
