// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KOTItemImpl _$$KOTItemImplFromJson(Map<String, dynamic> json) =>
    _$KOTItemImpl(
      uniqueId: json['uniqueId'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      qty: (json['qty'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      variant: json['variant'] as String? ?? '',
      note: json['note'] as String? ?? '',
      status: json['status'] as String? ?? 'placed',
    );

Map<String, dynamic> _$$KOTItemImplToJson(_$KOTItemImpl instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'itemId': instance.itemId,
      'name': instance.name,
      'category': instance.category,
      'qty': instance.qty,
      'price': instance.price,
      'variant': instance.variant,
      'note': instance.note,
      'status': instance.status,
    };

_$KOTModelImpl _$$KOTModelImplFromJson(Map<String, dynamic> json) =>
    _$KOTModelImpl(
      kotId: json['kotId'] as String,
      kotNumber: (json['kotNumber'] as num).toInt(),
      orderId: json['orderId'] as String,
      tableId: json['tableId'] as String,
      tableName: json['tableName'] as String? ?? '',
      items: (json['items'] as List<dynamic>)
          .map((e) => KOTItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      isPrinted: json['isPrinted'] as bool? ?? false,
      createdBy: json['createdBy'] as String,
      userName: json['userName'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$KOTModelImplToJson(_$KOTModelImpl instance) =>
    <String, dynamic>{
      'kotId': instance.kotId,
      'kotNumber': instance.kotNumber,
      'orderId': instance.orderId,
      'tableId': instance.tableId,
      'tableName': instance.tableName,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalAmount': instance.totalAmount,
      'isPrinted': instance.isPrinted,
      'createdBy': instance.createdBy,
      'userName': instance.userName,
      'createdAt': instance.createdAt.toIso8601String(),
    };
