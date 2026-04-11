import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// Holds the currently selected branch ID for the session.
final activeBranchIdProvider = StateProvider<String?>((ref) => null);

/// The user's role for the current session.
/// Since role is the same across all branches, just return user.role.
final activeUserRoleProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(userModelProvider);
  final activeBranchId = ref.watch(activeBranchIdProvider);

  return userAsync.when(
    data: (user) {
      if (user == null || activeBranchId == null) return null;
      return user.role; // role is uniform across all branches
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
