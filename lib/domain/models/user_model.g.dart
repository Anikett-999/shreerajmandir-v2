// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleImpl _$$UserRoleImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleImpl(
      branchId: json['branchId'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$UserRoleImplToJson(_$UserRoleImpl instance) =>
    <String, dynamic>{'branchId': instance.branchId, 'role': instance.role};

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'roles': instance.roles,
    };
