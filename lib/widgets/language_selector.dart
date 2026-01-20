import 'package:flutter/material.dart';
import 'package:ligno_yiled/services/app_locale_controller.dart';
import 'package:ligno_yiled/widgets/locale_scope.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({super.key});

  static const Map<String, String> _languageLabels = {
    'ru': 'RU',
    'en': 'EN',
    'uz': 'UZ',
    'kk': 'KZ',
    'tg': 'TJ',
  };

  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: controller.locale,
        icon: const Icon(Icons.language_outlined),
        onChanged: (locale) {
          if (locale == null) {
            return;
          }
          controller.setLocale(locale);
        },
        items: AppLocaleController.supportedLocales.map((locale) {
          final label =
              _languageLabels[locale.languageCode] ?? locale.languageCode;
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(label),
          );
        }).toList(),
      ),
    );
  }
}
