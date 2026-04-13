import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/global/editorial_background.dart';

class AccountDisabledScreen extends ConsumerWidget {
  const AccountDisabledScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EditorialBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_person_outlined,
                  size: 100,
                  color: AppTheme.maroon,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Account Disabled',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.maroon,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your account has been suspended by the administrator. Please contact management for further assistance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => ref.read(authServiceProvider).logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.maroon,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('LOGOUT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
