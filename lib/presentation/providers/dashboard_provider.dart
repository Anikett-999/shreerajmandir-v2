import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/analytics_service.dart';
import '../../domain/models/dashboard_stats.dart';
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
