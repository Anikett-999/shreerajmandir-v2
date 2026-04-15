// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyAnalyticsHash() => r'33d65005ba633dc749e47b785336e737841fc147';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [dailyAnalytics].
@ProviderFor(dailyAnalytics)
const dailyAnalyticsProvider = DailyAnalyticsFamily();

/// See also [dailyAnalytics].
class DailyAnalyticsFamily extends Family<AsyncValue<DailyAnalytics>> {
  /// See also [dailyAnalytics].
  const DailyAnalyticsFamily();

  /// See also [dailyAnalytics].
  DailyAnalyticsProvider call({required String branchId}) {
    return DailyAnalyticsProvider(branchId: branchId);
  }

  @override
  DailyAnalyticsProvider getProviderOverride(
    covariant DailyAnalyticsProvider provider,
  ) {
    return call(branchId: provider.branchId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyAnalyticsProvider';
}

/// See also [dailyAnalytics].
class DailyAnalyticsProvider extends AutoDisposeStreamProvider<DailyAnalytics> {
  /// See also [dailyAnalytics].
  DailyAnalyticsProvider({required String branchId})
    : this._internal(
        (ref) => dailyAnalytics(ref as DailyAnalyticsRef, branchId: branchId),
        from: dailyAnalyticsProvider,
        name: r'dailyAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dailyAnalyticsHash,
        dependencies: DailyAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            DailyAnalyticsFamily._allTransitiveDependencies,
        branchId: branchId,
      );

  DailyAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
  }) : super.internal();

  final String branchId;

  @override
  Override overrideWith(
    Stream<DailyAnalytics> Function(DailyAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyAnalyticsProvider._internal(
        (ref) => create(ref as DailyAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DailyAnalytics> createElement() {
    return _DailyAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyAnalyticsProvider && other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyAnalyticsRef on AutoDisposeStreamProviderRef<DailyAnalytics> {
  /// The parameter `branchId` of this provider.
  String get branchId;
}

class _DailyAnalyticsProviderElement
    extends AutoDisposeStreamProviderElement<DailyAnalytics>
    with DailyAnalyticsRef {
  _DailyAnalyticsProviderElement(super.provider);

  @override
  String get branchId => (origin as DailyAnalyticsProvider).branchId;
}

String _$analyticsDateSelectionHash() =>
    r'aff0e054a5328ffc7778c899021bb952e0a0b290';

/// See also [AnalyticsDateSelection].
@ProviderFor(AnalyticsDateSelection)
final analyticsDateSelectionProvider =
    AutoDisposeNotifierProvider<
      AnalyticsDateSelection,
      Map<String, dynamic>
    >.internal(
      AnalyticsDateSelection.new,
      name: r'analyticsDateSelectionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsDateSelectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnalyticsDateSelection = AutoDisposeNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
