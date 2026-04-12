import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/dashboard_stats.dart';

class SuspiciousActivityList extends StatelessWidget {
  final List<SuspiciousBill> bills;

  const SuspiciousActivityList({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    final suspiciousBills = bills;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SECURITY WATCH',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.red, letterSpacing: 1.5),
                  ),
                  Text(
                    'Suspicious Activities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              if (suspiciousBills.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${suspiciousBills.length} ALERTS',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (suspiciousBills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Icon(Icons.verified_user_outlined, color: Colors.green.withOpacity(0.3), size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'All operations normal',
                      style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suspiciousBills.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.05)),
              itemBuilder: (context, index) {
                final bill = suspiciousBills[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  ),
                  title: Text(
                    'Bill #${bill.billId.substring(bill.billId.length - 4)} - Over-printed',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    'Printed ${bill.printCount} times',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${bill.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(bill.createdAt),
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
