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
  });

  final String id;
  final String name;
  final ProductForm form;
  final ProductUnit unit;

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final form = json['form'];
    final unit = json['unit'];
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
    );
  }
}
