import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/models/category.dart';
import '../../../../providers/menu_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../../core/app_theme.dart';

class CategoryListView extends ConsumerWidget {
  final bool isMobile;

  const CategoryListView({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedId = ref.watch(selectedCategoryIdProvider);
    final userAsync = ref.watch(userModelProvider);
    final isAdmin = userAsync.value?.isAdmin ?? false;

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        // Initialize selection if none
        if (selectedId == null && categories.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedCategoryIdProvider.notifier).state = categories.first.categoryId;
          });
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppTheme.maroon),
                      onPressed: () => _showCategoryDialog(context, ref),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: categories.length,
                onReorder: isAdmin 
                    ? (oldIndex, newIndex) => _onReorder(ref, categories, oldIndex, newIndex)
                    : (oldIndex, newIndex) {},
                buildDefaultDragHandles: isAdmin,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedId == category.categoryId;

                  return Card(
                    key: ValueKey(category.categoryId),
                    color: isSelected ? AppTheme.maroon.withOpacity(0.1) : null,
                    elevation: isSelected ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppTheme.maroon : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.maroon : null,
                        ),
                      ),
                      trailing: isAdmin
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _showCategoryDialog(context, ref, category: category),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, ref, category),
                                ),
                              ],
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () {
                        ref.read(selectedCategoryIdProvider.notifier).state = category.categoryId;
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  void _onReorder(WidgetRef ref, List<Category> categories, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final items = List<Category>.from(categories);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    ref.read(menuControllerProvider).reorderCategories(items);
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text('Are you sure you want to delete "${category.name}"? This will fail if the category has items.'),
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
                    SnackBar(content: Text(e.toString())),
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
