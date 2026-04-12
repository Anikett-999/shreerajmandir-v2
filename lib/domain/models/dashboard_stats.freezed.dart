// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  double get totalRevenue => throw _privateConstructorUsedError;
  double get grossSales => throw _privateConstructorUsedError;
  double get totalDiscounts => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  double get avgOrderValue => throw _privateConstructorUsedError;
  double get revenueTrend => throw _privateConstructorUsedError;
  double get ordersTrend => throw _privateConstructorUsedError;
  List<HourlySales> get hourlySales => throw _privateConstructorUsedError;
  Map<String, double> get paymentSplit => throw _privateConstructorUsedError;
  int get activeTables => throw _privateConstructorUsedError;
  int get pendingKots => throw _privateConstructorUsedError;
  List<TopProduct> get topProducts => throw _privateConstructorUsedError;
  List<SuspiciousBill> get suspiciousBills =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    double totalRevenue,
    double grossSales,
    double totalDiscounts,
    int totalOrders,
    double avgOrderValue,
    double revenueTrend,
    double ordersTrend,
    List<HourlySales> hourlySales,
    Map<String, double> paymentSplit,
    int activeTables,
    int pendingKots,
    List<TopProduct> topProducts,
    List<SuspiciousBill> suspiciousBills,
  });
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? grossSales = null,
    Object? totalDiscounts = null,
    Object? totalOrders = null,
    Object? avgOrderValue = null,
    Object? revenueTrend = null,
    Object? ordersTrend = null,
    Object? hourlySales = null,
    Object? paymentSplit = null,
    Object? activeTables = null,
    Object? pendingKots = null,
    Object? topProducts = null,
    Object? suspiciousBills = null,
  }) {
    return _then(
      _value.copyWith(
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            grossSales: null == grossSales
                ? _value.grossSales
                : grossSales // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDiscounts: null == totalDiscounts
                ? _value.totalDiscounts
                : totalDiscounts // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            avgOrderValue: null == avgOrderValue
                ? _value.avgOrderValue
                : avgOrderValue // ignore: cast_nullable_to_non_nullable
                      as double,
            revenueTrend: null == revenueTrend
                ? _value.revenueTrend
                : revenueTrend // ignore: cast_nullable_to_non_nullable
                      as double,
            ordersTrend: null == ordersTrend
                ? _value.ordersTrend
                : ordersTrend // ignore: cast_nullable_to_non_nullable
                      as double,
            hourlySales: null == hourlySales
                ? _value.hourlySales
                : hourlySales // ignore: cast_nullable_to_non_nullable
                      as List<HourlySales>,
            paymentSplit: null == paymentSplit
                ? _value.paymentSplit
                : paymentSplit // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            activeTables: null == activeTables
                ? _value.activeTables
                : activeTables // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingKots: null == pendingKots
                ? _value.pendingKots
                : pendingKots // ignore: cast_nullable_to_non_nullable
                      as int,
            topProducts: null == topProducts
                ? _value.topProducts
                : topProducts // ignore: cast_nullable_to_non_nullable
                      as List<TopProduct>,
            suspiciousBills: null == suspiciousBills
                ? _value.suspiciousBills
                : suspiciousBills // ignore: cast_nullable_to_non_nullable
                      as List<SuspiciousBill>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalRevenue,
    double grossSales,
    double totalDiscounts,
    int totalOrders,
    double avgOrderValue,
    double revenueTrend,
    double ordersTrend,
    List<HourlySales> hourlySales,
    Map<String, double> paymentSplit,
    int activeTables,
    int pendingKots,
    List<TopProduct> topProducts,
    List<SuspiciousBill> suspiciousBills,
  });
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? grossSales = null,
    Object? totalDiscounts = null,
    Object? totalOrders = null,
    Object? avgOrderValue = null,
    Object? revenueTrend = null,
    Object? ordersTrend = null,
    Object? hourlySales = null,
    Object? paymentSplit = null,
    Object? activeTables = null,
    Object? pendingKots = null,
    Object? topProducts = null,
    Object? suspiciousBills = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        grossSales: null == grossSales
            ? _value.grossSales
            : grossSales // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDiscounts: null == totalDiscounts
            ? _value.totalDiscounts
            : totalDiscounts // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        avgOrderValue: null == avgOrderValue
            ? _value.avgOrderValue
            : avgOrderValue // ignore: cast_nullable_to_non_nullable
                  as double,
        revenueTrend: null == revenueTrend
            ? _value.revenueTrend
            : revenueTrend // ignore: cast_nullable_to_non_nullable
                  as double,
        ordersTrend: null == ordersTrend
            ? _value.ordersTrend
            : ordersTrend // ignore: cast_nullable_to_non_nullable
                  as double,
        hourlySales: null == hourlySales
            ? _value._hourlySales
            : hourlySales // ignore: cast_nullable_to_non_nullable
                  as List<HourlySales>,
        paymentSplit: null == paymentSplit
            ? _value._paymentSplit
            : paymentSplit // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        activeTables: null == activeTables
            ? _value.activeTables
            : activeTables // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingKots: null == pendingKots
            ? _value.pendingKots
            : pendingKots // ignore: cast_nullable_to_non_nullable
                  as int,
        topProducts: null == topProducts
            ? _value._topProducts
            : topProducts // ignore: cast_nullable_to_non_nullable
                  as List<TopProduct>,
        suspiciousBills: null == suspiciousBills
            ? _value._suspiciousBills
            : suspiciousBills // ignore: cast_nullable_to_non_nullable
                  as List<SuspiciousBill>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    this.totalRevenue = 0.0,
    this.grossSales = 0.0,
    this.totalDiscounts = 0.0,
    this.totalOrders = 0,
    this.avgOrderValue = 0.0,
    this.revenueTrend = 0.0,
    this.ordersTrend = 0.0,
    final List<HourlySales> hourlySales = const [],
    final Map<String, double> paymentSplit = const {},
    this.activeTables = 0,
    this.pendingKots = 0,
    final List<TopProduct> topProducts = const [],
    final List<SuspiciousBill> suspiciousBills = const [],
  }) : _hourlySales = hourlySales,
       _paymentSplit = paymentSplit,
       _topProducts = topProducts,
       _suspiciousBills = suspiciousBills;

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final double grossSales;
  @override
  @JsonKey()
  final double totalDiscounts;
  @override
  @JsonKey()
  final int totalOrders;
  @override
  @JsonKey()
  final double avgOrderValue;
  @override
  @JsonKey()
  final double revenueTrend;
  @override
  @JsonKey()
  final double ordersTrend;
  final List<HourlySales> _hourlySales;
  @override
  @JsonKey()
  List<HourlySales> get hourlySales {
    if (_hourlySales is EqualUnmodifiableListView) return _hourlySales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlySales);
  }

  final Map<String, double> _paymentSplit;
  @override
  @JsonKey()
  Map<String, double> get paymentSplit {
    if (_paymentSplit is EqualUnmodifiableMapView) return _paymentSplit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_paymentSplit);
  }

  @override
  @JsonKey()
  final int activeTables;
  @override
  @JsonKey()
  final int pendingKots;
  final List<TopProduct> _topProducts;
  @override
  @JsonKey()
  List<TopProduct> get topProducts {
    if (_topProducts is EqualUnmodifiableListView) return _topProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topProducts);
  }

  final List<SuspiciousBill> _suspiciousBills;
  @override
  @JsonKey()
  List<SuspiciousBill> get suspiciousBills {
    if (_suspiciousBills is EqualUnmodifiableListView) return _suspiciousBills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suspiciousBills);
  }

  @override
  String toString() {
    return 'DashboardStats(totalRevenue: $totalRevenue, grossSales: $grossSales, totalDiscounts: $totalDiscounts, totalOrders: $totalOrders, avgOrderValue: $avgOrderValue, revenueTrend: $revenueTrend, ordersTrend: $ordersTrend, hourlySales: $hourlySales, paymentSplit: $paymentSplit, activeTables: $activeTables, pendingKots: $pendingKots, topProducts: $topProducts, suspiciousBills: $suspiciousBills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.totalDiscounts, totalDiscounts) ||
                other.totalDiscounts == totalDiscounts) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.avgOrderValue, avgOrderValue) ||
                other.avgOrderValue == avgOrderValue) &&
            (identical(other.revenueTrend, revenueTrend) ||
                other.revenueTrend == revenueTrend) &&
            (identical(other.ordersTrend, ordersTrend) ||
                other.ordersTrend == ordersTrend) &&
            const DeepCollectionEquality().equals(
              other._hourlySales,
              _hourlySales,
            ) &&
            const DeepCollectionEquality().equals(
              other._paymentSplit,
              _paymentSplit,
            ) &&
            (identical(other.activeTables, activeTables) ||
                other.activeTables == activeTables) &&
            (identical(other.pendingKots, pendingKots) ||
                other.pendingKots == pendingKots) &&
            const DeepCollectionEquality().equals(
              other._topProducts,
              _topProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._suspiciousBills,
              _suspiciousBills,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRevenue,
    grossSales,
    totalDiscounts,
    totalOrders,
    avgOrderValue,
    revenueTrend,
    ordersTrend,
    const DeepCollectionEquality().hash(_hourlySales),
    const DeepCollectionEquality().hash(_paymentSplit),
    activeTables,
    pendingKots,
    const DeepCollectionEquality().hash(_topProducts),
    const DeepCollectionEquality().hash(_suspiciousBills),
  );

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    final double totalRevenue,
    final double grossSales,
    final double totalDiscounts,
    final int totalOrders,
    final double avgOrderValue,
    final double revenueTrend,
    final double ordersTrend,
    final List<HourlySales> hourlySales,
    final Map<String, double> paymentSplit,
    final int activeTables,
    final int pendingKots,
    final List<TopProduct> topProducts,
    final List<SuspiciousBill> suspiciousBills,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  double get totalRevenue;
  @override
  double get grossSales;
  @override
  double get totalDiscounts;
  @override
  int get totalOrders;
  @override
  double get avgOrderValue;
  @override
  double get revenueTrend;
  @override
  double get ordersTrend;
  @override
  List<HourlySales> get hourlySales;
  @override
  Map<String, double> get paymentSplit;
  @override
  int get activeTables;
  @override
  int get pendingKots;
  @override
  List<TopProduct> get topProducts;
  @override
  List<SuspiciousBill> get suspiciousBills;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HourlySales _$HourlySalesFromJson(Map<String, dynamic> json) {
  return _HourlySales.fromJson(json);
}

