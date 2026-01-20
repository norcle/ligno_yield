import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ligno_yiled/models/crop.dart';
import 'package:ligno_yiled/models/phase_template.dart';
import 'package:ligno_yiled/models/product.dart';

class LocalDataRepository {
  LocalDataRepository._();

  static final LocalDataRepository instance = LocalDataRepository._();

  List<Crop>? _crops;
  List<Product>? _products;
  Map<String, List<PhaseTemplate>>? _phaseTemplatesByCrop;

  Future<void> preload() async {
    await Future.wait([
      getCrops(),
      getProducts(),
      _loadPhaseTemplates(),
    ]);
  }

  Future<List<Crop>> getCrops() async {
    if (_crops != null) {
      return _crops!;
    }
    try {
      final jsonString = await rootBundle.loadString('assets/data/crops.json');
      final decoded = jsonDecode(jsonString);
      final cropsJson = decoded is Map<String, dynamic>
          ? decoded['crops']
          : null;
      if (cropsJson is! List) {
        throw const FormatException('Crops JSON is missing a list.');
      }
      final crops = cropsJson
          .map((entry) => Crop.fromJson(_asMap(entry)))
          .toList(growable: false);
      if (crops.isEmpty) {
        throw const FormatException('Crops JSON contains no items.');
      }
      _crops = crops;
      return crops;
    } catch (error, stackTrace) {
      debugPrint('Failed to load crops: $error');
      debugPrintStack(stackTrace: stackTrace);
      _crops = _fallbackCrops;
      return _crops!;
    }
  }

  Future<List<Product>> getProducts() async {
    if (_products != null) {
      return _products!;
    }
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final decoded = jsonDecode(jsonString);
      final productsJson = decoded is Map<String, dynamic>
          ? decoded['products']
          : null;
      if (productsJson is! List) {
        throw const FormatException('Products JSON is missing a list.');
      }
      final products = productsJson
          .map((entry) => Product.fromJson(_asMap(entry)))
          .toList(growable: false);
      if (products.isEmpty) {
        throw const FormatException('Products JSON contains no items.');
      }
      _products = products;
      return products;
    } catch (error, stackTrace) {
      debugPrint('Failed to load products: $error');
      debugPrintStack(stackTrace: stackTrace);
      _products = _fallbackProducts;
      return _products!;
    }
  }

  Future<List<PhaseTemplate>> getPhaseTemplates(String cropId) async {
    final templatesByCrop = await _loadPhaseTemplates();
    final templates = templatesByCrop[cropId];
    if (templates == null || templates.isEmpty) {
      debugPrint('Missing templates for crop: $cropId.');
      return _fallbackTemplates;
    }
    return templates;
  }

  Future<Map<String, List<PhaseTemplate>>> _loadPhaseTemplates() async {
    if (_phaseTemplatesByCrop != null) {
      return _phaseTemplatesByCrop!;
    }
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/phase_templates.json',
      );
      final decoded = jsonDecode(jsonString);
      final templateJson = decoded is Map<String, dynamic>
          ? decoded['phaseTemplates']
          : null;
      if (templateJson is! List) {
        throw const FormatException('Phase templates JSON is missing a list.');
      }
      final templatesByCrop = <String, List<PhaseTemplate>>{};
      for (final entry in templateJson) {
        final entryMap = _asMap(entry);
        final cropId = entryMap['cropId'];
        final phases = entryMap['phases'];
        if (cropId is! String || cropId.trim().isEmpty) {
          throw const FormatException('Phase template cropId is invalid.');
        }
        if (phases is! List) {
          throw const FormatException('Phase template phases are invalid.');
        }
        templatesByCrop[cropId] = phases
            .map((phase) => PhaseTemplate.fromJson(_asMap(phase)))
            .toList(growable: false);
      }
      if (templatesByCrop.isEmpty) {
        throw const FormatException('Phase templates JSON contains no items.');
      }
      _phaseTemplatesByCrop = templatesByCrop;
      return templatesByCrop;
    } catch (error, stackTrace) {
      debugPrint('Failed to load phase templates: $error');
      debugPrintStack(stackTrace: stackTrace);
      _phaseTemplatesByCrop = _fallbackPhaseTemplatesByCrop;
      return _phaseTemplatesByCrop!;
    }
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw const FormatException('Expected a JSON object.');
  }
}

const List<Crop> _fallbackCrops = [
  Crop(id: 'apricot', name: 'Apricot'),
  Crop(id: 'melons', name: 'Melons'),
  Crop(id: 'wheat', name: 'Wheat'),
];

const List<PhaseTemplate> _fallbackTemplates = [
  PhaseTemplate(
    id: 'start',
    name: 'Start of vegetation',
    dayOffset: 0,
    defaultEnabled: true,
  ),
  PhaseTemplate(
    id: 'mid',
    name: 'Mid season',
    dayOffset: 14,
    defaultEnabled: true,
  ),
  PhaseTemplate(
    id: 'finish',
    name: 'Harvest prep',
    dayOffset: 28,
    defaultEnabled: true,
  ),
];

const Map<String, List<PhaseTemplate>> _fallbackPhaseTemplatesByCrop = {
  'apricot': _fallbackTemplates,
  'melons': _fallbackTemplates,
  'wheat': _fallbackTemplates,
};

const List<Product> _fallbackProducts = [
  Product(
    id: 'normat-l',
    name: 'Normat L',
    form: ProductForm.liquid,
    unit: ProductUnit.liters,
  ),
  Product(
    id: 'normat-c',
    name: 'Normat C',
    form: ProductForm.dry,
    unit: ProductUnit.kilograms,
  ),
];
