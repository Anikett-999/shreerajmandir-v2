import 'package:freezed_annotation/freezed_annotation.dart';
import 'dashboard_stats.dart';

part 'product_insights.freezed.dart';
part 'product_insights.g.dart';

@freezed
class TopCategory with _$TopCategory {
  const factory TopCategory({
    required String name,
    required int quantity,
    required double revenue,
  }) = _TopCategory;

  factory TopCategory.fromJson(Map<String, dynamic> json) => _$TopCategoryFromJson(json);
}

@freezed
class ProductInsights with _$ProductInsights {
  const factory ProductInsights({
    required List<TopProduct> topItems,
    required List<TopCategory> topCategories,
    @Default(0) int totalQuantity,
    @Default(0.0) double totalRevenue,
  }) = _ProductInsights;

  factory ProductInsights.fromJson(Map<String, dynamic> json) => _$ProductInsightsFromJson(json);
}
