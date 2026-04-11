// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      orderId: json['orderId'] as String,
      tableId: json['tableId'] as String,
      status: json['status'] as String? ?? 'active',
      kotIds:
          (json['kotIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const OptionalTimestampConverter().fromJson(json['createdAt']),
      closedAt: const OptionalTimestampConverter().fromJson(json['closedAt']),
    );

Map<String, dynamic> _$$OrderModelImplToJson(
  _$OrderModelImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'tableId': instance.tableId,
  'status': instance.status,
  'kotIds': instance.kotIds,
  'createdAt': const OptionalTimestampConverter().toJson(instance.createdAt),
  'closedAt': const OptionalTimestampConverter().toJson(instance.closedAt),
};
