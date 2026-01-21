import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/models/crop.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/state/app_state_models.dart';
import 'package:ligno_yiled/state/shared_preferences_provider.dart';

const calculatorDraftStorageKey = 'calculator_draft';

final calculatorDraftProvider =
    StateNotifierProvider<CalculatorDraftNotifier, CalculatorDraftState>(
  (ref) => CalculatorDraftNotifier(ref),
);

class CalculatorDraftNotifier extends StateNotifier<CalculatorDraftState> {
  CalculatorDraftNotifier(this.ref) : super(const CalculatorDraftState());

  final Ref ref;

  void setDraft(CalculatorDraftState draft, {bool persist = true}) {
    state = draft;
    if (persist) {
      _persistDraft();
    }
  }

  void updateCrop(Crop? crop) {
    state = state.copyWith(crop: crop, clearCrop: crop == null);
    _persistDraft();
  }

  void updateAreaHa(double? areaHa) {
    state = state.copyWith(areaHa: areaHa, clearAreaHa: areaHa == null);
    _persistDraft();
  }

  void updateStartDate(DateTime? startDate) {
    state = state.copyWith(
      startDate: startDate,
      clearStartDate: startDate == null,
    );
    _persistDraft();
  }

  void updateSoilType(SoilType? soilType) {
    state = state.copyWith(
      soilType: soilType,
      clearSoilType: soilType == null,
    );
    _persistDraft();
  }

  void updateSchemeType(String? schemeType) {
    state = state.copyWith(
      schemeType: schemeType,
      clearSchemeType: schemeType == null,
    );
    _persistDraft();
  }

  void updateRegion(String? region) {
    state = state.copyWith(region: region, clearRegion: region == null);
    _persistDraft();
  }

  void _persistDraft() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs == null) {
      return;
    }
    if (_isEmpty(state)) {
      prefs.remove(calculatorDraftStorageKey);
      return;
    }
    prefs.setString(
      calculatorDraftStorageKey,
      jsonEncode(state.toJson()),
    );
  }

  bool _isEmpty(CalculatorDraftState draft) {
    return draft.crop == null &&
        draft.areaHa == null &&
        draft.startDate == null &&
        draft.soilType == null &&
        draft.schemeType == null &&
        draft.region == null;
  }
}
