import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/models/calculation_result.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/models/phase_instance.dart';
import 'package:ligno_yiled/models/phase_plan.dart';
import 'package:ligno_yiled/models/product.dart';

class CalculatorService {
  CalculatorService({LocalDataRepository? repository})
      : _repository = repository ?? LocalDataRepository.instance;

  final LocalDataRepository _repository;

  Future<CalculationResult> calculate(CropInput input, PhasePlan plan) async {
    const dosagePerHa = 0.2;
    final products = await _repository.getProducts();
    final items = plan.phases
        .where((phase) => phase.isEnabled)
        .map(
          (phase) => ApplicationItem(
            date: phase.date,
            stageName: phase.name,
            productName: _productForPhase(phase, products),
            dosagePerHa: dosagePerHa,
            totalAmount: input.areaHa * dosagePerHa,
          ),
        )
        .toList();

    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.totalAmount,
    );

    return CalculationResult(items: items, totalAmount: totalAmount);
  }
}

String _productForPhase(PhaseInstance phase, List<Product> products) {
  const fallbackProduct = 'Normat L';
  if (products.isEmpty) {
    return fallbackProduct;
  }
  final hash = phase.id.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
  final index = hash % products.length;
  return products[index].name;
}
