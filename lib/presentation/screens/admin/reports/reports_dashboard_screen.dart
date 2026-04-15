import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/daily_analytics.dart';
import '../../../../domain/models/branch_model.dart';
import '../../../../services/pdf_service.dart';
import '../../../../services/analytics_service.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/active_branch_provider.dart';
import '../../../providers/branch_provider.dart';
import '../../../widgets/global/editorial_background.dart';

class ReportsDashboardScreen extends ConsumerStatefulWidget {
  const ReportsDashboardScreen({super.key});

  @override
  ConsumerState<ReportsDashboardScreen> createState() => _ReportsDashboardScreenState();
}

class _ReportsDashboardScreenState extends ConsumerState<ReportsDashboardScreen> {
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final branchId = ref.watch(activeBranchIdProvider);
    if (branchId == null) {
      return const Scaffold(body: Center(child: Text('No branch selected')));
    }

    final selection = ref.watch(analyticsDateSelectionProvider);
    final analyticsAsync = ref.watch(dailyAnalyticsProvider(branchId: branchId));
    final branchAsync = ref.watch(branchProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EditorialBackground(
        child: Column(
          children: [
            _buildHeader(context, selection, analyticsAsync, branchAsync),
            _buildDateSelector(context, selection),
            Expanded(
              child: analyticsAsync.when(
                data: (analytics) => _buildDashboard(context, analytics),
                loading: () => Center(child: CircularProgressIndicator(color: AppTheme.maroon)),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, 
    Map<String, dynamic> selection,
    AsyncValue<DailyAnalytics> analyticsAsync,
    AsyncValue<BranchModel> branchAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Sync Button
          IconButton(
            onPressed: () async {
              final branchId = ref.read(activeBranchIdProvider);
              if (branchId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Syncing historical data...')),
                );
                await AnalyticsService().syncHistoricalData(branchId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sync completed!')),
                );
                ref.invalidate(dailyAnalyticsProvider);
              }
            },
            icon: const Icon(Icons.sync_rounded, color: Colors.grey, size: 24),
            tooltip: 'Sync Historical Data',
          ),
          const SizedBox(width: 8),
          // Download Report Button
          ElevatedButton.icon(
            onPressed: (analyticsAsync.hasValue && branchAsync.hasValue) 
              ? () async {
                  try {
                    final bool isRange = selection['isRange'] as bool;
                    final start = selection['start'] as DateTime;
                    final end = selection['end'] as DateTime?;
                    
                    final dateStr = isRange 
                      ? "${_dateFormat.format(start)} - ${_dateFormat.format(end ?? start)}"
                      : _dateFormat.format(start);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preparing PDF...')),
                    );

                    final pdfBytes = await PdfService.generateDailyAnalyticsPdf(
                      analytics: analyticsAsync.value!,
                      branch: branchAsync.value!,
                      dateRangeStr: dateStr,
                    );
                    
                    await Printing.layoutPdf(
                      onLayout: (format) => pdfBytes,
                      name: 'Analytics_$dateStr',
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error generating PDF: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              : null,
            icon: const Icon(Icons.file_download_rounded, size: 20),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.maroon,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, Map<String, dynamic> selection) {
    final bool isRange = selection['isRange'] as bool;
    final start = selection['start'] as DateTime;
    final end = selection['end'] as DateTime?;
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildToggleItem('Single Day', !isRange, () => ref.read(analyticsDateSelectionProvider.notifier).toggleRange(false))),
              Expanded(child: _buildToggleItem('Date Range', isRange, () => ref.read(analyticsDateSelectionProvider.notifier).toggleRange(true))),
            ],
          ),
          const Divider(height: 1, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: isMobile && isRange 
              ? Column(
                  children: [
                    _buildDateButton(context, 'From: ${_dateFormat.format(start)}', () => _selectDate(context, true, start, end)),
                    const SizedBox(height: 8),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                    const SizedBox(height: 8),
                    _buildDateButton(context, 'To: ${_dateFormat.format(end ?? start)}', () => _selectDate(context, false, start, end)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _buildDateButton(
                        context,
                        isRange ? 'From: ${_dateFormat.format(start)}' : _dateFormat.format(start),
                        () => _selectDate(context, true, start, end),
                      ),
                    ),
                    if (isRange) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 20),
                      ),
                      Flexible(
                        child: _buildDateButton(
                          context,
                          'To: ${_dateFormat.format(end ?? start)}',
                          () => _selectDate(context, false, start, end),
                        ),
                      ),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart, DateTime start, DateTime? end) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? start : (end ?? start),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.maroon),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
        if (ref.read(analyticsDateSelectionProvider)['isRange'] as bool) {
          ref.read(analyticsDateSelectionProvider.notifier).setRange(picked, end ?? picked);
        } else {
          ref.read(analyticsDateSelectionProvider.notifier).setSingleDate(picked);
        }
      } else {
        ref.read(analyticsDateSelectionProvider.notifier).setRange(start, picked);
      }
    }
  }

  Widget _buildToggleItem(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.maroon : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.maroon),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DailyAnalytics analytics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 900;
        
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          children: [
            _buildSalesSummary(analytics, isDesktop),
            const SizedBox(height: 16),
            if (isDesktop) 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildHourlyChart(analytics)),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: _buildPaymentChart(analytics)),
                ],
              )
            else ...[
              _buildHourlyChart(analytics),
              _buildPaymentChart(analytics),
            ],
            const SizedBox(height: 16),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTopItems(analytics)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSmartInsights(analytics)),
                ],
              )
            else ...[
              _buildTopItems(analytics),
              _buildSmartInsights(analytics),
            ],
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Widget _buildSalesSummary(DailyAnalytics analytics, bool isDesktop) {
    final double aov = analytics.totalBills > 0 ? analytics.totalSales / analytics.totalBills : 0;
    
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildSummaryCard('Total Sales', '₹${analytics.totalSales.toStringAsFixed(0)}', Icons.payments_rounded, Colors.green),
        _buildSummaryCard('Total Bills', '${analytics.totalBills}', Icons.receipt_long_rounded, Colors.blue),
        _buildSummaryCard('Avg Order', '₹${aov.toStringAsFixed(0)}', Icons.trending_up_rounded, Colors.orange),
        _buildSummaryCard('Discounts', '₹${analytics.totalDiscount.toStringAsFixed(0)}', Icons.local_offer_rounded, Colors.red),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyChart(DailyAnalytics analytics) {
    final Map<int, double> hourlySales = analytics.hourlyStats.map((k, v) => MapEntry(int.parse(k), v.sales));
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sales by Hour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: hourlySales.isEmpty 
                ? Center(child: Text('No sales data yet', style: TextStyle(color: Colors.grey[400])))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (hourlySales.values.fold(0.0, (p, c) => c > p ? c : p) * 1.2).clamp(100, double.infinity),
                      barGroups: List.generate(24, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: hourlySales[i] ?? 0,
                              color: AppTheme.maroon,
                              width: 8,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value % 4 != 0) return const SizedBox();
                              return Text('${value.toInt()}h', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChart(DailyAnalytics analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: analytics.paymentStats.values.every((v) => v == 0)
                ? Center(child: Text('No payment data', style: TextStyle(color: Colors.grey[400])))
                : PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: analytics.paymentStats['cash'] ?? 0, color: Colors.green, title: 'Cash', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        PieChartSectionData(value: analytics.paymentStats['upi'] ?? 0, color: Colors.blue, title: 'UPI', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        PieChartSectionData(value: analytics.paymentStats['card'] ?? 0, color: Colors.purple, title: 'Card', radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItems(DailyAnalytics analytics) {
    final sortedItems = analytics.itemStats.entries.toList()
      ..sort((a, b) => b.value.revenue.compareTo(a.value.revenue));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Items (by Revenue)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            if (sortedItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No items sold yet', style: TextStyle(color: Colors.grey[400]))),
              )
            else
              ...sortedItems.take(5).map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.value.name, style: const TextStyle(fontSize: 13))),
                    Text('x${entry.value.qty}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(width: 12),
                    Text('₹${entry.value.revenue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartInsights(DailyAnalytics analytics) {
    final sortedItems = analytics.itemStats.entries.toList()
      ..sort((a, b) => b.value.qty.compareTo(a.value.qty));
    final bestItem = sortedItems.isNotEmpty ? sortedItems.first.value.name : 'N/A';

    final sortedHours = analytics.hourlyStats.entries.toList()
      ..sort((a, b) => b.value.sales.compareTo(a.value.sales));
    final peakHour = sortedHours.isNotEmpty ? '${sortedHours.first.key}h' : 'N/A';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Smart Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildInsightRow(Icons.auto_awesome_rounded, 'Best seller', bestItem),
            _buildInsightRow(Icons.access_time_filled_rounded, 'Peak hour', peakHour),
            _buildInsightRow(Icons.star_rounded, 'Ticket Avg', '₹${(analytics.totalBills > 0 ? analytics.totalSales / analytics.totalBills : 0).toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.maroon),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.maroon)),
        ],
      ),
    );
  }
}
