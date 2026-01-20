import 'package:ligno_yiled/models/calculation_result.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/models/phase_plan.dart';

class CalculatorService {
  CalculationResult calculate(CropInput input, PhasePlan plan) {
    const dosagePerHa = 0.2;
    final items = plan.phases
        .where((phase) => phase.isEnabled)
        .map(
          (phase) => ApplicationItem(
            date: phase.date,
            stageName: phase.name,
            productName: _productForPhase(input.cropName, phase.name),
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

String _productForPhase(String cropName, String phaseName) {
  const defaultProduct = 'Normat L';
  final cropMap = _productMap[cropName];
  if (cropMap == null) {
    return defaultProduct;
  }
  return cropMap[phaseName] ?? defaultProduct;
}

const Map<String, Map<String, String>> _productMap = {
  'Apricot': {
    'Cuttings': 'Normat L',
    'Planting': 'Normat C',
    'Pit formation': 'Normat L',
    'End of flowering': 'Normat C',
    'Fruit set': 'Normat L',
  },
  'Melons': {
    'Seedling': 'Normat L',
    'Transplanting': 'Normat C',
    'Vine growth': 'Normat L',
    'Flowering': 'Normat C',
    'Maturity': 'Normat L',
  },
  'Wheat': {
    'Tillering': 'Normat L',
    'Stem elongation': 'Normat C',
    'Heading': 'Normat L',
    'Grain fill': 'Normat C',
    'Maturity': 'Normat L',
  },
};
