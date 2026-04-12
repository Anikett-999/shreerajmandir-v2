// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TableModel _$TableModelFromJson(Map<String, dynamic> json) {
  return _TableModel.fromJson(json);
}

/// @nodoc
mixin _$TableModel {
  String get tableId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // available | occupied | billing
  String? get activeOrderId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get kotCount => throw _privateConstructorUsedError;
  int get unprintedKotCount => throw _privateConstructorUsedError;
  @OptionalTimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TableModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableModelCopyWith<TableModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableModelCopyWith<$Res> {
  factory $TableModelCopyWith(
    TableModel value,
    $Res Function(TableModel) then,
  ) = _$TableModelCopyWithImpl<$Res, TableModel>;
  @useResult
  $Res call({
    String tableId,
    String name,
    int capacity,
    String status,
    String? activeOrderId,
    double totalAmount,
    int itemCount,
    int kotCount,
    int unprintedKotCount,
    @OptionalTimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$TableModelCopyWithImpl<$Res, $Val extends TableModel>
    implements $TableModelCopyWith<$Res> {
  _$TableModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableId = null,
    Object? name = null,
    Object? capacity = null,
    Object? status = null,
    Object? activeOrderId = freezed,
    Object? totalAmount = null,
    Object? itemCount = null,
    Object? kotCount = null,
    Object? unprintedKotCount = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            tableId: null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            activeOrderId: freezed == activeOrderId
                ? _value.activeOrderId
                : activeOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            kotCount: null == kotCount
                ? _value.kotCount
                : kotCount // ignore: cast_nullable_to_non_nullable
                      as int,
            unprintedKotCount: null == unprintedKotCount
                ? _value.unprintedKotCount
                : unprintedKotCount // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TableModelImplCopyWith<$Res>
    implements $TableModelCopyWith<$Res> {
  factory _$$TableModelImplCopyWith(
    _$TableModelImpl value,
    $Res Function(_$TableModelImpl) then,
  ) = __$$TableModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tableId,
    String name,
    int capacity,
    String status,
    String? activeOrderId,
    double totalAmount,
    int itemCount,
    int kotCount,
    int unprintedKotCount,
    @OptionalTimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TableModelImplCopyWithImpl<$Res>
    extends _$TableModelCopyWithImpl<$Res, _$TableModelImpl>
    implements _$$TableModelImplCopyWith<$Res> {
  __$$TableModelImplCopyWithImpl(
    _$TableModelImpl _value,
    $Res Function(_$TableModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableId = null,
    Object? name = null,
    Object? capacity = null,
    Object? status = null,
    Object? activeOrderId = freezed,
    Object? totalAmount = null,
    Object? itemCount = null,
    Object? kotCount = null,
    Object? unprintedKotCount = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$TableModelImpl(
        tableId: null == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        activeOrderId: freezed == activeOrderId
            ? _value.activeOrderId
            : activeOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        kotCount: null == kotCount
            ? _value.kotCount
            : kotCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unprintedKotCount: null == unprintedKotCount
            ? _value.unprintedKotCount
            : unprintedKotCount // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TableModelImpl implements _TableModel {
  const _$TableModelImpl({
    required this.tableId,
    this.name = 'Unknown',
    this.capacity = 1,
    this.status = 'available',
    this.activeOrderId,
    this.totalAmount = 0.0,
    this.itemCount = 0,
    this.kotCount = 0,
    this.unprintedKotCount = 0,
    @OptionalTimestampConverter() this.updatedAt,
  });

  factory _$TableModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableModelImplFromJson(json);

  @override
  final String tableId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey()
  final String status;
  // available | occupied | billing
  @override
  final String? activeOrderId;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final int itemCount;
  @override
  @JsonKey()
  final int kotCount;
  @override
  @JsonKey()
  final int unprintedKotCount;
  @override
  @OptionalTimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TableModel(tableId: $tableId, name: $name, capacity: $capacity, status: $status, activeOrderId: $activeOrderId, totalAmount: $totalAmount, itemCount: $itemCount, kotCount: $kotCount, unprintedKotCount: $unprintedKotCount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableModelImpl &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.activeOrderId, activeOrderId) ||
                other.activeOrderId == activeOrderId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.kotCount, kotCount) ||
                other.kotCount == kotCount) &&
            (identical(other.unprintedKotCount, unprintedKotCount) ||
                other.unprintedKotCount == unprintedKotCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tableId,
    name,
    capacity,
    status,
    activeOrderId,
    totalAmount,
    itemCount,
    kotCount,
    unprintedKotCount,
    updatedAt,
  );

  /// Create a copy of TableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableModelImplCopyWith<_$TableModelImpl> get copyWith =>
      __$$TableModelImplCopyWithImpl<_$TableModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableModelImplToJson(this);
  }
}

abstract class _TableModel implements TableModel {
  const factory _TableModel({
    required final String tableId,
    final String name,
    final int capacity,
    final String status,
    final String? activeOrderId,
    final double totalAmount,
    final int itemCount,
    final int kotCount,
    final int unprintedKotCount,
    @OptionalTimestampConverter() final DateTime? updatedAt,
  }) = _$TableModelImpl;

  factory _TableModel.fromJson(Map<String, dynamic> json) =
      _$TableModelImpl.fromJson;

  @override
  String get tableId;
  @override
  String get name;
  @override
  int get capacity;
  @override
  String get status; // available | occupied | billing
  @override
  String? get activeOrderId;
  @override
  double get totalAmount;
  @override
  int get itemCount;
  @override
  int get kotCount;
  @override
  int get unprintedKotCount;
  @override
  @OptionalTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of TableModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableModelImplCopyWith<_$TableModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
