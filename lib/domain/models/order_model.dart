import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/timestamp_converter.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String orderId,
    required String tableId,
    @Default('active') String status, // active | closed
    @Default([]) List<String> kotIds,
    @OptionalTimestampConverter() DateTime? createdAt,
    @OptionalTimestampConverter() DateTime? closedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}
