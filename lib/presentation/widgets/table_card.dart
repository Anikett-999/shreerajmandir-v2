import 'package:flutter/material.dart';
import 'package:shreerajmandir_pos/core/app_theme.dart';
import 'package:shreerajmandir_pos/domain/models/table_model.dart';
import 'package:shreerajmandir_pos/services/table_service.dart';
import 'package:shreerajmandir_pos/presentation/screens/order_screen.dart';
import 'package:shreerajmandir_pos/presentation/screens/billing_screen.dart';

class TableCard extends StatelessWidget {
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
              ListTile(
                leading: const Icon(Icons.cleaning_services, color: AppTheme.statusOccupied),
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
