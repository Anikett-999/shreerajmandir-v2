import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/models/dashboard_stats.dart';

class ReportConfirmationDialog extends StatelessWidget {
  final DateTimeRange range;
  final DashboardStats stats;
  final VoidCallback onConfirm;

  const ReportConfirmationDialog({
    super.key,
    required this.range,
    required this.stats,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Download Report', 
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate a detailed PDF business report for the selected period:',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: Column(
                children: [
                  _buildRow('Period', '${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}'),
                  const Divider(),
                  _buildRow('Total Sales', 'Rs. ${stats.grossSales.toStringAsFixed(2)}', isBold: true),
                  _buildRow('Net Earnings', 'Rs. ${stats.totalRevenue.toStringAsFixed(2)}', color: Colors.green.shade700, isBold: true),
                  _buildRow('Orders', '${stats.totalOrders}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This report include branding, financial summaries, payment distributions, and top product performance.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('DOWNLOAD PDF'),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}
