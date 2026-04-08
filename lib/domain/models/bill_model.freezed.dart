// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillItem _$BillItemFromJson(Map<String, dynamic> json) {
  return _BillItem.fromJson(json);
}

/// @nodoc
mixin _$BillItem {
  String get name => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;

  /// Serializes this BillItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillItemCopyWith<BillItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillItemCopyWith<$Res> {
  factory $BillItemCopyWith(BillItem value, $Res Function(BillItem) then) =
      _$BillItemCopyWithImpl<$Res, BillItem>;
  @useResult
  $Res call({String name, int qty, double price, String note});
}

/// @nodoc
class _$BillItemCopyWithImpl<$Res, $Val extends BillItem>
    implements $BillItemCopyWith<$Res> {
  _$BillItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qty = null,
    Object? price = null,
    Object? note = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            note: null == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillItemImplCopyWith<$Res>
    implements $BillItemCopyWith<$Res> {
  factory _$$BillItemImplCopyWith(
    _$BillItemImpl value,
    $Res Function(_$BillItemImpl) then,
  ) = __$$BillItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int qty, double price, String note});
}

/// @nodoc
class __$$BillItemImplCopyWithImpl<$Res>
    extends _$BillItemCopyWithImpl<$Res, _$BillItemImpl>
    implements _$$BillItemImplCopyWith<$Res> {
  __$$BillItemImplCopyWithImpl(
    _$BillItemImpl _value,
    $Res Function(_$BillItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qty = null,
    Object? price = null,
    Object? note = null,
  }) {
    return _then(
      _$BillItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        note: null == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillItemImpl implements _BillItem {
  const _$BillItemImpl({
    required this.name,
    required this.qty,
    required this.price,
    this.note = '',
  });

  factory _$BillItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillItemImplFromJson(json);

  @override
  final String name;
  @override
  final int qty;
  @override
  final double price;
  @override
  @JsonKey()
  final String note;

  @override
  String toString() {
    return 'BillItem(name: $name, qty: $qty, price: $price, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, qty, price, note);

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      __$$BillItemImplCopyWithImpl<_$BillItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillItemImplToJson(this);
  }
}

abstract class _BillItem implements BillItem {
  const factory _BillItem({
    required final String name,
    required final int qty,
    required final double price,
    final String note,
  }) = _$BillItemImpl;

  factory _BillItem.fromJson(Map<String, dynamic> json) =
      _$BillItemImpl.fromJson;

  @override
  String get name;
  @override
  int get qty;
  @override
  double get price;
  @override
  String get note;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String get mode => throw _privateConstructorUsedError; // cash | upi | card
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({String mode, double amount});
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mode, double amount});
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null, Object? amount = null}) {
    return _then(
      _$PaymentImpl(
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({required this.mode, required this.amount});

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String mode;
  // cash | upi | card
  @override
  final double amount;

  @override
  String toString() {
    return 'Payment(mode: $mode, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mode, amount);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    required final String mode,
    required final double amount,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String get mode; // cash | upi | card
  @override
  double get amount;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillModel _$BillModelFromJson(Map<String, dynamic> json) {
  return _BillModel.fromJson(json);
}

/// @nodoc
mixin _$BillModel {
  String get billId => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  List<BillItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get extraCharges => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  List<Payment> get payments => throw _privateConstructorUsedError;
  int get printCount => throw _privateConstructorUsedError;
  bool get isSuspicious => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get printedAt => throw _privateConstructorUsedError;
  String? get lastPrintedBy => throw _privateConstructorUsedError;

  /// Serializes this BillModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillModelCopyWith<BillModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillModelCopyWith<$Res> {
  factory $BillModelCopyWith(BillModel value, $Res Function(BillModel) then) =
      _$BillModelCopyWithImpl<$Res, BillModel>;
  @useResult
  $Res call({
    String billId,
    String orderId,
    String tableId,
    List<BillItem> items,
    double subtotal,
    double discountPercent,
    double discountAmount,
    double extraCharges,
    double total,
    List<Payment> payments,
    int printCount,
    bool isSuspicious,
    String createdBy,
    DateTime createdAt,
    DateTime? printedAt,
    String? lastPrintedBy,
  });
}

/// @nodoc
class _$BillModelCopyWithImpl<$Res, $Val extends BillModel>
    implements $BillModelCopyWith<$Res> {
  _$BillModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billId = null,
    Object? orderId = null,
    Object? tableId = null,
    Object? items = null,
    Object? subtotal = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? extraCharges = null,
    Object? total = null,
    Object? payments = null,
    Object? printCount = null,
    Object? isSuspicious = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? printedAt = freezed,
    Object? lastPrintedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            billId: null == billId
                ? _value.billId
                : billId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            tableId: null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<BillItem>,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            discountPercent: null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            extraCharges: null == extraCharges
                ? _value.extraCharges
                : extraCharges // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<Payment>,
            printCount: null == printCount
                ? _value.printCount
                : printCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isSuspicious: null == isSuspicious
                ? _value.isSuspicious
                : isSuspicious // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            printedAt: freezed == printedAt
                ? _value.printedAt
                : printedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastPrintedBy: freezed == lastPrintedBy
                ? _value.lastPrintedBy
                : lastPrintedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillModelImplCopyWith<$Res>
    implements $BillModelCopyWith<$Res> {
  factory _$$BillModelImplCopyWith(
    _$BillModelImpl value,
    $Res Function(_$BillModelImpl) then,
  ) = __$$BillModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billId,
    String orderId,
    String tableId,
    List<BillItem> items,
    double subtotal,
    double discountPercent,
    double discountAmount,
    double extraCharges,
    double total,
    List<Payment> payments,
    int printCount,
    bool isSuspicious,
    String createdBy,
    DateTime createdAt,
    DateTime? printedAt,
    String? lastPrintedBy,
  });
}

/// @nodoc
class __$$BillModelImplCopyWithImpl<$Res>
    extends _$BillModelCopyWithImpl<$Res, _$BillModelImpl>
    implements _$$BillModelImplCopyWith<$Res> {
  __$$BillModelImplCopyWithImpl(
    _$BillModelImpl _value,
    $Res Function(_$BillModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billId = null,
    Object? orderId = null,
    Object? tableId = null,
    Object? items = null,
    Object? subtotal = null,
    Object? discountPercent = null,
    Object? discountAmount = null,
    Object? extraCharges = null,
    Object? total = null,
    Object? payments = null,
    Object? printCount = null,
    Object? isSuspicious = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? printedAt = freezed,
    Object? lastPrintedBy = freezed,
  }) {
    return _then(
      _$BillModelImpl(
        billId: null == billId
            ? _value.billId
            : billId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        tableId: null == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<BillItem>,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        discountPercent: null == discountPercent
            ? _value.discountPercent
            : discountPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        extraCharges: null == extraCharges
            ? _value.extraCharges
            : extraCharges // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<Payment>,
        printCount: null == printCount
            ? _value.printCount
            : printCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isSuspicious: null == isSuspicious
            ? _value.isSuspicious
            : isSuspicious // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        printedAt: freezed == printedAt
            ? _value.printedAt
            : printedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastPrintedBy: freezed == lastPrintedBy
            ? _value.lastPrintedBy
            : lastPrintedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillModelImpl implements _BillModel {
  const _$BillModelImpl({
    required this.billId,
    required this.orderId,
    required this.tableId,
    required final List<BillItem> items,
    required this.subtotal,
    this.discountPercent = 0.0,
    this.discountAmount = 0.0,
    this.extraCharges = 0.0,
    required this.total,
    required final List<Payment> payments,
    this.printCount = 1,
    this.isSuspicious = false,
    required this.createdBy,
    required this.createdAt,
    this.printedAt,
    this.lastPrintedBy,
  }) : _items = items,
       _payments = payments;

  factory _$BillModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillModelImplFromJson(json);

  @override
  final String billId;
  @override
  final String orderId;
  @override
  final String tableId;
  final List<BillItem> _items;
  @override
  List<BillItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double subtotal;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double extraCharges;
  @override
  final double total;
  final List<Payment> _payments;
  @override
  List<Payment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey()
  final int printCount;
  @override
  @JsonKey()
  final bool isSuspicious;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? printedAt;
  @override
  final String? lastPrintedBy;

  @override
  String toString() {
    return 'BillModel(billId: $billId, orderId: $orderId, tableId: $tableId, items: $items, subtotal: $subtotal, discountPercent: $discountPercent, discountAmount: $discountAmount, extraCharges: $extraCharges, total: $total, payments: $payments, printCount: $printCount, isSuspicious: $isSuspicious, createdBy: $createdBy, createdAt: $createdAt, printedAt: $printedAt, lastPrintedBy: $lastPrintedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillModelImpl &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.extraCharges, extraCharges) ||
                other.extraCharges == extraCharges) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.printCount, printCount) ||
                other.printCount == printCount) &&
            (identical(other.isSuspicious, isSuspicious) ||
                other.isSuspicious == isSuspicious) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.printedAt, printedAt) ||
                other.printedAt == printedAt) &&
            (identical(other.lastPrintedBy, lastPrintedBy) ||
                other.lastPrintedBy == lastPrintedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billId,
    orderId,
    tableId,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    discountPercent,
    discountAmount,
    extraCharges,
    total,
    const DeepCollectionEquality().hash(_payments),
    printCount,
    isSuspicious,
    createdBy,
    createdAt,
    printedAt,
    lastPrintedBy,
  );

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillModelImplCopyWith<_$BillModelImpl> get copyWith =>
      __$$BillModelImplCopyWithImpl<_$BillModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillModelImplToJson(this);
  }
}

abstract class _BillModel implements BillModel {
  const factory _BillModel({
    required final String billId,
    required final String orderId,
    required final String tableId,
    required final List<BillItem> items,
    required final double subtotal,
    final double discountPercent,
    final double discountAmount,
    final double extraCharges,
    required final double total,
    required final List<Payment> payments,
    final int printCount,
    final bool isSuspicious,
    required final String createdBy,
    required final DateTime createdAt,
    final DateTime? printedAt,
    final String? lastPrintedBy,
  }) = _$BillModelImpl;

  factory _BillModel.fromJson(Map<String, dynamic> json) =
      _$BillModelImpl.fromJson;

  @override
  String get billId;
  @override
  String get orderId;
  @override
  String get tableId;
  @override
  List<BillItem> get items;
  @override
  double get subtotal;
  @override
  double get discountPercent;
  @override
  double get discountAmount;
  @override
  double get extraCharges;
  @override
  double get total;
  @override
  List<Payment> get payments;
  @override
  int get printCount;
  @override
  bool get isSuspicious;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get printedAt;
  @override
  String? get lastPrintedBy;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillModelImplCopyWith<_$BillModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
