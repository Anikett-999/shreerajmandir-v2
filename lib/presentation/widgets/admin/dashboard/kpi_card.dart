import 'package:flutter/material.dart';
import '../../../../core/app_theme.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isCompact = width < 150;
        final bool showTrend = trend != null && width > 120;

        return Container(
          padding: EdgeInsets.all(width * 0.1 > 16 ? 16 : width * 0.1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.06),
                offset: const Offset(0, 8),
                blurRadius: 16,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle background icon
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: width * 0.4,
                  color: color.withOpacity(0.03),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: isCompact ? 16 : 20),
                      ),
                      if (showTrend)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: _buildTrendIndicator(isCompact),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: isCompact ? 18 : 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isCompact ? 8 : 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400],
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendIndicator(bool isCompact) {
    final isPositive = trend! > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
            size: isCompact ? 8 : 10,
          ),
          const SizedBox(width: 2),
          Text(
            '${trend!.abs().toStringAsFixed(0)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: isCompact ? 8 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

