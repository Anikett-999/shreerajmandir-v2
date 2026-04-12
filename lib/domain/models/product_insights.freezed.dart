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

ProductInsights _$ProductInsightsFromJson(Map<String, dynamic> json) {
  return _ProductInsights.fromJson(json);
}

/// @nodoc
mixin _$ProductInsights {
  List<TopProduct> get topSellers => throw _privateConstructorUsedError;
  List<TopProduct> get leastSellers => throw _privateConstructorUsedError;
  List<CategoryPerformance> get categoryPerformance =>
      throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalItemsSold => throw _privateConstructorUsedError;

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
    List<TopProduct> topSellers,
    List<TopProduct> leastSellers,
    List<CategoryPerformance> categoryPerformance,
    DateTime startDate,
    DateTime endDate,
    double totalRevenue,
    int totalItemsSold,
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
    Object? topSellers = null,
    Object? leastSellers = null,
    Object? categoryPerformance = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalRevenue = null,
    Object? totalItemsSold = null,
  }) {
    return _then(
      _value.copyWith(
            topSellers: null == topSellers
                ? _value.topSellers
                : topSellers // ignore: cast_nullable_to_non_nullable
                      as List<TopProduct>,
            leastSellers: null == leastSellers
                ? _value.leastSellers
                : leastSellers // ignore: cast_nullable_to_non_nullable
                      as List<TopProduct>,
            categoryPerformance: null == categoryPerformance
                ? _value.categoryPerformance
                : categoryPerformance // ignore: cast_nullable_to_non_nullable
                      as List<CategoryPerformance>,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalItemsSold: null == totalItemsSold
                ? _value.totalItemsSold
                : totalItemsSold // ignore: cast_nullable_to_non_nullable
                      as int,
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
    List<TopProduct> topSellers,
    List<TopProduct> leastSellers,
    List<CategoryPerformance> categoryPerformance,
    DateTime startDate,
    DateTime endDate,
    double totalRevenue,
    int totalItemsSold,
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
    Object? topSellers = null,
    Object? leastSellers = null,
    Object? categoryPerformance = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalRevenue = null,
    Object? totalItemsSold = null,
  }) {
    return _then(
      _$ProductInsightsImpl(
        topSellers: null == topSellers
            ? _value._topSellers
            : topSellers // ignore: cast_nullable_to_non_nullable
                  as List<TopProduct>,
        leastSellers: null == leastSellers
            ? _value._leastSellers
            : leastSellers // ignore: cast_nullable_to_non_nullable
                  as List<TopProduct>,
        categoryPerformance: null == categoryPerformance
            ? _value._categoryPerformance
            : categoryPerformance // ignore: cast_nullable_to_non_nullable
                  as List<CategoryPerformance>,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalItemsSold: null == totalItemsSold
            ? _value.totalItemsSold
            : totalItemsSold // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductInsightsImpl implements _ProductInsights {
  const _$ProductInsightsImpl({
    final List<TopProduct> topSellers = const [],
    final List<TopProduct> leastSellers = const [],
    final List<CategoryPerformance> categoryPerformance = const [],
    required this.startDate,
    required this.endDate,
    this.totalRevenue = 0.0,
    this.totalItemsSold = 0,
  }) : _topSellers = topSellers,
       _leastSellers = leastSellers,
       _categoryPerformance = categoryPerformance;

  factory _$ProductInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductInsightsImplFromJson(json);

  final List<TopProduct> _topSellers;
  @override
  @JsonKey()
  List<TopProduct> get topSellers {
    if (_topSellers is EqualUnmodifiableListView) return _topSellers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSellers);
  }

  final List<TopProduct> _leastSellers;
  @override
  @JsonKey()
  List<TopProduct> get leastSellers {
    if (_leastSellers is EqualUnmodifiableListView) return _leastSellers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leastSellers);
  }

  final List<CategoryPerformance> _categoryPerformance;
  @override
  @JsonKey()
  List<CategoryPerformance> get categoryPerformance {
    if (_categoryPerformance is EqualUnmodifiableListView)
      return _categoryPerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryPerformance);
  }

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final int totalItemsSold;

  @override
  String toString() {
    return 'ProductInsights(topSellers: $topSellers, leastSellers: $leastSellers, categoryPerformance: $categoryPerformance, startDate: $startDate, endDate: $endDate, totalRevenue: $totalRevenue, totalItemsSold: $totalItemsSold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductInsightsImpl &&
            const DeepCollectionEquality().equals(
              other._topSellers,
              _topSellers,
            ) &&
            const DeepCollectionEquality().equals(
              other._leastSellers,
              _leastSellers,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryPerformance,
              _categoryPerformance,
            ) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalItemsSold, totalItemsSold) ||
                other.totalItemsSold == totalItemsSold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_topSellers),
    const DeepCollectionEquality().hash(_leastSellers),
    const DeepCollectionEquality().hash(_categoryPerformance),
    startDate,
    endDate,
    totalRevenue,
    totalItemsSold,
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
    final List<TopProduct> topSellers,
    final List<TopProduct> leastSellers,
    final List<CategoryPerformance> categoryPerformance,
    required final DateTime startDate,
    required final DateTime endDate,
    final double totalRevenue,
    final int totalItemsSold,
  }) = _$ProductInsightsImpl;

  factory _ProductInsights.fromJson(Map<String, dynamic> json) =
      _$ProductInsightsImpl.fromJson;

  @override
  List<TopProduct> get topSellers;
  @override
  List<TopProduct> get leastSellers;
  @override
  List<CategoryPerformance> get categoryPerformance;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get totalRevenue;
  @override
  int get totalItemsSold;

  /// Create a copy of ProductInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductInsightsImplCopyWith<_$ProductInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryPerformance _$CategoryPerformanceFromJson(Map<String, dynamic> json) {
  return _CategoryPerformance.fromJson(json);
}

