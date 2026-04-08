// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
  itemId: json['itemId'] as String,
  name: json['name'] as String,
  categoryId: json['categoryId'] as String,
  groupName: json['groupName'] as String? ?? '',
  price: (json['price'] as num).toDouble(),
  variants:
      (json['variants'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'groupName': instance.groupName,
      'price': instance.price,
      'variants': instance.variants,
      'isAvailable': instance.isAvailable,
    };
