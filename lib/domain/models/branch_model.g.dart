// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BranchModelImpl _$$BranchModelImplFromJson(Map<String, dynamic> json) =>
    _$BranchModelImpl(
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$BranchModelImplToJson(_$BranchModelImpl instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'location': instance.location,
      'address': instance.address,
      'phone': instance.phone,
      'isActive': instance.isActive,
    };
