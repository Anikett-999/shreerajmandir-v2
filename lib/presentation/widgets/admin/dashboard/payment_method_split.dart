import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_theme.dart';

class PaymentMethodSplit extends StatelessWidget {
  final Map<String, double> split;

  const PaymentMethodSplit({super.key, required this.split});

  @override
  Widget build(BuildContext context) {
    final total = split.values.fold(0.0, (val, element) => val + element);
    
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
          const Text(
            'PAYMENT MODES',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 450;
              final content = [
                Expanded(
                  flex: isNarrow ? 0 : 2,
                  child: SizedBox(
                    height: isNarrow ? 200 : null,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: isNarrow ? 30 : 40,
                        sections: [
                          _buildSection('cash', split['cash'] ?? 0, Colors.green, total),
                          _buildSection('upi', split['upi'] ?? 0, Colors.blue, total),
                          _buildSection('card', split['card'] ?? 0, Colors.amber, total),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isNarrow ? 0 : 24, height: isNarrow ? 24 : 0),
                Expanded(
                  flex: isNarrow ? 0 : 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend('Cash', split['cash'] ?? 0, Colors.green, total),
                      const SizedBox(height: 12),
                      _buildLegend('UPI', split['upi'] ?? 0, Colors.blue, total),
                      const SizedBox(height: 12),
                      _buildLegend('Card', split['card'] ?? 0, Colors.amber, total),
                    ],
                  ),
                ),
              ];

              return isNarrow 
                ? Column(children: content) 
                : Row(children: content);
            },
          ),
        ],
      ),
    );
  }

  PieChartSectionData _buildSection(String title, double value, Color color, double total) {
    final percentage = total == 0 ? 0 : (value / total * 100);
    return PieChartSectionData(
      color: color,
      value: value == 0 ? 0.01 : value,
      title: percentage > 10 ? '${percentage.toStringAsFixed(0)}%' : '',
      radius: 30,
      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLegend(String label, double value, Color color, double total) {
    final percentage = total == 0 ? 0 : (value / total * 100);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('₹${value.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ],
    );
  }
}
