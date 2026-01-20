import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/models/product.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/widgets/app_drawer.dart';
import 'package:ligno_yiled/widgets/language_selector.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _dataRepository = LocalDataRepository.instance;
  final _searchController = TextEditingController();
  late final Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _dataRepository.getProducts();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    setState(() {});
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = products.where((product) {
      final isActive = product.isActive ?? true;
      if (!isActive) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return product.name.toLowerCase().contains(query);
    }).toList();
    filtered.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return filtered;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: AppLanguageSelector(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchHintProducts,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final products = snapshot.data ?? const <Product>[];
                  final visibleProducts = _filterProducts(products);
                  if (visibleProducts.isEmpty) {
                    return Center(
                      child: Text(l10n.noProductsFound),
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
                    itemCount: visibleProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];
                      final formUnit =
                          '${_localizedForm(product.form, l10n)}, '
                          '${_localizedUnit(product.unit, l10n)}';
                      final description = product.description;
                      return Card(
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formUnit),
                              if (description != null)
                                Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.productDetails,
                              arguments:
                                  ProductDetailsArgs(productId: product.id),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
