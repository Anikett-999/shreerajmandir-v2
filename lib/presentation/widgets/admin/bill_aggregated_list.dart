import 'package:flutter/material.dart';
import '../../../domain/models/bill_model.dart';
import '../../../core/app_theme.dart';

class BillAggregatedList extends StatelessWidget {
  final List<BillItem> items;
  final bool showHeader;

  const BillAggregatedList({
    super.key,
    required this.items,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('ITEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                  Expanded(flex: 1, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey), textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey), textAlign: TextAlign.right)),
                  Expanded(flex: 1, child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey), textAlign: TextAlign.right)),
                ],
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          if (item.note.isNotEmpty)
                            Text(item.note, style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('x${item.qty}', style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('₹${item.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13), textAlign: TextAlign.right),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('₹${(item.price * item.qty).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.maroon), textAlign: TextAlign.right),
                    ),
                  ],
                ),
              );
            },
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: Text('No items found', style: TextStyle(color: Colors.grey))),
            ),
        ],
      ),
    );
  }
}
