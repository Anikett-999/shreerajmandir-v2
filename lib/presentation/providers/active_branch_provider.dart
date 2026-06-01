import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';

/// Notifier to manage the active branch with persistence.
class ActiveBranchNotifier extends StateNotifier<String?> {
  final Ref _ref;
  static const _branchKey = 'active_branch_id';

  ActiveBranchNotifier(this._ref) : super(null) {
    // Re-initialize when user logic finishes loading
    _ref.listen(userModelProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        _initializeFromProfile(next.value!);
      }
    }, fireImmediately: true);
  }

  Future<void> _initializeFromProfile(dynamic user) async {
    // If state is already set (e.g. manually selected), don't override unless it's a waiter lock
    if (user == null) return;

    // Waiter logic: Locked to assigned branch if they only have one
    if (user.role == 'waiter' && user.branchIds.length == 1) {
      state = user.branchIds[0];
      return;
    }

    // Admin/Cashier logic: Check persistence
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_branchKey);

    if (savedId != null && _hasAccess(user, savedId)) {
      state = savedId;
    }
  }

  bool _hasAccess(dynamic user, String branchId) {
    if (user.role == 'admin') return true;
    return (user.branchIds as List).contains(branchId);
  }

  Future<void> setBranch(String branchId) async {
    state = branchId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_branchKey, branchId);
  }

  Future<void> clearBranch() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_branchKey);
  }
}

/// The source of truth for the active branch ID.
final activeBranchProvider = StateNotifierProvider<ActiveBranchNotifier, String?>((ref) {
  return ActiveBranchNotifier(ref);
});

/// Legacy compatibility provider for ref.watch(activeBranchIdProvider).
final activeBranchIdProvider = Provider<String?>((ref) => ref.watch(activeBranchProvider));

/// The user's role for the current session.
final activeUserRoleProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(userModelProvider);
  return userAsync.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (_, __) => null,
  );
});

