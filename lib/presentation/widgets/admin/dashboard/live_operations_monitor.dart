import 'package:flutter/material.dart';
import '../../../../core/app_theme.dart';

class LiveOperationsMonitor extends StatelessWidget {
  final int activeTables;
  final int pendingKots;

  const LiveOperationsMonitor({
    super.key,
    required this.activeTables,
    required this.pendingKots,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOperationCard(
            context,
            'ACTIVE TABLES',
            activeTables.toString(),
            'Dining Area occupancy',
            Icons.table_restaurant,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOperationCard(
            context,
            'PENDING KOTS',
            pendingKots.toString(),
            'Orders in preparation',
            Icons.outdoor_grill,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildOperationCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: color.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
