import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/analytics_service.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/product_insights.dart';
import 'active_branch_provider.dart';

final analyticsServiceProvider = Provider((ref) => AnalyticsService());

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  final branchId = ref.watch(activeBranchIdProvider);
  if (branchId == null) {
    return Stream.value(const DashboardStats());
  }
  
  final service = ref.watch(analyticsServiceProvider);
  return service.watchDashboardStats(branchId);
});

final productInsightsProvider = StreamProvider<ProductInsights>((ref) {
  final branchId = ref.watch(activeBranchIdProvider);
  if (branchId == null) {
    return Stream.value(const ProductInsights(topItems: [], topCategories: []));
  }
  
  final service = ref.watch(analyticsServiceProvider);
  return service.watchProductInsights(branchId);
});
