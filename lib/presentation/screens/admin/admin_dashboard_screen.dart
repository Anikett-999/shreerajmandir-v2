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
import '../../widgets/admin/dashboard/management_list.dart';
import '../../widgets/admin/dashboard/suspicious_activity_list.dart';
import '../../widgets/admin/dashboard/product_insights_card.dart';
import 'users/user_management_screen.dart';
import 'branches/branch_management_screen.dart';
import '../shared/home_screen.dart';
import 'menu/menu_management_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Slightly cleaner background
      appBar: AppBar(
        title: const Text('COMMAND CENTER',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2.0, color: AppTheme.maroon, fontSize: 14)),
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
      body: Stack(
        children: [
          // Background Enrichment: Subtle Gradient Mesh
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF0F2F5),
                    const Color(0xFFF8FAFB),
                    Colors.white.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          statsAsync.when(
            data: (stats) => _buildDashboardBody(context, stats, isMobile),
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.maroon)),
            error: (err, stack) => Center(child: Text('Error loading dashboard: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBody(BuildContext context, dynamic stats, bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 24),
          
          // KPI Grid - Optimized for mobile
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: isMobile ? 12 : 16,
            mainAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: isMobile ? 1.05 : 1.3,
            children: [
              KpiCard(
                title: 'Total Revenue',
                value: '₹${NumberFormat('#,##,###').format(stats.totalRevenue)}',
                icon: Icons.account_balance_wallet_outlined,
                color: AppTheme.maroon,
                trend: stats.revenueTrend == 0 ? null : stats.revenueTrend,
              ),
              KpiCard(
                title: 'Total Bills',
                value: stats.totalOrders.toString(),
                icon: Icons.receipt_long_outlined,
                color: Colors.blue,
                trend: stats.ordersTrend == 0 ? null : stats.ordersTrend,
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
          ),
          
          const SizedBox(height: 24),
          
          // New: Product Insights Overview (30 Days)
          const SizedBox(
            height: 220,
            child: ProductInsightsCard(),
          ),
          
          const SizedBox(height: 24),
          
          // Analytics Row
          if (!isMobile)
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
            const SizedBox(height: 16),
            SizedBox(height: 300, child: PaymentMethodSplit(split: stats.paymentSplit)),
          ],
          
          const SizedBox(height: 24),
          
          // Operations Monitor
          LiveOperationsMonitor(
            activeTables: stats.activeTables,
            pendingKots: stats.pendingKots,
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.maroon,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'SYSTEM MANAGEMENT',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // NEW Management List (Replacing Bento Grid)
          ManagementList(
            items: [
              ManagementItem(
                title: 'Staff Control',
                subtitle: 'Manage roles, access & permissions',
                icon: Icons.people_alt_outlined,
                color: Colors.indigo,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen())),
              ),
              ManagementItem(
                title: 'Branch Settings',
                subtitle: 'Location, tax config & branding',
                icon: Icons.store_mall_directory_outlined,
                color: Colors.teal,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BranchManagementScreen())),
              ),
              ManagementItem(
                title: 'Terminal POS',
                subtitle: 'Go to operational billing interface',
                icon: Icons.point_of_sale_rounded,
                color: AppTheme.maroon,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OperationalHomeScreen())),
              ),
              ManagementItem(
                title: 'Menu Editor',
                subtitle: 'Items, Prices & KOT configurations',
                icon: Icons.restaurant_menu_rounded,
                color: Colors.orange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuManagementScreen())),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Security / Suspicious Activity
          SuspiciousActivityList(bills: stats.suspiciousBills),
          const SizedBox(height: 48), // Bottom padding for content
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final now = DateTime.now();
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RAJ MANDIR',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.maroon, letterSpacing: 3),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(now),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Intelligence\nDashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: Colors.black,
              height: 1.1,
            ),
          ),
        ],
      );
    }
    
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
