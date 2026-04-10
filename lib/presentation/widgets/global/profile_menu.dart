import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../screens/global/profile_screen.dart';
import '../../screens/global/settings_screen.dart';
import '../../../core/app_theme.dart';
import '../../../services/auth_service.dart';


class ProfileAppBarActions extends ConsumerWidget {
  const ProfileAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.maroon.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 18, color: AppTheme.maroon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? 'Rajmandir User',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 20, color: Colors.black87),
                SizedBox(width: 12),
                Text('My Profile'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings_outlined, size: 20, color: Colors.black87),
                SizedBox(width: 12),
                Text('App Settings'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout_rounded, size: 20, color: Colors.redAccent),
                const SizedBox(width: 12),
                Text('Logout', style: TextStyle(color: Colors.redAccent.shade700, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          switch (value) {
            case 'profile':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              break;
            case 'settings':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              break;
            case 'logout':
              final confirm = await _showLogoutDialog(context);
              if (confirm == true) {
                await ref.read(authServiceProvider).logout();
              }
              break;
          }
        },
        child: Hero(
          tag: 'profile-avatar',
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.maroon.withOpacity(0.2), width: 1),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.maroon.withOpacity(0.05),
              child: const Icon(Icons.account_circle_rounded, color: AppTheme.maroon),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to end your current session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('LOGOUT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
