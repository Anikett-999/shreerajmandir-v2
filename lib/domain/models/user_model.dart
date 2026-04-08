import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserRole with _$UserRole {
  const factory UserRole({
    required String branchId,
    required String role, // admin | cashier | waiter
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String userId,
    required String name,
    required String email,
    required List<UserRole> roles,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
