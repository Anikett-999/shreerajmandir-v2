import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../screens/shared/profile_screen.dart';
import '../../screens/shared/settings_screen.dart';
import '../../../core/app_theme.dart';
import '../../../services/auth_service.dart';


class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
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
              child: const Icon(Icons.account_circle_rounded, color: AppTheme.maroon, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
