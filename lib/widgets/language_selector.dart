import 'package:flutter/material.dart';
import 'package:ligno_yiled/services/app_locale_controller.dart';
import 'package:ligno_yiled/widgets/locale_scope.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({super.key});

  static const Map<String, _LanguageOption> _languageOptions = {
    'ru': _LanguageOption(flag: '🇷🇺', label: 'Russian'),
    'en': _LanguageOption(flag: '🇬🇧', label: 'English'),
    'uz': _LanguageOption(flag: '🇺🇿', label: 'O‘zbek'),
    'kk': _LanguageOption(flag: '🇰🇿', label: 'Қазақша'),
    'tg': _LanguageOption(flag: '🇹🇯', label: 'Тоҷикӣ'),
    'ar': _LanguageOption(flag: '🇸🇦', label: 'العربية'),
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
        selectedItemBuilder: (context) {
          return AppLocaleController.supportedLocales.map((locale) {
            final option = _languageOptions[locale.languageCode];
            return _LanguageOptionRow(
              option: option,
              fallbackLabel: locale.languageCode,
              compact: true,
            );
          }).toList();
        },
        items: AppLocaleController.supportedLocales.map((locale) {
          final option = _languageOptions[locale.languageCode];
          return DropdownMenuItem<Locale>(
            value: locale,
            child: _LanguageOptionRow(
              option: option,
              fallbackLabel: locale.languageCode,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LanguageOptionRow extends StatelessWidget {
  const _LanguageOptionRow({
    required this.option,
    required this.fallbackLabel,
    this.compact = false,
  });

  final _LanguageOption? option;
  final String fallbackLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final label = option?.label ?? fallbackLabel;
    final flag = option?.flag ?? '🌐';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(flag, style: textTheme.titleMedium),
        SizedBox(width: compact ? 6 : 10),
        Text(label),
      ],
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.flag, required this.label});

  final String flag;
  final String label;
}
