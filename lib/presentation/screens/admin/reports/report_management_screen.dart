import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/dashboard_stats.dart';
import '../../../../services/pdf_service.dart';
import '../../../providers/report_provider.dart';
import '../../../providers/branch_provider.dart';
import '../../../widgets/admin/dashboard/kpi_card.dart';
import '../../../widgets/admin/dashboard/revenue_trend_chart.dart';
import '../../../widgets/admin/dashboard/payment_method_split.dart';
import './widgets/report_confirmation_dialog.dart';
import '../../../widgets/global/editorial_background.dart';

class ReportManagementScreen extends ConsumerStatefulWidget {
  final bool useShell;
  const ReportManagementScreen({super.key, this.useShell = false});

  @override
  ConsumerState<ReportManagementScreen> createState() => _ReportManagementScreenState();
}

class _ReportManagementScreenState extends ConsumerState<ReportManagementScreen> {
  String _selectedPeriod = 'Daily'; // Daily, Monthly, Yearly, Custom

  void _updateRange(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (period) {
      case 'Daily':
        start = DateTime(now.year, now.month, now.day);
        break;
      case 'Monthly':
        start = DateTime(now.year, now.month, 1);
        break;
      case 'Yearly':
        start = DateTime(now.year, 1, 1);
        break;
      default:
        return;
    }

    ref.read(reportDateRangeProvider.notifier).state = DateTimeRange(start: start, end: end);
  }

  Future<void> _selectCustomRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: ref.read(reportDateRangeProvider),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.maroon,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      setState(() => _selectedPeriod = 'Custom');
      ref.read(reportDateRangeProvider.notifier).state = range;
    }
  }

  Future<void> _handleDownloadReport(DashboardStats stats, DateTimeRange range) async {
    final branchAsync = ref.read(branchProvider);
    final branch = branchAsync.value;

    if (branch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Branch details not loaded'))
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ReportConfirmationDialog(
        range: range,
        stats: stats,
        onConfirm: () => _generateAndSharePdf(stats, range, branch),
      ),
    );
  }

  Future<void> _generateAndSharePdf(DashboardStats stats, DateTimeRange range, dynamic branch) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final pdfBytes = await PdfService.generateBusinessReportPdf(
        stats: stats,
        range: range,
        branch: branch,
      );

      // Hide loading
      Navigator.pop(context);

      final fileName = 'BusinessReport_${DateFormat('ddMMyy').format(range.start)}_to_${DateFormat('ddMMyy').format(range.end)}.pdf';
      
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName,
      );
    } catch (e) {
      // Hide loading
      Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate report: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(businessReportProvider);
    final range = ref.watch(reportDateRangeProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    Widget content = statsAsync.when(
      data: (stats) => _buildReportBody(context, stats, range, isMobile),
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.maroon)),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );

    if (widget.useShell) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('REPORTS & ANALYTICS', 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5, color: AppTheme.maroon)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          statsAsync.maybeWhen(
            data: (stats) => IconButton(
              icon: const Icon(Icons.download_rounded, color: AppTheme.maroon),
              onPressed: () => _handleDownloadReport(stats, range),
              tooltip: 'Download PDF Report',
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: EditorialBackground(child: content),
    );
  }

  Widget _buildReportBody(BuildContext context, DashboardStats stats, DateTimeRange range, bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildPeriodSelector()),
              if (widget.useShell) ...[
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.download_rounded, color: AppTheme.maroon),
                    onPressed: () => _handleDownloadReport(stats, range),
                    tooltip: 'Download PDF Report',
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          
          _buildDateInfo(range),
          const SizedBox(height: 20),

          // KPI Grid - Responsive Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 2;
              double aspectRatio = 1.4;

              if (width > 900) {
                crossAxisCount = 3;
                aspectRatio = 1.8;
              } else if (width > 600) {
                crossAxisCount = 3;
                aspectRatio = 1.5;
              } else if (width < 350) {
                crossAxisCount = 1;
                aspectRatio = 2.0;
              }

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
                children: [
                  KpiCard(
                    title: 'Total Revenue',
                    value: '₹${NumberFormat('#,##,###').format(stats.totalRevenue)}',
                    icon: Icons.payments_outlined,
                    color: AppTheme.maroon,
                  ),
                  KpiCard(
                    title: 'Total Orders',
                    value: stats.totalOrders.toString(),
                    icon: Icons.receipt_outlined,
                    color: Colors.blue,
                  ),
                  KpiCard(
                    title: 'Avg Ticket Size',
                    value: '₹${stats.avgOrderValue.toStringAsFixed(0)}',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          
          // Analysis Sections
          if (MediaQuery.of(context).size.width > 900)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: RevenueTrendChart(salesData: stats.hourlySales)),
                const SizedBox(width: 20),
                Expanded(flex: 1, child: _buildProductList(stats.topProducts)),
              ],
            )
          else ...[
            RevenueTrendChart(salesData: stats.hourlySales),
            const SizedBox(height: 20),
            _buildProductList(stats.topProducts),
          ],
          
          const SizedBox(height: 24),
          
          // Adaptive height for payment split
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: isMobile ? 600 : 400,
            ),
            child: PaymentMethodSplit(split: stats.paymentSplit),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Row(
        children: ['Daily', 'Monthly', 'Yearly'].map((p) {
          final isSelected = _selectedPeriod == p;
          return Expanded(
            child: GestureDetector(
              onTap: () => _updateRange(p),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.maroon : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList()
          ..add(
            Expanded(
              child: GestureDetector(
                onTap: _selectCustomRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == 'Custom' ? AppTheme.maroon : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.date_range_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildDateInfo(DateTimeRange range) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.maroon.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.maroon.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, size: 16, color: AppTheme.maroon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.maroon, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<dynamic> topProducts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOP PERFORMING PRODUCTS',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (topProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No data for this period', style: TextStyle(color: Colors.grey))),
            )
          else
            ...topProducts.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: AppTheme.maroon.withOpacity(0.1), shape: BoxShape.circle),
                    child: Center(
                      child: Text((topProducts.indexOf(p) + 1).toString(), 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.maroon, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${p.quantity.toInt()} units sold', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text('₹${NumberFormat('#,###').format(p.revenue)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
