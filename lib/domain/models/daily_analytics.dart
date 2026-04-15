import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_analytics.freezed.dart';
part 'daily_analytics.g.dart';

@freezed
class DailyAnalytics with _$DailyAnalytics {
  const factory DailyAnalytics({
    @Default(0.0) double totalSales,
    @Default(0) int totalBills,
    @Default(0.0) double totalDiscount,
    @Default({}) Map<String, ItemStat> itemStats,
    @Default({}) Map<String, HourStat> hourlyStats,
    @Default({'cash': 0.0, 'upi': 0.0, 'card': 0.0}) Map<String, double> paymentStats,
  }) = _DailyAnalytics;

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) => _$DailyAnalyticsFromJson(json);

  // Helper to merge two analytics objects (used for range reports)
  factory DailyAnalytics.merge(DailyAnalytics a, DailyAnalytics b) {
    // Merge Item Stats
    final mergedItemStats = Map<String, ItemStat>.from(a.itemStats);
    b.itemStats.forEach((name, stat) {
      final existing = mergedItemStats[name];
      if (existing != null) {
        mergedItemStats[name] = ItemStat(
          name: existing.name,
          qty: existing.qty + stat.qty,
          revenue: existing.revenue + stat.revenue,
        );
      } else {
        mergedItemStats[name] = stat;
      }
    });

    // Merge Hourly Stats
    final mergedHourlyStats = Map<String, HourStat>.from(a.hourlyStats);
    b.hourlyStats.forEach((hour, stat) {
      final existing = mergedHourlyStats[hour];
      if (existing != null) {
        mergedHourlyStats[hour] = HourStat(
          sales: existing.sales + stat.sales,
          orders: existing.orders + stat.orders,
        );
      } else {
        mergedHourlyStats[hour] = stat;
      }
    });

    // Merge Payment Stats
    final mergedPaymentStats = Map<String, double>.from(a.paymentStats);
    b.paymentStats.forEach((mode, amount) {
      mergedPaymentStats[mode] = (mergedPaymentStats[mode] ?? 0.0) + amount;
    });

    return DailyAnalytics(
      totalSales: a.totalSales + b.totalSales,
      totalBills: a.totalBills + b.totalBills,
      totalDiscount: a.totalDiscount + b.totalDiscount,
      itemStats: mergedItemStats,
      hourlyStats: mergedHourlyStats,
      paymentStats: mergedPaymentStats,
    );
  }
}

@freezed
class ItemStat with _$ItemStat {
  const factory ItemStat({
    @Default('') String name,
    @Default(0) int qty,
    @Default(0.0) double revenue,
  }) = _ItemStat;

  factory ItemStat.fromJson(Map<String, dynamic> json) => _$ItemStatFromJson(json);
}

@freezed
class HourStat with _$HourStat {
  const factory HourStat({
    @Default(0.0) double sales,
    @Default(0) int orders,
  }) = _HourStat;

  factory HourStat.fromJson(Map<String, dynamic> json) => _$HourStatFromJson(json);
}
