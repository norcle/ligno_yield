import 'package:flutter/material.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _avgYieldController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  final _selectedCrop = ValueNotifier<String?>(null);
  final _selectedSoil = ValueNotifier<SoilType?>(null);
  final _selectedDate = ValueNotifier<DateTime?>(null);

  final _crops = const ['Apricot', 'Melons', 'Wheat'];

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
      cropName: crop,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('LignoUrozhai'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: _selectedCrop,
                builder: (context, value, _) {
                  return DropdownButtonFormField<String>(
                    value: value,
                    decoration: const InputDecoration(
                      labelText: 'Crop',
                    ),
                    items: _crops
                        .map(
                          (crop) => DropdownMenuItem(
                            value: crop,
                            child: Text(crop),
                          ),
                        )
                        .toList(),
                    onChanged: (selection) => _selectedCrop.value = selection,
                    validator: (selection) =>
                        selection == null ? 'Select a crop' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<SoilType?>(
                valueListenable: _selectedSoil,
                builder: (context, value, _) {
                  return DropdownButtonFormField<SoilType>(
                    value: value,
                    decoration: const InputDecoration(
                      labelText: 'Soil type',
                    ),
                    items: SoilType.values
                        .map(
                          (soil) => DropdownMenuItem(
                            value: soil,
                            child: Text(soil.label),
                          ),
                        )
                        .toList(),
                    onChanged: (selection) => _selectedSoil.value = selection,
                    validator: (selection) =>
                        selection == null ? 'Select a soil type' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Vegetation start date',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                onTap: _pickDate,
                validator: (_) => _selectedDate.value == null
                    ? 'Select a start date'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Treated area (ha)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final parsed = _parseDouble(value ?? '');
                  if (parsed == null) {
                    return 'Enter an area';
                  }
                  if (parsed <= 0) {
                    return 'Area must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _avgYieldController,
                decoration: const InputDecoration(
                  labelText: 'Average yield (centner/ha)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Planned price per 1 ton (RUB)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
