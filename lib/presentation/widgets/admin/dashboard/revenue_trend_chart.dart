import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/dashboard_stats.dart';

class RevenueTrendChart extends StatelessWidget {
  final List<HourlySales> salesData;

  const RevenueTrendChart({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      height: 380,
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
                    'REVENUE TREND',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5),
                  ),
                  Text(
                    'Hourly Sales Analysis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.maroon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(color: AppTheme.maroon, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5000,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        if (hour < 0 || hour > 23) return const SizedBox();
                        final displayHour = hour > 12 ? '${hour - 12} PM' : (hour == 0 ? '12 AM' : '$hour AM');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            displayHour,
                            style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5000,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          '₹${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 23,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: salesData.map((s) => FlSpot(s.hour.toDouble(), s.revenue)).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppTheme.maroon, Colors.orangeAccent]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppTheme.maroon.withOpacity(0.2), AppTheme.maroon.withOpacity(0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
