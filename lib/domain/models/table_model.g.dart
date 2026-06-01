// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableModelImpl _$$TableModelImplFromJson(Map<String, dynamic> json) =>
    _$TableModelImpl(
      tableId: json['tableId'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      status: json['status'] as String? ?? 'available',
      activeOrderId: json['activeOrderId'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      kotCount: (json['kotCount'] as num?)?.toInt() ?? 0,
      unprintedKotCount: (json['unprintedKotCount'] as num?)?.toInt() ?? 0,
      updatedAt: const OptionalTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$TableModelImplToJson(
  _$TableModelImpl instance,
) => <String, dynamic>{
  'tableId': instance.tableId,
  'name': instance.name,
  'capacity': instance.capacity,
  'status': instance.status,
  'activeOrderId': instance.activeOrderId,
  'totalAmount': instance.totalAmount,
  'itemCount': instance.itemCount,
  'kotCount': instance.kotCount,
  'unprintedKotCount': instance.unprintedKotCount,
  'updatedAt': const OptionalTimestampConverter().toJson(instance.updatedAt),
};
