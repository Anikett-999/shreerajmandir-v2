import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../../domain/models/table_model.dart';
import '../../services/table_service.dart';
import '../widgets/table_card.dart';

import '../../services/seed_data_service.dart';

// Provider for TableService
final tableServiceProvider = Provider((ref) => TableService());

// StreamProvider for Tables
final tablesStreamProvider = StreamProvider<List<TableModel>>((ref) {
  final service = ref.watch(tableServiceProvider);
  return service.watchTables();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/branding/splash_logo.png', height: 40),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Seed Initial Data',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seeding Database...')),
              );
              try {
                final seedService = SeedDataService();
                await seedService.seedMenuData();
                await seedService.seedInitialTables();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Data Seeded Successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Error: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['All', 'Available', 'Occupied', 'Billing'].map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Table Grid
          Expanded(
            child: tablesAsync.when(
              data: (tables) {
                final filteredTables = tables.where((table) {
                  if (_selectedFilter == 'All') return true;
                  return table.status.toLowerCase() == _selectedFilter.toLowerCase();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new table (Admin only)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