/// @nodoc
mixin _$HourlySales {
  int get hour => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this HourlySales to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HourlySales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlySalesCopyWith<HourlySales> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlySalesCopyWith<$Res> {
  factory $HourlySalesCopyWith(
    HourlySales value,
    $Res Function(HourlySales) then,
  ) = _$HourlySalesCopyWithImpl<$Res, HourlySales>;
  @useResult
  $Res call({int hour, double revenue});
}

/// @nodoc
class _$HourlySalesCopyWithImpl<$Res, $Val extends HourlySales>
    implements $HourlySalesCopyWith<$Res> {
  _$HourlySalesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlySales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hour = null, Object? revenue = null}) {
    return _then(
      _value.copyWith(
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
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
abstract class _$$HourlySalesImplCopyWith<$Res>
    implements $HourlySalesCopyWith<$Res> {
  factory _$$HourlySalesImplCopyWith(
    _$HourlySalesImpl value,
    $Res Function(_$HourlySalesImpl) then,
  ) = __$$HourlySalesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, double revenue});
}

/// @nodoc
class __$$HourlySalesImplCopyWithImpl<$Res>
    extends _$HourlySalesCopyWithImpl<$Res, _$HourlySalesImpl>
    implements _$$HourlySalesImplCopyWith<$Res> {
  __$$HourlySalesImplCopyWithImpl(
    _$HourlySalesImpl _value,
    $Res Function(_$HourlySalesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HourlySales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hour = null, Object? revenue = null}) {
    return _then(
      _$HourlySalesImpl(
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
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
class _$HourlySalesImpl implements _HourlySales {
  const _$HourlySalesImpl({required this.hour, required this.revenue});

  factory _$HourlySalesImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlySalesImplFromJson(json);

  @override
  final int hour;
  @override
  final double revenue;

  @override
  String toString() {
    return 'HourlySales(hour: $hour, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlySalesImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, revenue);

  /// Create a copy of HourlySales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlySalesImplCopyWith<_$HourlySalesImpl> get copyWith =>
      __$$HourlySalesImplCopyWithImpl<_$HourlySalesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlySalesImplToJson(this);
  }
}

abstract class _HourlySales implements HourlySales {
  const factory _HourlySales({
    required final int hour,
    required final double revenue,
  }) = _$HourlySalesImpl;

  factory _HourlySales.fromJson(Map<String, dynamic> json) =
      _$HourlySalesImpl.fromJson;

  @override
  int get hour;
  @override
  double get revenue;

  /// Create a copy of HourlySales
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlySalesImplCopyWith<_$HourlySalesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopProduct _$TopProductFromJson(Map<String, dynamic> json) {
  return _TopProduct.fromJson(json);
}

/// @nodoc
mixin _$TopProduct {
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this TopProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopProductCopyWith<TopProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopProductCopyWith<$Res> {
  factory $TopProductCopyWith(
    TopProduct value,
    $Res Function(TopProduct) then,
  ) = _$TopProductCopyWithImpl<$Res, TopProduct>;
  @useResult
  $Res call({String name, int quantity, double revenue});
}

/// @nodoc
class _$TopProductCopyWithImpl<$Res, $Val extends TopProduct>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopProduct
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
abstract class _$$TopProductImplCopyWith<$Res>
    implements $TopProductCopyWith<$Res> {
  factory _$$TopProductImplCopyWith(
    _$TopProductImpl value,
    $Res Function(_$TopProductImpl) then,
  ) = __$$TopProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int quantity, double revenue});
}

/// @nodoc
class __$$TopProductImplCopyWithImpl<$Res>
    extends _$TopProductCopyWithImpl<$Res, _$TopProductImpl>
    implements _$$TopProductImplCopyWith<$Res> {
  __$$TopProductImplCopyWithImpl(
    _$TopProductImpl _value,
    $Res Function(_$TopProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? revenue = null,
  }) {
    return _then(
      _$TopProductImpl(
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
class _$TopProductImpl implements _TopProduct {
  const _$TopProductImpl({
    required this.name,
    required this.quantity,
    required this.revenue,
  });

  factory _$TopProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopProductImplFromJson(json);

  @override
  final String name;
  @override
  final int quantity;
  @override
  final double revenue;

  @override
  String toString() {
    return 'TopProduct(name: $name, quantity: $quantity, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopProductImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, quantity, revenue);

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopProductImplCopyWith<_$TopProductImpl> get copyWith =>
      __$$TopProductImplCopyWithImpl<_$TopProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopProductImplToJson(this);
  }
}

abstract class _TopProduct implements TopProduct {
  const factory _TopProduct({
    required final String name,
    required final int quantity,
    required final double revenue,
  }) = _$TopProductImpl;

  factory _TopProduct.fromJson(Map<String, dynamic> json) =
      _$TopProductImpl.fromJson;

  @override
  String get name;
  @override
  int get quantity;
  @override
  double get revenue;

  /// Create a copy of TopProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopProductImplCopyWith<_$TopProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuspiciousBill _$SuspiciousBillFromJson(Map<String, dynamic> json) {
  return _SuspiciousBill.fromJson(json);
}

/// @nodoc
mixin _$SuspiciousBill {
  String get billId => throw _privateConstructorUsedError;
  int get printCount => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SuspiciousBill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuspiciousBill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuspiciousBillCopyWith<SuspiciousBill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuspiciousBillCopyWith<$Res> {
  factory $SuspiciousBillCopyWith(
    SuspiciousBill value,
    $Res Function(SuspiciousBill) then,
  ) = _$SuspiciousBillCopyWithImpl<$Res, SuspiciousBill>;
  @useResult
  $Res call({
    String billId,
    int printCount,
    String tableId,
    double total,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SuspiciousBillCopyWithImpl<$Res, $Val extends SuspiciousBill>
    implements $SuspiciousBillCopyWith<$Res> {
  _$SuspiciousBillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuspiciousBill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billId = null,
    Object? printCount = null,
    Object? tableId = null,
    Object? total = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            billId: null == billId
                ? _value.billId
                : billId // ignore: cast_nullable_to_non_nullable
                      as String,
            printCount: null == printCount
                ? _value.printCount
                : printCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tableId: null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuspiciousBillImplCopyWith<$Res>
    implements $SuspiciousBillCopyWith<$Res> {
  factory _$$SuspiciousBillImplCopyWith(
    _$SuspiciousBillImpl value,
    $Res Function(_$SuspiciousBillImpl) then,
  ) = __$$SuspiciousBillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billId,
    int printCount,
    String tableId,
    double total,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SuspiciousBillImplCopyWithImpl<$Res>
    extends _$SuspiciousBillCopyWithImpl<$Res, _$SuspiciousBillImpl>
    implements _$$SuspiciousBillImplCopyWith<$Res> {
  __$$SuspiciousBillImplCopyWithImpl(
    _$SuspiciousBillImpl _value,
    $Res Function(_$SuspiciousBillImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuspiciousBill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billId = null,
    Object? printCount = null,
    Object? tableId = null,
    Object? total = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SuspiciousBillImpl(
        billId: null == billId
            ? _value.billId
            : billId // ignore: cast_nullable_to_non_nullable
                  as String,
        printCount: null == printCount
            ? _value.printCount
            : printCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tableId: null == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuspiciousBillImpl implements _SuspiciousBill {
  const _$SuspiciousBillImpl({
    required this.billId,
    required this.printCount,
    required this.tableId,
    required this.total,
    required this.createdAt,
  });

  factory _$SuspiciousBillImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuspiciousBillImplFromJson(json);

  @override
  final String billId;
  @override
  final int printCount;
  @override
  final String tableId;
  @override
  final double total;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SuspiciousBill(billId: $billId, printCount: $printCount, tableId: $tableId, total: $total, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuspiciousBillImpl &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.printCount, printCount) ||
                other.printCount == printCount) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, billId, printCount, tableId, total, createdAt);

  /// Create a copy of SuspiciousBill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuspiciousBillImplCopyWith<_$SuspiciousBillImpl> get copyWith =>
      __$$SuspiciousBillImplCopyWithImpl<_$SuspiciousBillImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuspiciousBillImplToJson(this);
  }
}

abstract class _SuspiciousBill implements SuspiciousBill {
  const factory _SuspiciousBill({
    required final String billId,
    required final int printCount,
    required final String tableId,
    required final double total,
    required final DateTime createdAt,
  }) = _$SuspiciousBillImpl;

  factory _SuspiciousBill.fromJson(Map<String, dynamic> json) =
      _$SuspiciousBillImpl.fromJson;

  @override
  String get billId;
  @override
  int get printCount;
  @override
  String get tableId;
  @override
  double get total;
  @override
  DateTime get createdAt;

  /// Create a copy of SuspiciousBill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuspiciousBillImplCopyWith<_$SuspiciousBillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
