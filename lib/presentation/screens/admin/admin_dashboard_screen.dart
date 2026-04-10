import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/global/profile_menu.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          const ProfileMenu(),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 30),
            _buildStatsOverview(),
            const SizedBox(height: 30),
            const Text(
              'Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            _buildAdminGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Administrator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.maroon,
            letterSpacing: -1,
          ),
        ),
        const Text(
          'Manage your POS system and view business insights.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.maroon, AppTheme.maroon.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.maroon.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Today\'s Sales', '₹ 12,450', Icons.trending_up),
          _buildStatItem('Orders', '48', Icons.shopping_bag),
          _buildStatItem('Active Tables', '6', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAdminGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildAdminCard(
          context,
          'User Management',
          'Staff & Roles',
          Icons.people_outline,
          Colors.blue,
        ),
        _buildAdminCard(
          context,
          'Menu Manager',
          'Items & Categories',
          Icons.restaurant_menu,
          Colors.orange,
        ),
        _buildAdminCard(
          context,
          'Reports',
          'Sales & Performance',
          Icons.bar_chart,
          Colors.purple,
        ),
        _buildAdminCard(
          context,
          'Live Monitor',
          'KOT & Orders',
          Icons.monitor_heart_outlined,
          Colors.red,
        ),
        _buildAdminCard(
          context,
          'Data Backup',
          'Sync & Export',
          Icons.cloud_upload_outlined,
          Colors.teal,
        ),
        _buildAdminCard(
          context,
          'Settings',
          'System Config',
          Icons.settings_outlined,
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigation to $title coming soon!')),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
