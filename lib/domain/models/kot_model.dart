import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'kot_model.freezed.dart';
part 'kot_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime date) => date.toIso8601String();
}

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
