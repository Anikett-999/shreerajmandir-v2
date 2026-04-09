import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../core/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/global/profile_screen.dart';
import '../screens/global/settings_screen.dart';
import '../screens/global/printer_settings_screen.dart';
import '../screens/global/kot_screen.dart';
import './global/confirmation_dialog.dart';
import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.maroon),
            accountName: Text(
              user?.displayName ?? 'Rajmandir POS User',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(user?.email ?? 'branch_001@rajmandir.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/branding/splash_logo.png'),
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
