import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/timestamp_converter.dart';

part 'table_model.freezed.dart';
part 'table_model.g.dart';

@freezed
class TableModel with _$TableModel {
  const factory TableModel({
    required String tableId,
    required String name,
    required int capacity,
    @Default('available') String status, // available | occupied | billing
    String? activeOrderId,
    @Default(0.0) double totalAmount,
    @Default(0) int itemCount,
    @Default(0) int kotCount,
    @Default(0) int unprintedKotCount,
    @OptionalTimestampConverter() DateTime? updatedAt,
  }) = _TableModel;

  factory TableModel.fromJson(Map<String, dynamic> json) => _$TableModelFromJson(json);
}
