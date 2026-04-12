// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopCategoryImpl _$$TopCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TopCategoryImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopCategoryImplToJson(_$TopCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'revenue': instance.revenue,
    };

_$ProductInsightsImpl _$$ProductInsightsImplFromJson(
  Map<String, dynamic> json,
) => _$ProductInsightsImpl(
  topItems: (json['topItems'] as List<dynamic>)
      .map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  topCategories: (json['topCategories'] as List<dynamic>)
      .map((e) => TopCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$ProductInsightsImplToJson(
  _$ProductInsightsImpl instance,
) => <String, dynamic>{
  'topItems': instance.topItems.map((e) => e.toJson()).toList(),
  'topCategories': instance.topCategories.map((e) => e.toJson()).toList(),
  'totalQuantity': instance.totalQuantity,
  'totalRevenue': instance.totalRevenue,
};
