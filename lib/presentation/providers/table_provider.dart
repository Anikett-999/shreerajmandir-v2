import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/table_model.dart';
import '../../services/table_service.dart';
import 'active_branch_provider.dart';

// Provider for TableService
final tableServiceProvider = Provider((ref) {
  final branchId = ref.watch(activeBranchIdProvider);
  return TableService(branchId: branchId ?? 'branch_001');
});

// StreamProvider for Tables
final tablesStreamProvider = StreamProvider<List<TableModel>>((ref) {
  final service = ref.watch(tableServiceProvider);
  return service.watchTables();
});
