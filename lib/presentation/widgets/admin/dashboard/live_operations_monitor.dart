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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        if (isMobile) ...[
          _buildOperationCard(
            context,
            'ACTIVE TABLES',
            activeTables.toString(),
            'Dining Area occupancy',
            Icons.table_restaurant,
            Colors.blue,
            true,
          ),
          const SizedBox(height: 12),
          _buildOperationCard(
            context,
            'PENDING KOTS',
            pendingKots.toString(),
            'Orders in preparation',
            Icons.outdoor_grill,
            Colors.orange,
            true,
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: _buildOperationCard(
                  context,
                  'ACTIVE TABLES',
                  activeTables.toString(),
                  'Dining Area occupancy',
                  Icons.table_restaurant,
                  Colors.blue,
                  false,
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
                  false,
                ),
              ),
            ],
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: isMobile ? 22 : 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: color.withOpacity(0.8),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
