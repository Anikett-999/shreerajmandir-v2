import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/analytics_service.dart';
import '../../domain/models/dashboard_stats.dart';
import 'active_branch_provider.dart';
import 'dashboard_provider.dart';

final reportDateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  return DateTimeRange(
    start: DateTime(now.year, now.month, now.day),
    end: now,
  );
});

final businessReportProvider = StreamProvider<DashboardStats>((ref) {
  final branchId = ref.watch(activeBranchIdProvider);
  final range = ref.watch(reportDateRangeProvider);
  
  if (branchId == null) {
    return Stream.value(const DashboardStats());
  }
  
  final service = ref.watch(analyticsServiceProvider);
  return service.watchReportForRange(branchId, range.start, range.end);
});
