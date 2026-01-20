import 'package:flutter_test/flutter_test.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/services/calculator_service.dart';

void main() {
  test('CalculatorService returns expected total amount', () {
    final service = CalculatorService();
    final input = CropInput(
      cropName: 'Wheat',
      soilType: SoilType.openField,
      startDate: DateTime(2024, 5, 1),
      areaHa: 10,
      avgYieldCPerHa: 25,
      pricePerTonRub: 10000,
    );

    final result = service.calculate(input);

    expect(result.items, hasLength(3));
    expect(result.items.first.totalAmount, 2.0);
    expect(result.totalAmount, 6.0);
  });
}
