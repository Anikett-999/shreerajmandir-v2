import 'package:flutter/material.dart';
import '../../../domain/models/bill_model.dart';
import '../../../core/app_theme.dart';

class BillAggregatedList extends StatelessWidget {
  final List<BillItem> items;

  const BillAggregatedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items in bill preview.'));
    }

    // Group items by category
    final Map<String, List<BillItem>> groupedItems = {};
    for (var item in items) {
      final cat = item.category.isEmpty ? 'OTHERS' : item.category.toUpperCase();
      groupedItems.putIfAbsent(cat, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: groupedItems.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...entry.value.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        if (item.note.isNotEmpty)
                          Text(
                            item.note,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'x${item.qty}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '₹${(item.price * item.qty).toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
