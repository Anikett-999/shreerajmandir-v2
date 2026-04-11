import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/timestamp_converter.dart';

part 'kot_model.freezed.dart';
part 'kot_model.g.dart';

@freezed
class KOTItem with _$KOTItem {
  const factory KOTItem({
    required String uniqueId,
    required String itemId,
    required String name,
    required String category,
    required int qty,
    required double price,
    @Default('') String variant,
    @Default('') String note,
    @Default('placed') String status, // placed | served
  }) = _KOTItem;

  factory KOTItem.fromJson(Map<String, dynamic> json) => _$KOTItemFromJson(json);
}

@freezed
class KOTModel with _$KOTModel {
  const factory KOTModel({
    required String kotId,
    required int kotNumber,
    required String orderId,
    required String tableId,
    @Default('') String tableName,
    required List<KOTItem> items,
    @Default(0.0) double totalAmount,
    @Default(false) bool isPrinted,
    required String createdBy,
    @Default('') String userName,
    @TimestampConverter() required DateTime createdAt,
  }) = _KOTModel;

  factory KOTModel.fromJson(Map<String, dynamic> json) => _$KOTModelFromJson(json);
}
