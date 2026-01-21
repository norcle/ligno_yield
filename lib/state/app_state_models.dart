import 'package:flutter/material.dart';
import 'package:ligno_yiled/models/crop.dart';
import 'package:ligno_yiled/models/crop_input.dart';

@immutable
class AppLocaleState {
  const AppLocaleState({required this.locale});

  final Locale locale;

  AppLocaleState copyWith({Locale? locale}) {
    return AppLocaleState(locale: locale ?? this.locale);
  }
}

@immutable
class CalculatorDraftState {
  const CalculatorDraftState({
    this.crop,
    this.areaHa,
    this.startDate,
    this.soilType,
    this.schemeType,
    this.region,
  });

  final Crop? crop;
  final double? areaHa;
  final DateTime? startDate;
  final SoilType? soilType;
  final String? schemeType;
  final String? region;

  CalculatorDraftState copyWith({
    Crop? crop,
    double? areaHa,
    DateTime? startDate,
    SoilType? soilType,
    String? schemeType,
    String? region,
    bool clearCrop = false,
    bool clearAreaHa = false,
    bool clearStartDate = false,
    bool clearSoilType = false,
    bool clearSchemeType = false,
    bool clearRegion = false,
  }) {
    return CalculatorDraftState(
      crop: clearCrop ? null : (crop ?? this.crop),
      areaHa: clearAreaHa ? null : (areaHa ?? this.areaHa),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      soilType: clearSoilType ? null : (soilType ?? this.soilType),
      schemeType: clearSchemeType ? null : (schemeType ?? this.schemeType),
      region: clearRegion ? null : (region ?? this.region),
    );
  }

  static CalculatorDraftState fromJson(Map<String, Object?> json) {
    final crop = json['cropId'] is String && json['cropName'] is String
        ? Crop(
            id: json['cropId']! as String,
            name: json['cropName']! as String,
          )
        : null;
    final soilType = json['soilType'] is String
        ? SoilType.values.firstWhere(
            (soil) => soil.name == json['soilType'],
            orElse: () => SoilType.openField,
          )
        : null;
    final startDate = json['startDate'] is String
        ? DateTime.tryParse(json['startDate']! as String)
        : null;

    return CalculatorDraftState(
      crop: crop,
      areaHa: (json['areaHa'] as num?)?.toDouble(),
      startDate: startDate,
      soilType: json['soilType'] == null ? null : soilType,
      schemeType: json['schemeType'] as String?,
      region: json['region'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cropId': crop?.id,
      'cropName': crop?.name,
      'areaHa': areaHa,
      'startDate': startDate?.toIso8601String(),
      'soilType': soilType?.name,
      'schemeType': schemeType,
      'region': region,
    };
  }
}
