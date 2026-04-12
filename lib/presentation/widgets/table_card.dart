import 'package:flutter/material.dart';
import 'package:shreerajmandir_pos/core/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shreerajmandir_pos/domain/models/table_model.dart';
import 'package:shreerajmandir_pos/services/table_service.dart';
import 'package:shreerajmandir_pos/presentation/screens/waiter/order_screen.dart';
import 'package:shreerajmandir_pos/presentation/screens/admin/billing_screen.dart';

import 'package:shreerajmandir_pos/presentation/providers/active_branch_provider.dart';

class TableCard extends ConsumerWidget {
  final TableModel table;

  const TableCard({super.key, required this.table});

  Color _getStatusColor() {
    switch (table.status.toLowerCase()) {
      case 'available':
        return AppTheme.statusAvailable;
      case 'occupied':
        return AppTheme.maroon;
      case 'billing':
        return AppTheme.statusOccupied;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor();

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderScreen(table: table)),
            );
          },
          onLongPress: () {
            _showQuickActions(context, ref);
          },
          child: Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none, // Explicitly no lines
            ),
            child: Column(
              children: [
                // Status Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    table.status.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                // Table Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.maroon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (table.activeOrderId != null) ...[
                          Text('${table.itemCount} Items', 
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            '₹${table.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepGreen,
                            ),
                          ),
                        ] else
                          Text('Seats: ${table.capacity}', 
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Unprinted KOT Indicator
        if ((table.unprintedKotCount ?? 0) > 0)
          Positioned(
            top: 2,
            right: 2,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 1000),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1)
                      ]
                    ),
                    child: const Icon(
                      Icons.print,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                );
              },
              onEnd: () {
                // This is a stateless hack to loop, better would be a stateful widget
                // but for a quick indicator this works in some flutter versions
                // or we can just make it static.
              },
            ),
          ),
      ],
    );
  }

  void _showQuickActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (table.activeOrderId != null)
                ListTile(
                  leading: const Icon(Icons.receipt_long, color: AppTheme.maroon),
                  title: const Text('Generate Bill'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BillingScreen(table: table)),
                    );
                  },
                ),
              if (table.activeOrderId != null && (table.unprintedKotCount ?? 0) > 0)
                ListTile(
                  leading: const Icon(Icons.print, color: Colors.orange),
                  title: Text('Print Pending KOTs (${table.unprintedKotCount})'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(
                          table: table,
                          initialIndex: 1, // Open history tab
                        ),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cleaning_services, color: AppTheme.statusOccupied),
                title: const Text('Clear Table'),
                onTap: () async {
                  Navigator.pop(context);
                  final branchId = ref.read(activeBranchIdProvider);
                  final service = TableService(branchId: branchId ?? 'branch_001');
                  await service.clearTable(table.tableId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
