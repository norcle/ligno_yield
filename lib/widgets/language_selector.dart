import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/state/locale_provider.dart';

class AppLanguageSelector extends ConsumerWidget {
  const AppLanguageSelector({super.key});

  static const Map<String, _LanguageOption> _languageOptions = {
    'ru': _LanguageOption(flag: '🇷🇺', label: 'Russian'),
    'en': _LanguageOption(flag: '🇬🇧', label: 'English'),
    'uz': _LanguageOption(flag: '🇺🇿', label: 'O‘zbek'),
    'kk': _LanguageOption(flag: '🇰🇿', label: 'Қазақша'),
    'ar': _LanguageOption(flag: '🇸🇦', label: 'العربية'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: localeState.locale,
        icon: const Icon(Icons.language_outlined),
        onChanged: (locale) {
          if (locale == null) {
            return;
          }
          ref.read(localeProvider.notifier).setLocale(locale);
        },
        selectedItemBuilder: (context) {
          return supportedLocales.map((locale) {
            final option = _languageOptions[locale.languageCode];
            return _LanguageOptionRow(
              option: option,
              fallbackLabel: locale.languageCode,
              compact: true,
            );
          }).toList();
        },
        items: supportedLocales.map((locale) {
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
