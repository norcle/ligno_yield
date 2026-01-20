import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/models/calculation_result.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';
import 'package:ligno_yiled/widgets/language_selector.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.input,
    required this.result,
  });

  final CropInput input;
  final CalculationResult result;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.resultTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              input.cropName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Treated area: ${input.areaHa.toStringAsFixed(2)} ha',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Applications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...result.items.map(
              (item) => Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest,
                child: ListTile(
                  title: Text(item.stageName),
                  subtitle: Text(
                    '${_formatDate(item.date)} · ${item.productName}',
                  ),
                  trailing: Text(
                    '${item.totalAmount.toStringAsFixed(2)} L',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.resultTotal}: ${result.totalAmount.toStringAsFixed(2)} L',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
