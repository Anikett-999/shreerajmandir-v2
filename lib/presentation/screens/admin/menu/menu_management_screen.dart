import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_theme.dart';
import '../../../widgets/app_drawer.dart';
import 'widgets/category_list_view.dart';
import 'widgets/item_list_view.dart';

class MenuManagementScreen extends ConsumerWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        backgroundColor: AppTheme.maroon,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: AppTheme.maroon,
                    indicatorColor: AppTheme.maroon,
                    tabs: [
                      Tab(text: 'Categories', icon: Icon(Icons.category_outlined)),
                      Tab(text: 'Items', icon: Icon(Icons.restaurant_menu_outlined)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CategoryListView(isMobile: true),
                        const ItemListView(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Desktop Split View
            return Row(
              children: [
                // sidebar categories
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: CategoryListView(isMobile: false),
                ),
                // main items view
                const Expanded(
                  child: ItemListView(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
