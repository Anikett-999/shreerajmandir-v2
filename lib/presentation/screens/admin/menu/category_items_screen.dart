import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/models/category.dart';
import '../../../../core/app_theme.dart';
import 'widgets/item_list_view.dart';

class CategoryItemsScreen extends ConsumerStatefulWidget {
  final Category category;

  const CategoryItemsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends ConsumerState<CategoryItemsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.maroon,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
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
                      hintText: 'Search items...',
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
                    onPressed: () => ItemListViewLogic.showItemDialog(context, ref, widget.category.categoryId),
                    tooltip: 'Add Item',
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ItemListView(searchQuery: _searchQuery),
          ),
        ],
      ),
    );
  }
}
