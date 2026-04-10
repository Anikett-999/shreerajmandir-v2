import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../core/app_theme.dart';
import '../screens/shared/home_screen.dart';
import '../screens/shared/profile_screen.dart';
import '../screens/shared/settings_screen.dart';
import '../screens/shared/printer_settings_screen.dart';
import '../screens/shared/kot_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import './global/confirmation_dialog.dart';
import '../providers/branch_provider.dart';

// We rely on the authServiceProvider from auth_provider.dart via the build method's ref

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final branchAsync = ref.watch(branchProvider);

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.maroon),
            accountName: branchAsync.when(
              data: (branch) => Text(
                branch.branchName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              loading: () => const Text('Loading Branch...', style: TextStyle(fontSize: 16)),
              error: (_, __) => Text(user?.displayName ?? 'Rajmandir User', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            accountEmail: branchAsync.when(
              data: (branch) => Text('${branch.location} | ${user?.email ?? ""}'),
              loading: () => Text(user?.email ?? ''),
              error: (_, __) => Text(user?.email ?? ''),
            ),
            currentAccountPicture: const Hero(
              tag: 'profile-avatar',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.store_rounded, color: AppTheme.maroon, size: 36),
              ),
            ),
          ),

          // Role-Based Options
          ListTile(
            leading: const Icon(Icons.table_bar, color: AppTheme.maroon),
            title: const Text('Table Status (Home)', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.receipt_long, color: AppTheme.maroon),
            title: const Text('Live KOTs', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KOTScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: AppTheme.maroon),
            title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person, color: AppTheme.maroon),
            title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.print, color: AppTheme.maroon),
            title: const Text('Printer Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrinterSettingsScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings, color: AppTheme.maroon),
            title: const Text('App Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          const Spacer(),
          const Divider(),

          // Logout with Confirmation
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.maroon),
            title: const Text('Logout', style: TextStyle(color: AppTheme.maroon, fontWeight: FontWeight.bold)),
            onTap: () {
              ConfirmationDialog.show(
                context: context,
                title: 'Logout',
                message: 'Are you sure you want to log out of the session?',
                confirmLabel: 'Logout',
                onConfirm: () async {
                  await ref.read(authServiceProvider).logout();
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
