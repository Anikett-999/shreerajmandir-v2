// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'order': instance.order,
    };
