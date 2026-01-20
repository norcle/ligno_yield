import 'package:flutter/foundation.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/models/phase_instance.dart';
import 'package:ligno_yiled/models/phase_plan.dart';
import 'package:ligno_yiled/models/phase_template.dart';

class PhasePlanService {
  PhasePlan generatePlan(CropInput input) {
    final templates = _templatesByCrop[input.cropName] ?? _fallbackTemplates();
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

  List<PhaseTemplate> _fallbackTemplates() {
    debugPrint('TODO: Add templates for this crop.');
    return const [
      PhaseTemplate(
        id: 'start',
        name: 'Start of vegetation',
        dayOffset: 0,
        defaultEnabled: true,
      ),
      PhaseTemplate(
        id: 'mid',
        name: 'Mid season',
        dayOffset: 14,
        defaultEnabled: true,
      ),
      PhaseTemplate(
        id: 'finish',
        name: 'Harvest prep',
        dayOffset: 28,
        defaultEnabled: true,
      ),
    ];
  }
}

const Map<String, List<PhaseTemplate>> _templatesByCrop = {
  'Apricot': [
    PhaseTemplate(
      id: 'cuttings',
      name: 'Cuttings',
      dayOffset: 0,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'planting',
      name: 'Planting',
      dayOffset: 1,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'pit-formation',
      name: 'Pit formation',
      dayOffset: 7,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'flowering-end',
      name: 'End of flowering',
      dayOffset: 30,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'fruit-set',
      name: 'Fruit set',
      dayOffset: 45,
      defaultEnabled: false,
    ),
  ],
  'Melons': [
    PhaseTemplate(
      id: 'seedling',
      name: 'Seedling',
      dayOffset: 0,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'transplant',
      name: 'Transplanting',
      dayOffset: 3,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'vines',
      name: 'Vine growth',
      dayOffset: 12,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'flowering',
      name: 'Flowering',
      dayOffset: 24,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'maturity',
      name: 'Maturity',
      dayOffset: 38,
      defaultEnabled: false,
    ),
  ],
  'Wheat': [
    PhaseTemplate(
      id: 'tillering',
      name: 'Tillering',
      dayOffset: 0,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'stem-elongation',
      name: 'Stem elongation',
      dayOffset: 10,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'heading',
      name: 'Heading',
      dayOffset: 20,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'grain-fill',
      name: 'Grain fill',
      dayOffset: 35,
      defaultEnabled: true,
    ),
    PhaseTemplate(
      id: 'maturity',
      name: 'Maturity',
      dayOffset: 50,
      defaultEnabled: false,
    ),
  ],
};
