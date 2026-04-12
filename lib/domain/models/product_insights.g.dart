// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductInsightsImpl _$$ProductInsightsImplFromJson(
  Map<String, dynamic> json,
) => _$ProductInsightsImpl(
  topSellers:
      (json['topSellers'] as List<dynamic>?)
          ?.map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  leastSellers:
      (json['leastSellers'] as List<dynamic>?)
          ?.map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  categoryPerformance:
      (json['categoryPerformance'] as List<dynamic>?)
          ?.map((e) => CategoryPerformance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
  totalItemsSold: (json['totalItemsSold'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ProductInsightsImplToJson(
  _$ProductInsightsImpl instance,
) => <String, dynamic>{
  'topSellers': instance.topSellers.map((e) => e.toJson()).toList(),
  'leastSellers': instance.leastSellers.map((e) => e.toJson()).toList(),
  'categoryPerformance': instance.categoryPerformance
      .map((e) => e.toJson())
      .toList(),
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'totalRevenue': instance.totalRevenue,
  'totalItemsSold': instance.totalItemsSold,
};

_$CategoryPerformanceImpl _$$CategoryPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryPerformanceImpl(
  categoryName: json['categoryName'] as String,
  revenue: (json['revenue'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  contributionPercentage:
      (json['contributionPercentage'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$CategoryPerformanceImplToJson(
  _$CategoryPerformanceImpl instance,
) => <String, dynamic>{
  'categoryName': instance.categoryName,
  'revenue': instance.revenue,
  'quantity': instance.quantity,
  'contributionPercentage': instance.contributionPercentage,
};
