import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/global/base_widgets.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: authService.getCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Fetching profile...');
          }
          
          if (snapshot.hasError) {
            return ErrorStateWidget(error: snapshot.error.toString());
          }

          final user = snapshot.data;
          if (user == null) {
            return const EmptyStateWidget(
              title: 'No Profile Found', 
              message: 'Could not load your user profile information.',
              icon: Icons.person_off,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow(context, Icons.badge, 'Roles', user.roles.map((e) => e.toString().split('.').last).join(', ')),
                _buildInfoRow(context, Icons.fingerprint, 'User ID', user.userId),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Logic to change password can be added later
                    },
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Change Password'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
