import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/state/app_state_models.dart';
import 'package:ligno_yiled/state/shared_preferences_provider.dart';

const localeStorageKey = 'app_locale';

const supportedLocales = <Locale>[
  Locale('ru'),
  Locale('en'),
  Locale('uz'),
  Locale('kk'),
  Locale('ar'),
];

Locale resolveSystemLocale(Locale? systemLocale) {
  if (systemLocale == null) {
    return const Locale('ru');
  }
  return supportedLocales.firstWhere(
    (locale) => locale.languageCode == systemLocale.languageCode,
    orElse: () => const Locale('ru'),
  );
}

Locale? localeFromCode(String? code) {
  if (code == null) {
    return null;
  }
  return supportedLocales.firstWhere(
    (locale) => locale.languageCode == code,
    orElse: () => const Locale('ru'),
  );
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocaleState>(
  (ref) => LocaleNotifier(ref),
);

class LocaleNotifier extends StateNotifier<AppLocaleState> {
  LocaleNotifier(this.ref)
      : super(const AppLocaleState(locale: Locale('ru')));

  final Ref ref;

  void setLocale(Locale locale, {bool persist = true}) {
    if (!_isSupported(locale)) {
      return;
    }
    if (state.locale == locale) {
      if (persist) {
        _persistLocale(locale);
      }
      return;
    }
    state = state.copyWith(locale: locale);
    if (persist) {
      _persistLocale(locale);
    }
  }

  void _persistLocale(Locale locale) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs?.setString(localeStorageKey, locale.languageCode);
  }

  bool _isSupported(Locale locale) {
    return supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }
}
