import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/models/phase_instance.dart';
import 'package:ligno_yiled/models/phase_plan.dart';

class PhasePlanService {
  PhasePlanService({LocalDataRepository? repository})
      : _repository = repository ?? LocalDataRepository.instance;

  final LocalDataRepository _repository;

  Future<PhasePlan> generatePlan(CropInput input) async {
    final templates = await _repository.getPhaseTemplates(input.cropId);
    final phases = templates
        .map(
          (template) => PhaseInstance(
            id: template.id,
            name: template.name,
            dayOffset: template.dayOffset,
            date: input.startDate.add(Duration(days: template.dayOffset)),
            isEnabled: template.defaultEnabled,
          ),
        )
        .toList()
      ..sort((a, b) => a.dayOffset.compareTo(b.dayOffset));

    return PhasePlan(
      cropName: input.cropName,
      startDate: input.startDate,
      phases: phases,
    );
  }
}
