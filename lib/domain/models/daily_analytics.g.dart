// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyAnalyticsImpl _$$DailyAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$DailyAnalyticsImpl(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalBills: (json['totalBills'] as num?)?.toInt() ?? 0,
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0.0,
      extraCharges: (json['extraCharges'] as num?)?.toDouble() ?? 0.0,
      itemStats:
          (json['itemStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, ItemStat.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      hourlyStats:
          (json['hourlyStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, HourStat.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      paymentStats:
          (json['paymentStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {'cash': 0.0, 'upi': 0.0, 'card': 0.0},
      categoryStats:
          (json['categoryStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      deliveryMethodsStats:
          (json['deliveryMethodsStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      userStats:
          (json['userStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$DailyAnalyticsImplToJson(
  _$DailyAnalyticsImpl instance,
) => <String, dynamic>{
  'totalSales': instance.totalSales,
  'totalBills': instance.totalBills,
  'totalDiscount': instance.totalDiscount,
  'extraCharges': instance.extraCharges,
  'itemStats': instance.itemStats.map((k, e) => MapEntry(k, e.toJson())),
  'hourlyStats': instance.hourlyStats.map((k, e) => MapEntry(k, e.toJson())),
  'paymentStats': instance.paymentStats,
  'categoryStats': instance.categoryStats,
  'deliveryMethodsStats': instance.deliveryMethodsStats,
  'userStats': instance.userStats,
};

_$ItemStatImpl _$$ItemStatImplFromJson(Map<String, dynamic> json) =>
    _$ItemStatImpl(
      name: json['name'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ItemStatImplToJson(_$ItemStatImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qty': instance.qty,
      'revenue': instance.revenue,
    };

_$HourStatImpl _$$HourStatImplFromJson(Map<String, dynamic> json) =>
    _$HourStatImpl(
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      orders: (json['orders'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HourStatImplToJson(_$HourStatImpl instance) =>
    <String, dynamic>{'sales': instance.sales, 'orders': instance.orders};
