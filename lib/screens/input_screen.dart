import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/l10n/app_localizations.dart';
import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/models/crop.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/state/app_providers.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';
import 'package:ligno_yiled/widgets/language_selector.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _avgYieldController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  final _selectedCrop = ValueNotifier<Crop?>(null);
  final _selectedSoil = ValueNotifier<SoilType?>(null);
  final _selectedDate = ValueNotifier<DateTime?>(null);
  String? _initialCropId;

  final _dataRepository = LocalDataRepository.instance;
  late final Future<List<Crop>> _cropsFuture;

  @override
  void initState() {
    super.initState();
    _cropsFuture = _dataRepository.getCrops();
    final draft = ref.read(calculatorDraftProvider);
    _initialCropId = draft.cropId;
    _selectedSoil.value = draft.soilType;
    _selectedDate.value = draft.startDate;
    if (draft.startDate != null) {
      _dateController.text = _formatDate(draft.startDate!);
    }
    if (draft.areaHa != null) {
      _areaController.text = draft.areaHa.toString();
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _avgYieldController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _selectedCrop.dispose();
    _selectedSoil.dispose();
    _selectedDate.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  double? _parseDouble(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDate.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      _selectedDate.value = picked;
      _dateController.text = _formatDate(picked);
      ref.read(calculatorDraftProvider.notifier).updateStartDate(picked);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final crop = _selectedCrop.value;
    final soil = _selectedSoil.value;
    final date = _selectedDate.value;
    if (crop == null || soil == null || date == null) {
      return;
    }

    final area = _parseDouble(_areaController.text);
    if (area == null || area <= 0) {
      return;
    }

    final avgYield = _parseDouble(_avgYieldController.text);
    final price = _parseDouble(_priceController.text);

    final input = CropInput(
      cropId: crop.id,
      cropName: crop.name,
      soilType: soil,
      startDate: date,
      areaHa: area,
      avgYieldCPerHa: avgYield,
      pricePerTonRub: price,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.phaseTimeline,
      arguments: PhaseTimelineArgs(input: input),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(calculatorDraftProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: AppLanguageSelector(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ValueListenableBuilder<Crop?>(
                valueListenable: _selectedCrop,
                builder: (context, value, _) {
                  return FutureBuilder<List<Crop>>(
                    future: _cropsFuture,
                builder: (context, snapshot) {
                  final crops = snapshot.data ?? const <Crop>[];
                  final preferredCropId = _selectedCrop.value?.id ??
                      _initialCropId ??
                      draft.cropId;
                  if (preferredCropId != null) {
                    final matched = crops
                        .where((crop) => crop.id == preferredCropId)
                        .toList();
                    if (matched.isNotEmpty &&
                        _selectedCrop.value?.id != matched.first.id) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) {
                          return;
                        }
                        _selectedCrop.value = matched.first;
                      });
                    }
                  }
                  return DropdownButtonFormField<Crop>(
                    value: value,
                    decoration: InputDecoration(
                      labelText: l10n.inputCrop,
                    ),
                        items: crops
                            .map(
                              (crop) => DropdownMenuItem(
                                value: crop,
                                child: Text(crop.name),
                              ),
                            )
                            .toList(),
                        onChanged: (selection) {
                          _selectedCrop.value = selection;
                          if (selection != null) {
                            ref
                                .read(calculatorDraftProvider.notifier)
                                .updateCrop(
                                  id: selection.id,
                                  name: selection.name,
                                );
                          }
                        },
                        validator: (selection) => selection == null
                            ? l10n.inputSelectCropError
                            : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<SoilType?>(
                valueListenable: _selectedSoil,
                builder: (context, value, _) {
                  return DropdownButtonFormField<SoilType>(
                    value: value,
                    decoration: InputDecoration(
                      labelText: l10n.inputSoilType,
                    ),
                    items: SoilType.values
                        .map(
                          (soil) => DropdownMenuItem(
                            value: soil,
                            child: Text(soil.label),
                          ),
                        )
                        .toList(),
                    onChanged: (selection) {
                      _selectedSoil.value = selection;
                      ref
                          .read(calculatorDraftProvider.notifier)
                          .updateSoilType(selection);
                    },
                    validator: (selection) =>
                        selection == null ? l10n.inputSelectSoilError : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.inputStartDate,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                onTap: _pickDate,
                validator: (_) => _selectedDate.value == null
                    ? l10n.inputSelectDateError
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: l10n.inputArea,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  ref
                      .read(calculatorDraftProvider.notifier)
                      .updateArea(_parseDouble(value));
                },
                validator: (value) {
                  final parsed = _parseDouble(value ?? '');
                  if (parsed == null) {
                    return l10n.inputAreaRequiredError;
                  }
                  if (parsed <= 0) {
                    return l10n.inputAreaMinError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avgYieldController,
                decoration: InputDecoration(
                  labelText: l10n.inputAvgYieldLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: l10n.inputPriceLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: Text(l10n.actionCalculate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
