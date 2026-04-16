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
    final isOccupied = table.status.toLowerCase() == 'occupied';

    final role = ref.watch(activeUserRoleProvider);
    final canCheckout = role == 'admin' || role == 'cashier';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen(table: table)),
              );
            },
            onLongPress: isOccupied ? () => _showQuickActions(context, ref) : null,
            child: Column(
              children: [
                // Status Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: statusColor,
                  child: Text(
                    table.status.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                // Table Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              table.name,
                              style: TextStyle(
                                fontSize: isOccupied ? 36 : 28,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.maroon,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        if (!isOccupied) ...[
                          const SizedBox(height: 2),
                          if (table.activeOrderId != null) ...[
                            Text('${table.itemCount} Items', 
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text(
                              '₹${table.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepGreen,
                              ),
                            ),
                          ] else
                            Text('Seats: ${table.capacity}', 
                              style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ],
                    ),
                  ),
                ),

                // Checkout Button Strip (Only when occupied and allowed)
                if (isOccupied && canCheckout)
                  Material(
                    color: AppTheme.maroon,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BillingScreen(table: table)),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'CHECKOUT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Unprinted KOT Indicator
          if (table.status != 'available' && (table.unprintedKotCount ?? 0) > 0)
            Positioned(
              top: 32, // Below status header
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.print,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('ADMIN ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services_rounded, color: AppTheme.statusOccupied),
                title: const Text('Clear Table (Admin Only)', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context);
                  final branchId = ref.read(activeBranchIdProvider);
                  if (branchId == null) throw Exception('No active branch selected');
                  final service = TableService(branchId: branchId);
                  await service.clearTable(table.tableId);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
