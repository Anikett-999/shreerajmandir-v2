import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/models/category.dart';
import '../../../../providers/menu_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../../core/app_theme.dart';
import '../category_items_screen.dart';

class CategoryListView extends ConsumerWidget {
  final String searchQuery;

  const CategoryListView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final userAsync = ref.watch(userModelProvider);
    final isAdmin = userAsync.value?.isAdmin ?? false;

    return categoriesAsync.when(
      data: (categories) {
        final filteredCategories = categories.where((c) => 
          c.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

        if (filteredCategories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No categories found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.18,
          ),
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return _CategoryCard(category: category, isAdmin: isAdmin);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

}

class _CategoryCard extends ConsumerWidget {
  final Category category;
  final bool isAdmin;

  const _CategoryCard({required this.category, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(selectedCategoryIdProvider.notifier).state = category.categoryId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryItemsScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Pattern or Gradient
              Positioned(
                top: -20,
                right: -20,
                child: Icon(
                  Icons.category,
                  size: 100,
                  color: AppTheme.maroon.withOpacity(0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.maroon.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'View Items',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.maroon,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                Positioned(
                  top: 4,
                  right: 4,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        CategoryListViewLogic.showCategoryDialog(context, ref, category: category);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, category);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Category?'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(menuControllerProvider).deleteCategory(category.categoryId);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class CategoryListViewLogic {
  static void showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: TextField(
          controller: nameController,
          maxLength: 25,
          decoration: InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: "", // Hide counter if you want it cleaner, or keep it.
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.maroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCategory = category?.copyWith(name: nameController.text) ?? 
                    Category(
                      categoryId: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      order: 999,
                    );
                ref.read(menuControllerProvider).saveCategory(newCategory);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
