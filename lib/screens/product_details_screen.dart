import 'package:flutter/material.dart';
import 'package:ligno_yiled/l10n/app_localizations.dart';
import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, this.productId});

  final String? productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _dataRepository = LocalDataRepository.instance;
  late final Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _dataRepository.getProducts();
  }

  String _localizedForm(ProductForm form, AppLocalizations l10n) {
    switch (form) {
      case ProductForm.liquid:
        return l10n.productFormLiquid;
      case ProductForm.dry:
        return l10n.productFormDry;
    }
  }

  String _localizedUnit(ProductUnit unit, AppLocalizations l10n) {
    switch (unit) {
      case ProductUnit.liters:
        return l10n.productUnitLiters;
      case ProductUnit.kilograms:
        return l10n.productUnitKilograms;
    }
  }

  Widget _buildSection({
    required String title,
    required String content,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SelectableText(content, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.productNotFound,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.actionBack),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final productId = widget.productId;
            if (productId == null) {
              return _buildError(l10n);
            }
            final products = snapshot.data ?? const <Product>[];
            Product? product;
            for (final item in products) {
              if (item.id == productId) {
                product = item;
                break;
              }
            }
            if (product == null) {
              return _buildError(l10n);
            }

            return ListView(
              padding: const EdgeInsetsDirectional.all(16),
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.productFormLabel,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  _localizedForm(product.form, l10n),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.productUnitLabel,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  _localizedUnit(product.unit, l10n),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (product.description != null)
                  _buildSection(
                    title: l10n.sectionDescription,
                    content: product.description!,
                    textTheme: theme.textTheme,
                  ),
                if (product.composition != null)
                  _buildSection(
                    title: l10n.sectionComposition,
                    content: product.composition!,
                    textTheme: theme.textTheme,
                  ),
                if (product.instructions != null)
                  _buildSection(
                    title: l10n.sectionInstructions,
                    content: product.instructions!,
                    textTheme: theme.textTheme,
                  ),
                if (product.warnings != null)
                  _buildSection(
                    title: l10n.sectionWarnings,
                    content: product.warnings!,
                    textTheme: theme.textTheme,
                  ),
                if (product.faq != null)
                  _buildSection(
                    title: l10n.sectionFaq,
                    content: product.faq!,
                    textTheme: theme.textTheme,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
