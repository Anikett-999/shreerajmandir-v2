import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/models/item.dart';
import '../../../../providers/menu_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../../core/app_theme.dart';

class ItemListView extends ConsumerWidget {
  final String searchQuery;

  const ItemListView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsByCategoryProvider);
    final userAsync = ref.watch(userModelProvider);
    final isAdmin = userAsync.value?.isAdmin ?? false;
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return itemsAsync.when(
      data: (items) {
        if (selectedCategoryId == null) {
          return const Center(child: Text('Category error. Please go back and re-select.'));
        }

        final filteredItems = items.where((item) {
          return item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                 item.groupName.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  searchQuery.isEmpty ? 'No items in this category' : 'No items match "$searchQuery"',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                if (isAdmin && searchQuery.isEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.maroon,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => ItemListViewLogic.showItemDialog(context, ref, selectedCategoryId),
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Item'),
                  ),
                ],
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 100, // Fixed height for a consistent premium look
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return _ItemCard(item: item, isAdmin: isAdmin);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.maroon)),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

}

class _ItemCard extends ConsumerWidget {
  final Item item;
  final bool isAdmin;

  const _ItemCard({required this.item, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Text(
                '₹${item.price.toStringAsFixed(0)}',
                style: TextStyle(color: AppTheme.maroon, fontWeight: FontWeight.w600),
              ),
              if (item.groupName.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.groupName,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minimized Availability Toggle
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.7, // Minimized size as requested
                    child: Switch(
                      value: item.isAvailable,
                      activeColor: AppTheme.maroon,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        ref.read(menuControllerProvider).toggleItemAvailability(item.itemId, value);
                      },
                    ),
                  ),
                  Text(
                    item.isAvailable ? 'INSTOCK' : 'OUT',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: item.isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              if (isAdmin)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEdit(context, ref);
                    } else if (value == 'delete') {
                      _showDelete(context, ref);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEdit(BuildContext context, WidgetRef ref) {
    ItemListViewLogic.showItemDialog(context, ref, item.categoryId, item: item);
  }

  void _showDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(menuControllerProvider).deleteItem(item.itemId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}

class ItemListViewLogic {
  static void showItemDialog(BuildContext context, WidgetRef ref, String categoryId, {Item? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: item?.price.toStringAsFixed(0) ?? '');
    final groupController = TextEditingController(text: item?.groupName ?? '');
    bool isAvailable = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(item == null ? 'Add New Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                    floatingLabelStyle: TextStyle(color: AppTheme.maroon),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (₹)',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                    floatingLabelStyle: TextStyle(color: AppTheme.maroon),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name (Optional)',
                    hintText: 'e.g. Seasonal',
                    border: OutlineInputBorder(),
                    floatingLabelStyle: TextStyle(color: AppTheme.maroon),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Available'),
                  value: isAvailable,
                  activeColor: AppTheme.maroon,
                  onChanged: (value) => setState(() => isAvailable = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.maroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final newItem = item?.copyWith(
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    groupName: groupController.text,
                    isAvailable: isAvailable,
                  ) ?? Item(
                    itemId: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    categoryId: categoryId,
                    groupName: groupController.text,
                    isAvailable: isAvailable,
                    variants: [],
                  );
                  ref.read(menuControllerProvider).saveItem(newItem);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
