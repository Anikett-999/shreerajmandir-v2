// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      grossSales: (json['grossSales'] as num?)?.toDouble() ?? 0.0,
      totalDiscounts: (json['totalDiscounts'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      avgOrderValue: (json['avgOrderValue'] as num?)?.toDouble() ?? 0.0,
      revenueTrend: (json['revenueTrend'] as num?)?.toDouble() ?? 0.0,
      ordersTrend: (json['ordersTrend'] as num?)?.toDouble() ?? 0.0,
      hourlySales:
          (json['hourlySales'] as List<dynamic>?)
              ?.map((e) => HourlySales.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentSplit:
          (json['paymentSplit'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      activeTables: (json['activeTables'] as num?)?.toInt() ?? 0,
      pendingKots: (json['pendingKots'] as num?)?.toInt() ?? 0,
      topProducts:
          (json['topProducts'] as List<dynamic>?)
              ?.map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suspiciousBills:
          (json['suspiciousBills'] as List<dynamic>?)
              ?.map((e) => SuspiciousBill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'totalRevenue': instance.totalRevenue,
  'grossSales': instance.grossSales,
  'totalDiscounts': instance.totalDiscounts,
  'totalOrders': instance.totalOrders,
  'avgOrderValue': instance.avgOrderValue,
  'revenueTrend': instance.revenueTrend,
  'ordersTrend': instance.ordersTrend,
  'hourlySales': instance.hourlySales.map((e) => e.toJson()).toList(),
  'paymentSplit': instance.paymentSplit,
  'activeTables': instance.activeTables,
  'pendingKots': instance.pendingKots,
  'topProducts': instance.topProducts.map((e) => e.toJson()).toList(),
  'suspiciousBills': instance.suspiciousBills.map((e) => e.toJson()).toList(),
};

_$HourlySalesImpl _$$HourlySalesImplFromJson(Map<String, dynamic> json) =>
    _$HourlySalesImpl(
      hour: (json['hour'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$HourlySalesImplToJson(_$HourlySalesImpl instance) =>
    <String, dynamic>{'hour': instance.hour, 'revenue': instance.revenue};

_$TopProductImpl _$$TopProductImplFromJson(Map<String, dynamic> json) =>
    _$TopProductImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopProductImplToJson(_$TopProductImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'revenue': instance.revenue,
    };

_$SuspiciousBillImpl _$$SuspiciousBillImplFromJson(Map<String, dynamic> json) =>
    _$SuspiciousBillImpl(
      billId: json['billId'] as String,
      printCount: (json['printCount'] as num).toInt(),
      tableId: json['tableId'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SuspiciousBillImplToJson(
  _$SuspiciousBillImpl instance,
) => <String, dynamic>{
  'billId': instance.billId,
  'printCount': instance.printCount,
  'tableId': instance.tableId,
  'total': instance.total,
  'createdAt': instance.createdAt.toIso8601String(),
};
