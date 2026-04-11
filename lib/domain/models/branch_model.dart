import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

@freezed
class BranchModel with _$BranchModel {
  const factory BranchModel({
    @Default('') String branchId,
    @Default('') String branchName,
    @Default('') String location,
    @Default('') String address,
    @Default('') String phone,
    @Default(true) bool isActive,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
}
