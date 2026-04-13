import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_theme.dart';
import '../../../widgets/app_drawer.dart';
import 'widgets/category_list_view.dart';
import '../../../widgets/global/editorial_background.dart';

class MenuManagementScreen extends ConsumerStatefulWidget {
  final bool useShell;
  const MenuManagementScreen({super.key, this.useShell = false});

  @override
  ConsumerState<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends ConsumerState<MenuManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        // Search Bar & Add Button Section
        Container(
          color: AppTheme.maroon,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => CategoryListViewLogic.showCategoryDialog(context, ref),
                  tooltip: 'Add Category',
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: CategoryListView(searchQuery: _searchQuery),
        ),
      ],
    );

    if (widget.useShell) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('MENU MANAGEMENT', 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppTheme.maroon)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        scrolledUnderElevation: 4,
        iconTheme: const IconThemeData(color: AppTheme.maroon),
      ),
      drawer: widget.useShell ? null : const AppDrawer(),
      body: EditorialBackground(child: content),
    );
  }
}
