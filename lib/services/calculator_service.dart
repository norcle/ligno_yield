import 'package:ligno_yiled/models/calculation_result.dart';
import 'package:ligno_yiled/models/crop_input.dart';

class CalculatorService {
  CalculationResult calculate(CropInput input) {
    const dosagePerHa = 0.2;
    final products = ['Normat L', 'Normat C', 'Normat L'];
    final items = List<ApplicationItem>.generate(products.length, (index) {
      final date = input.startDate.add(Duration(days: index * 7));
      final totalAmount = input.areaHa * dosagePerHa;
      return ApplicationItem(
        date: date,
        stageName: 'Application ${index + 1}',
        productName: products[index],
        dosagePerHa: dosagePerHa,
        totalAmount: totalAmount,
      );
    });

    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.totalAmount,
    );

    return CalculationResult(items: items, totalAmount: totalAmount);
  }
}
