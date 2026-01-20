import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/models/phase_instance.dart';
import 'package:ligno_yiled/models/phase_plan.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/services/calculator_service.dart';
import 'package:ligno_yiled/services/phase_plan_service.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';
import 'package:ligno_yiled/widgets/language_selector.dart';

class PhaseTimelineScreen extends StatefulWidget {
  const PhaseTimelineScreen({
    super.key,
    required this.input,
  });

  final CropInput input;

  @override
  State<PhaseTimelineScreen> createState() => _PhaseTimelineScreenState();
}

class _PhaseTimelineScreenState extends State<PhaseTimelineScreen> {
  final _phasePlanService = PhasePlanService();
  final _calculatorService = CalculatorService();
  late final ValueNotifier<List<PhaseInstance>> _phasesNotifier;

  @override
  void initState() {
    super.initState();
    final plan = _phasePlanService.generatePlan(widget.input);
    _phasesNotifier = ValueNotifier<List<PhaseInstance>>(plan.phases);
  }

  @override
  void dispose() {
    _phasesNotifier.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _togglePhase(PhaseInstance phase, bool? isEnabled) {
    final enabled = isEnabled ?? false;
    final updated = _phasesNotifier.value
        .map(
          (item) =>
              item.id == phase.id ? item.copyWith(isEnabled: enabled) : item,
        )
        .toList();
    _phasesNotifier.value = updated;
  }

  void _continueToResult() {
    final plan = PhasePlan(
      cropName: widget.input.cropName,
      startDate: widget.input.startDate,
      phases: _phasesNotifier.value,
    );
    final result = _calculatorService.calculate(widget.input, plan);

    Navigator.of(context).pushNamed(
      AppRoutes.result,
      arguments: ResultScreenArgs(input: widget.input, result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: AppLanguageSelector(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.input.cropName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start date: ${_formatDate(widget.input.startDate)}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<PhaseInstance>>(
                valueListenable: _phasesNotifier,
                builder: (context, phases, _) {
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: phases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final phase = phases[index];
                      return Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: ListTile(
                          leading: Checkbox(
                            value: phase.isEnabled,
                            onChanged: (value) => _togglePhase(phase, value),
                        ),
                          title: Text(phase.name),
                          subtitle: Text(
                            '${l10n.phaseDayLabel(phase.dayOffset)} · ${_formatDate(phase.date)}',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.actionBack),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _continueToResult,
                      child: Text(l10n.actionContinue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
