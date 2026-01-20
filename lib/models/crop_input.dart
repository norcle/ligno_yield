enum SoilType {
  openField('Open field'),
  greenhouse('Greenhouse');

  const SoilType(this.label);

  final String label;
}

class CropInput {
  const CropInput({
    required this.cropId,
    required this.cropName,
    required this.soilType,
    required this.startDate,
    required this.areaHa,
    this.avgYieldCPerHa,
    this.pricePerTonRub,
  });

  final String cropId;
  final String cropName;
  final SoilType soilType;
  final DateTime startDate;
  final double areaHa;
  final double? avgYieldCPerHa;
  final double? pricePerTonRub;
}
