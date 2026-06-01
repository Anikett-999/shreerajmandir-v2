import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/active_branch_provider.dart';
import '../screens/shared/login_screen.dart';
import '../screens/shared/branch_selection_screen.dart';
import '../screens/shared/home_screen.dart';
import '../screens/shared/account_disabled_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userModelAsync = ref.watch(userModelProvider);
    final activeBranchId = ref.watch(activeBranchIdProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return userModelAsync.when(
          data: (userModel) {
            if (userModel == null) {
              // User exists in Auth but not in Firestore yet (or deleted)
              return const LoginScreen();
            }

            if (!userModel.isActive) {
              return const AccountDisabledScreen();
            }

            if (activeBranchId == null) {
              return const BranchSelectionScreen();
            }

            return const HomeScreen();
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Scaffold(
            body: Center(child: Text('Error loading profile: $err')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Auth error: $err')),
      ),
    );
  }
}