/// @nodoc
mixin _$CategoryPerformance {
  String get categoryName => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get contributionPercentage => throw _privateConstructorUsedError;

  /// Serializes this CategoryPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryPerformanceCopyWith<CategoryPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryPerformanceCopyWith<$Res> {
  factory $CategoryPerformanceCopyWith(
    CategoryPerformance value,
    $Res Function(CategoryPerformance) then,
  ) = _$CategoryPerformanceCopyWithImpl<$Res, CategoryPerformance>;
  @useResult
  $Res call({
    String categoryName,
    double revenue,
    int quantity,
    double contributionPercentage,
  });
}

/// @nodoc
class _$CategoryPerformanceCopyWithImpl<$Res, $Val extends CategoryPerformance>
    implements $CategoryPerformanceCopyWith<$Res> {
  _$CategoryPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? revenue = null,
    Object? quantity = null,
    Object? contributionPercentage = null,
  }) {
    return _then(
      _value.copyWith(
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            contributionPercentage: null == contributionPercentage
                ? _value.contributionPercentage
                : contributionPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryPerformanceImplCopyWith<$Res>
    implements $CategoryPerformanceCopyWith<$Res> {
  factory _$$CategoryPerformanceImplCopyWith(
    _$CategoryPerformanceImpl value,
    $Res Function(_$CategoryPerformanceImpl) then,
  ) = __$$CategoryPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String categoryName,
    double revenue,
    int quantity,
    double contributionPercentage,
  });
}

/// @nodoc
class __$$CategoryPerformanceImplCopyWithImpl<$Res>
    extends _$CategoryPerformanceCopyWithImpl<$Res, _$CategoryPerformanceImpl>
    implements _$$CategoryPerformanceImplCopyWith<$Res> {
  __$$CategoryPerformanceImplCopyWithImpl(
    _$CategoryPerformanceImpl _value,
    $Res Function(_$CategoryPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? revenue = null,
    Object? quantity = null,
    Object? contributionPercentage = null,
  }) {
    return _then(
      _$CategoryPerformanceImpl(
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        contributionPercentage: null == contributionPercentage
            ? _value.contributionPercentage
            : contributionPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryPerformanceImpl implements _CategoryPerformance {
  const _$CategoryPerformanceImpl({
    required this.categoryName,
    required this.revenue,
    required this.quantity,
    this.contributionPercentage = 0.0,
  });

  factory _$CategoryPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryPerformanceImplFromJson(json);

  @override
  final String categoryName;
  @override
  final double revenue;
  @override
  final int quantity;
  @override
  @JsonKey()
  final double contributionPercentage;

  @override
  String toString() {
    return 'CategoryPerformance(categoryName: $categoryName, revenue: $revenue, quantity: $quantity, contributionPercentage: $contributionPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryPerformanceImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.contributionPercentage, contributionPercentage) ||
                other.contributionPercentage == contributionPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryName,
    revenue,
    quantity,
    contributionPercentage,
  );

  /// Create a copy of CategoryPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryPerformanceImplCopyWith<_$CategoryPerformanceImpl> get copyWith =>
      __$$CategoryPerformanceImplCopyWithImpl<_$CategoryPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryPerformanceImplToJson(this);
  }
}

abstract class _CategoryPerformance implements CategoryPerformance {
  const factory _CategoryPerformance({
    required final String categoryName,
    required final double revenue,
    required final int quantity,
    final double contributionPercentage,
  }) = _$CategoryPerformanceImpl;

  factory _CategoryPerformance.fromJson(Map<String, dynamic> json) =
      _$CategoryPerformanceImpl.fromJson;

  @override
  String get categoryName;
  @override
  double get revenue;
  @override
  int get quantity;
  @override
  double get contributionPercentage;

  /// Create a copy of CategoryPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryPerformanceImplCopyWith<_$CategoryPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
