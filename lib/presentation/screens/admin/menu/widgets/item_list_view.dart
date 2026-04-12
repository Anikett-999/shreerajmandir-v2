import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/models/item.dart';
import '../../../../providers/menu_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../../core/app_theme.dart';

class ItemListView extends ConsumerWidget {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsByCategoryProvider);
    final userAsync = ref.watch(userModelProvider);
    final isAdmin = userAsync.value?.isAdmin ?? false;
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return itemsAsync.when(
      data: (items) {
        if (selectedCategoryId == null) {
          return const Center(child: Text('Select a category to view items.'));
        }
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No items in this category.'),
                if (isAdmin)
                  ElevatedButton.icon(
                    onPressed: () => _showItemDialog(context, ref, selectedCategoryId),
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Item'),
                  ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items (${items.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (isAdmin)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
                      onPressed: () => _showItemDialog(context, ref, selectedCategoryId),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('₹${item.price.toStringAsFixed(0)}'),
                            if (item.groupName.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.groupName,
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quick Availability Toggle
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Switch(
                                    value: item.isAvailable,
                                    activeColor: AppTheme.maroon,
                                    onChanged: (value) {
                                      ref.read(menuControllerProvider).toggleItemAvailability(item.itemId, value);
                                    },
                                  ),
                                ),
                                Text(
                                  item.isAvailable ? 'Available' : 'Sold Out',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: item.isAvailable ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            if (isAdmin) ...[
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
                                onPressed: () => _showItemDialog(context, ref, selectedCategoryId, item: item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                onPressed: () => _confirmDeleteItem(context, ref, item),
                              ),
                            ],
                          ],
                        ),
                      ),
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

  void _showItemDialog(BuildContext context, WidgetRef ref, String categoryId, {Item? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: item?.price.toStringAsFixed(0) ?? '');
    final groupController = TextEditingController(text: item?.groupName ?? '');
    bool isAvailable = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name', hintText: 'e.g. Rose Petal'),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price (₹)', prefixText: '₹ '),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(labelText: 'Group Name (Optional)', hintText: 'e.g. Seasonal'),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Is Available'),
                  value: isAvailable,
                  activeColor: AppTheme.maroon,
                  onChanged: (value) => setState(() => isAvailable = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
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

  void _confirmDeleteItem(BuildContext context, WidgetRef ref, Item item) {
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
