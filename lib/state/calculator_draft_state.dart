import 'package:ligno_yiled/models/crop_input.dart';

class CalculatorDraftState {
  static const _unset = Object();

  const CalculatorDraftState({
    this.cropId,
    this.cropName,
    this.areaHa,
    this.startDate,
    this.soilType,
    this.schemeType,
    this.region,
  });

  final String? cropId;
  final String? cropName;
  final double? areaHa;
  final DateTime? startDate;
  final SoilType? soilType;
  final String? schemeType;
  final String? region;

  CalculatorDraftState copyWith({
    Object? cropId = _unset,
    Object? cropName = _unset,
    Object? areaHa = _unset,
    Object? startDate = _unset,
    Object? soilType = _unset,
    Object? schemeType = _unset,
    Object? region = _unset,
  }) {
    return CalculatorDraftState(
      cropId: cropId == _unset ? this.cropId : cropId as String?,
      cropName: cropName == _unset ? this.cropName : cropName as String?,
      areaHa: areaHa == _unset ? this.areaHa : areaHa as double?,
      startDate:
          startDate == _unset ? this.startDate : startDate as DateTime?,
      soilType: soilType == _unset ? this.soilType : soilType as SoilType?,
      schemeType:
          schemeType == _unset ? this.schemeType : schemeType as String?,
      region: region == _unset ? this.region : region as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'cropName': cropName,
      'areaHa': areaHa,
      'startDate': startDate?.toIso8601String(),
      'soilType': soilType?.name,
      'schemeType': schemeType,
      'region': region,
    };
  }

  factory CalculatorDraftState.fromJson(Map<String, dynamic> json) {
    final startDateRaw = json['startDate'];
    final soilTypeRaw = json['soilType'];
    SoilType? parsedSoilType;
    if (soilTypeRaw is String) {
      for (final type in SoilType.values) {
        if (type.name == soilTypeRaw) {
          parsedSoilType = type;
          break;
        }
      }
    }
    return CalculatorDraftState(
      cropId: json['cropId'] as String?,
      cropName: json['cropName'] as String?,
      areaHa: (json['areaHa'] is num)
          ? (json['areaHa'] as num).toDouble()
          : null,
      startDate: startDateRaw is String
          ? DateTime.tryParse(startDateRaw)
          : null,
      soilType: parsedSoilType,
      schemeType: json['schemeType'] as String?,
      region: json['region'] as String?,
    );
  }
}
