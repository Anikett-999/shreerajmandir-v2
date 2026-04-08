import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../domain/models/table_model.dart';
import '../../services/table_service.dart';
import '../screens/order_screen.dart';
import '../screens/billing_screen.dart';

class TableCard extends StatelessWidget {
  final TableModel table;

  const TableCard({super.key, required this.table});

  Color _getStatusColor() {
    switch (table.status.toLowerCase()) {
      case 'available':
        return AppTheme.availableGreen;
      case 'occupied':
        return AppTheme.primaryRed;
      case 'billing':
        return AppTheme.occupiedOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen(table: table)),
        );
      },
      onLongPress: () {
        _showQuickActions(context);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: statusColor.withOpacity(0.5), width: 2),
        ),
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                  fontSize: 12,
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (table.activeOrderId != null) ...[
                      Text('Items: ${table.itemCount}'),
                      const SizedBox(height: 4),
                      Text(
                        '₹${table.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.billingBlue,
                        ),
                      ),
                    ] else
                      Text('Capacity: ${table.capacity}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.receipt_long, color: AppTheme.occupiedOrange),
                title: const Text('Generate Bill'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BillingScreen(table: table)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services, color: AppTheme.billingBlue),
                title: const Text('Clear Table'),
                onTap: () async {
                  Navigator.pop(context);
                  final service = TableService();
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
