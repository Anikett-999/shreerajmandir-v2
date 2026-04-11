import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../domain/models/table_model.dart';
import '../../../services/table_service.dart';
import '../../widgets/table_card.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/global/profile_menu.dart';
import '../../../services/seed_data_service.dart';
import '../../providers/active_branch_provider.dart';
import '../admin/admin_dashboard_screen.dart';

import '../../providers/table_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeUserRoleProvider);

    if (activeRole == 'admin') {
      return AdminDashboardScreen();
    }

    return const OperationalHomeScreen();
  }
}

class OperationalHomeScreen extends ConsumerStatefulWidget {
  const OperationalHomeScreen({super.key});

  @override
  ConsumerState<OperationalHomeScreen> createState() => _OperationalHomeScreenState();
}

class _OperationalHomeScreenState extends ConsumerState<OperationalHomeScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/branding/splash_logo.png', height: 40),
        centerTitle: true,
        actions: [
          const ProfileMenu(),
        ],
      ),
      drawer: const AppDrawer(),

      body: Column(
        children: [
          // Header Controls: Status Dropdown + Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Status Filter Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      icon: const Icon(Icons.filter_list, size: 18),
                      onChanged: (String? newValue) {
                        if (newValue != null) setState(() => _selectedFilter = newValue);
                      },
                      items: ['All', 'Available', 'Occupied', 'Billing']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Search Bar
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search table...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table Grid
          Expanded(
            child: tablesAsync.when(
              data: (tables) {
                final filteredTables = tables.where((table) {
                  final matchesFilter = _selectedFilter == 'All' || 
                                       table.status.toLowerCase() == _selectedFilter.toLowerCase();
                  final matchesSearch = table.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchesFilter && matchesSearch;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filteredTables.length,
                  itemBuilder: (context, index) {
                    return TableCard(table: filteredTables[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('❌ Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
