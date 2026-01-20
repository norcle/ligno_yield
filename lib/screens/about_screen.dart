import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';
import 'package:ligno_yiled/widgets/language_selector.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: AppLanguageSelector(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A concise helper for planning crop treatments and viewing phase timelines.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
