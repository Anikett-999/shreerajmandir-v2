import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String itemId,
    required String name,
    required String categoryId,
    @Default('') String groupName,
    required double price,
    @Default([]) List<String> variants,
    @Default(true) bool isAvailable,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
