import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/app_theme.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/global/profile_menu.dart';
import '../../widgets/admin/dashboard/kpi_card.dart';
import '../../widgets/admin/dashboard/revenue_trend_chart.dart';
import '../../widgets/admin/dashboard/payment_method_split.dart';
import '../../widgets/admin/dashboard/live_operations_monitor.dart';
import '../../widgets/admin/dashboard/management_bento_grid.dart';
import '../../widgets/admin/dashboard/suspicious_activity_list.dart';
import 'users/user_management_screen.dart';
import 'branches/branch_management_screen.dart';
import '../shared/home_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('COMMAND CENTER',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppTheme.maroon, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          const ProfileMenu(),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: statsAsync.when(
        data: (stats) => _buildDashboardBody(context, stats),
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.maroon)),
        error: (err, stack) => Center(child: Text('Error loading dashboard: $err')),
      ),
    );
  }

  Widget _buildDashboardBody(BuildContext context, dynamic stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          
          // KPI Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.5 : 1.1,
                children: [
                  KpiCard(
                    title: 'Total Revenue',
                    value: '₹${NumberFormat('#,##,###').format(stats.totalRevenue)}',
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppTheme.maroon,
                  ),
                  KpiCard(
                    title: 'Total Bills',
                    value: stats.totalOrders.toString(),
                    icon: Icons.receipt_long_outlined,
                    color: Colors.blue,
                  ),
                  KpiCard(
                    title: 'Avg Order',
                    value: '₹${stats.avgOrderValue.toStringAsFixed(0)}',
                    icon: Icons.analytics_outlined,
                    color: Colors.orange,
                  ),
                  KpiCard(
                    title: 'Active Tables',
                    value: stats.activeTables.toString(),
                    icon: Icons.restaurant_outlined,
                    color: Colors.green,
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Analytics Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 1100;
              return Column(
                children: [
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: RevenueTrendChart(salesData: stats.hourlySales)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: SizedBox(height: 380, child: PaymentMethodSplit(split: stats.paymentSplit))),
                      ],
                    )
                  else ...[
                    RevenueTrendChart(salesData: stats.hourlySales),
                    const SizedBox(height: 24),
                    SizedBox(height: 300, child: PaymentMethodSplit(split: stats.paymentSplit)),
                  ],
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Operations Monitor
          LiveOperationsMonitor(
            activeTables: stats.activeTables,
            pendingKots: stats.pendingKots,
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'SYSTEM MANAGEMENT',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          
          // Bento Navigation Grid
          ManagementBentoGrid(
            items: [
              BentoItem(
                title: 'Staff Control',
                subtitle: 'Manage roles & access',
                icon: Icons.people_alt_outlined,
                color: Colors.indigo,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen())),
              ),
              BentoItem(
                title: 'Branch Settings',
                subtitle: 'Location & tax config',
                icon: Icons.store_mall_directory_outlined,
                color: Colors.teal,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BranchManagementScreen())),
              ),
              BentoItem(
                title: 'Terminal POS',
                subtitle: 'Operational billing',
                icon: Icons.point_of_sale_rounded,
                color: AppTheme.maroon,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OperationalHomeScreen())),
              ),
              BentoItem(
                title: 'Menu Editor',
                subtitle: 'Items, Prices & KOT',
                icon: Icons.restaurant_menu_rounded,
                color: Colors.orange,
                onTap: () {
                  // TODO: Add Menu Editor navigation
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Security / Suspicious Activity
          SuspiciousActivityList(bills: stats.suspiciousBills),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RAJ MANDIR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppTheme.maroon,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Intelligence Dashboard',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, MMM dd').format(now),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
