import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0.0) double totalRevenue,
    @Default(0.0) double grossSales,
    @Default(0.0) double totalDiscounts,
    @Default(0) int totalOrders,
    @Default(0.0) double avgOrderValue,
    @Default(0.0) double revenueTrend,
    @Default(0.0) double ordersTrend,
    @Default([]) List<HourlySales> hourlySales,
    @Default({}) Map<String, double> paymentSplit,
    @Default(0) int activeTables,
    @Default(0) int pendingKots,
    @Default([]) List<TopProduct> topProducts,
    @Default([]) List<SuspiciousBill> suspiciousBills,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@freezed
class HourlySales with _$HourlySales {
  const factory HourlySales({
    required int hour,
    required double revenue,
  }) = _HourlySales;

  factory HourlySales.fromJson(Map<String, dynamic> json) => _$HourlySalesFromJson(json);
}

@freezed
class TopProduct with _$TopProduct {
  const factory TopProduct({
    required String name,
    required int quantity,
    required double revenue,
  }) = _TopProduct;

  factory TopProduct.fromJson(Map<String, dynamic> json) => _$TopProductFromJson(json);
}

@freezed
class SuspiciousBill with _$SuspiciousBill {
  const factory SuspiciousBill({
    required String billId,
    required int printCount,
    required String tableId,
    required double total,
    required DateTime createdAt,
  }) = _SuspiciousBill;

  factory SuspiciousBill.fromJson(Map<String, dynamic> json) => _$SuspiciousBillFromJson(json);
}
