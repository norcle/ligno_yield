import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ligno_yiled/state/app_locale_state.dart';
import 'package:ligno_yiled/state/calculator_draft_state.dart';

const _localePrefsKey = 'app_locale';
const _calculatorDraftPrefsKey = 'calculator_draft';

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocaleState>(
  (ref) => LocaleNotifier(),
);

final calculatorDraftProvider =
    StateNotifierProvider<CalculatorDraftNotifier, CalculatorDraftState>(
  (ref) => CalculatorDraftNotifier(),
);

class LocaleNotifier extends StateNotifier<AppLocaleState> {
  LocaleNotifier() : super(const AppLocaleState(locale: Locale('ru')));

  SharedPreferences? _prefs;

  void attachPreferences(SharedPreferences prefs) {
    _prefs = prefs;
  }

  void hydrate({Locale? systemLocale}) {
    final stored = _prefs?.getString(_localePrefsKey);
    if (stored != null) {
      final resolved = _resolveSupported(Locale(stored));
      if (resolved != null) {
        state = AppLocaleState(locale: resolved);
        return;
      }
    }
    state = AppLocaleState(locale: resolveSystemLocale(systemLocale));
  }

  void setLocale(Locale locale) {
    final resolved = _resolveSupported(locale);
    if (resolved == null || resolved == state.locale) {
      return;
    }
    state = state.copyWith(locale: resolved);
    _prefs?.setString(_localePrefsKey, resolved.languageCode);
  }

  Locale resolveSystemLocale(Locale? systemLocale) {
    if (systemLocale == null) {
      return const Locale('ru');
    }
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == systemLocale.languageCode,
      orElse: () => const Locale('ru'),
    );
  }

  Locale? _resolveSupported(Locale locale) {
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }
    return null;
  }
}

class CalculatorDraftNotifier extends StateNotifier<CalculatorDraftState> {
  CalculatorDraftNotifier() : super(const CalculatorDraftState());

  SharedPreferences? _prefs;

  void attachPreferences(SharedPreferences prefs) {
    _prefs = prefs;
  }

  void hydrate() {
    final stored = _prefs?.getString(_calculatorDraftPrefsKey);
    if (stored == null) {
      return;
    }
    try {
      final decoded = jsonDecode(stored);
      if (decoded is Map<String, dynamic>) {
        state = CalculatorDraftState.fromJson(decoded);
      }
    } catch (_) {
      // Ignore invalid persisted data.
    }
  }

  void updateCrop({required String id, required String name}) {
    state = state.copyWith(cropId: id, cropName: name);
    _persist();
  }

  void updateArea(double? areaHa) {
    state = state.copyWith(areaHa: areaHa);
    _persist();
  }

  void updateStartDate(DateTime? startDate) {
    state = state.copyWith(startDate: startDate);
    _persist();
  }

  void updateSoilType(SoilType? soilType) {
    state = state.copyWith(soilType: soilType);
    _persist();
  }

  void updateSchemeType(String? schemeType) {
    state = state.copyWith(schemeType: schemeType);
    _persist();
  }

  void updateRegion(String? region) {
    state = state.copyWith(region: region);
    _persist();
  }

  void _persist() {
    final prefs = _prefs;
    if (prefs == null) {
      return;
    }
    prefs.setString(_calculatorDraftPrefsKey, jsonEncode(state.toJson()));
  }
}
