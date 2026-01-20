import 'package:flutter/material.dart';

class AppLocaleState {
  const AppLocaleState({required this.locale});

  final Locale locale;

  AppLocaleState copyWith({Locale? locale}) {
    return AppLocaleState(locale: locale ?? this.locale);
  }
}

const List<Locale> supportedLocales = [
  Locale('ru'),
  Locale('en'),
  Locale('uz'),
  Locale('kk'),
  Locale('ar'),
];
