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
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 2),
                        child: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.82), size: 24),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.16)),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => CategoryListViewLogic.showCategoryDialog(context, ref),
                    child: const SizedBox(
                      width: 72,
                      height: 56,
                      child: Icon(Icons.add_rounded, color: Colors.white, size: 30),
                    ),
                  ),
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
