import 'package:flutter/material.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController({Locale? initialLocale})
      : _locale = initialLocale ?? const Locale('ru');

  static const List<Locale> supportedLocales = [
    Locale('ru'),
    Locale('en'),
    Locale('uz'),
    Locale('kk'),
    Locale('tg'),
  ];

  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!_isSupported(locale)) {
      return;
    }
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
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

  bool _isSupported(Locale locale) {
    return supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }
}
