import 'package:ligno_yiled/models/phase_instance.dart';

class PhasePlan {
  const PhasePlan({
    required this.cropName,
    required this.startDate,
    required this.phases,
  });

  final String cropName;
  final DateTime startDate;
  final List<PhaseInstance> phases;
}
