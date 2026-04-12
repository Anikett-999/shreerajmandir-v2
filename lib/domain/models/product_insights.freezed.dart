// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TopCategory _$TopCategoryFromJson(Map<String, dynamic> json) {
  return _TopCategory.fromJson(json);
}

/// @nodoc
mixin _$TopCategory {
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this TopCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopCategoryCopyWith<TopCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopCategoryCopyWith<$Res> {
  factory $TopCategoryCopyWith(
    TopCategory value,
    $Res Function(TopCategory) then,
  ) = _$TopCategoryCopyWithImpl<$Res, TopCategory>;
  @useResult
  $Res call({String name, int quantity, double revenue});
}

/// @nodoc
class _$TopCategoryCopyWithImpl<$Res, $Val extends TopCategory>
    implements $TopCategoryCopyWith<$Res> {
  _$TopCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? revenue = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopCategoryImplCopyWith<$Res>
    implements $TopCategoryCopyWith<$Res> {
  factory _$$TopCategoryImplCopyWith(
    _$TopCategoryImpl value,
    $Res Function(_$TopCategoryImpl) then,
  ) = __$$TopCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int quantity, double revenue});
}

/// @nodoc
class __$$TopCategoryImplCopyWithImpl<$Res>
    extends _$TopCategoryCopyWithImpl<$Res, _$TopCategoryImpl>
    implements _$$TopCategoryImplCopyWith<$Res> {
  __$$TopCategoryImplCopyWithImpl(
    _$TopCategoryImpl _value,
    $Res Function(_$TopCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? revenue = null,
  }) {
    return _then(
      _$TopCategoryImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopCategoryImpl implements _TopCategory {
  const _$TopCategoryImpl({
    required this.name,
    required this.quantity,
    required this.revenue,
  });

  factory _$TopCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopCategoryImplFromJson(json);

  @override
  final String name;
  @override
  final int quantity;
  @override
  final double revenue;

  @override
  String toString() {
    return 'TopCategory(name: $name, quantity: $quantity, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, quantity, revenue);

  /// Create a copy of TopCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopCategoryImplCopyWith<_$TopCategoryImpl> get copyWith =>
      __$$TopCategoryImplCopyWithImpl<_$TopCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopCategoryImplToJson(this);
  }
}

abstract class _TopCategory implements TopCategory {
  const factory _TopCategory({
    required final String name,
    required final int quantity,
    required final double revenue,
  }) = _$TopCategoryImpl;

  factory _TopCategory.fromJson(Map<String, dynamic> json) =
      _$TopCategoryImpl.fromJson;

  @override
  String get name;
  @override
  int get quantity;
  @override
  double get revenue;

  /// Create a copy of TopCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopCategoryImplCopyWith<_$TopCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductInsights _$ProductInsightsFromJson(Map<String, dynamic> json) {
  return _ProductInsights.fromJson(json);
}

/// @nodoc
mixin _$ProductInsights {
  List<TopProduct> get topItems => throw _privateConstructorUsedError;
  List<TopCategory> get topCategories => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

  /// Serializes this ProductInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductInsightsCopyWith<ProductInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductInsightsCopyWith<$Res> {
  factory $ProductInsightsCopyWith(
    ProductInsights value,
    $Res Function(ProductInsights) then,
  ) = _$ProductInsightsCopyWithImpl<$Res, ProductInsights>;
  @useResult
  $Res call({
    List<TopProduct> topItems,
    List<TopCategory> topCategories,
    int totalQuantity,
    double totalRevenue,
  });
}

/// @nodoc
class _$ProductInsightsCopyWithImpl<$Res, $Val extends ProductInsights>
    implements $ProductInsightsCopyWith<$Res> {
  _$ProductInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topItems = null,
    Object? topCategories = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _value.copyWith(
            topItems: null == topItems
                ? _value.topItems
                : topItems // ignore: cast_nullable_to_non_nullable
                      as List<TopProduct>,
            topCategories: null == topCategories
                ? _value.topCategories
                : topCategories // ignore: cast_nullable_to_non_nullable
                      as List<TopCategory>,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductInsightsImplCopyWith<$Res>
    implements $ProductInsightsCopyWith<$Res> {
  factory _$$ProductInsightsImplCopyWith(
    _$ProductInsightsImpl value,
    $Res Function(_$ProductInsightsImpl) then,
  ) = __$$ProductInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TopProduct> topItems,
    List<TopCategory> topCategories,
    int totalQuantity,
    double totalRevenue,
  });
}

/// @nodoc
class __$$ProductInsightsImplCopyWithImpl<$Res>
    extends _$ProductInsightsCopyWithImpl<$Res, _$ProductInsightsImpl>
    implements _$$ProductInsightsImplCopyWith<$Res> {
  __$$ProductInsightsImplCopyWithImpl(
    _$ProductInsightsImpl _value,
    $Res Function(_$ProductInsightsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topItems = null,
    Object? topCategories = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _$ProductInsightsImpl(
        topItems: null == topItems
            ? _value._topItems
            : topItems // ignore: cast_nullable_to_non_nullable
                  as List<TopProduct>,
        topCategories: null == topCategories
            ? _value._topCategories
            : topCategories // ignore: cast_nullable_to_non_nullable
                  as List<TopCategory>,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductInsightsImpl implements _ProductInsights {
  const _$ProductInsightsImpl({
    required final List<TopProduct> topItems,
    required final List<TopCategory> topCategories,
    this.totalQuantity = 0,
    this.totalRevenue = 0.0,
  }) : _topItems = topItems,
       _topCategories = topCategories;

  factory _$ProductInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductInsightsImplFromJson(json);

  final List<TopProduct> _topItems;
  @override
  List<TopProduct> get topItems {
    if (_topItems is EqualUnmodifiableListView) return _topItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topItems);
  }

  final List<TopCategory> _topCategories;
  @override
  List<TopCategory> get topCategories {
    if (_topCategories is EqualUnmodifiableListView) return _topCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCategories);
  }

  @override
  @JsonKey()
  final int totalQuantity;
  @override
  @JsonKey()
  final double totalRevenue;

  @override
  String toString() {
    return 'ProductInsights(topItems: $topItems, topCategories: $topCategories, totalQuantity: $totalQuantity, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductInsightsImpl &&
            const DeepCollectionEquality().equals(other._topItems, _topItems) &&
            const DeepCollectionEquality().equals(
              other._topCategories,
              _topCategories,
            ) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_topItems),
    const DeepCollectionEquality().hash(_topCategories),
    totalQuantity,
    totalRevenue,
  );

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductInsightsImplCopyWith<_$ProductInsightsImpl> get copyWith =>
      __$$ProductInsightsImplCopyWithImpl<_$ProductInsightsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductInsightsImplToJson(this);
  }
}

abstract class _ProductInsights implements ProductInsights {
  const factory _ProductInsights({
    required final List<TopProduct> topItems,
    required final List<TopCategory> topCategories,
    final int totalQuantity,
    final double totalRevenue,
  }) = _$ProductInsightsImpl;

  factory _ProductInsights.fromJson(Map<String, dynamic> json) =
      _$ProductInsightsImpl.fromJson;

  @override
  List<TopProduct> get topItems;
  @override
  List<TopCategory> get topCategories;
  @override
  int get totalQuantity;
  @override
  double get totalRevenue;

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductInsightsImplCopyWith<_$ProductInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
