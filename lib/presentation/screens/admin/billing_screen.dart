import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/app_theme.dart';
import '../../../domain/models/bill_model.dart';
import '../../../domain/models/kot_model.dart';
import '../../../domain/models/table_model.dart';
import '../../../services/billing_service.dart';
import '../../../services/print_service.dart';
import '../../../services/pdf_service.dart';
import '../../providers/printer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/active_branch_provider.dart';
import '../../widgets/admin/bill_aggregated_list.dart';

class BillingScreen extends ConsumerStatefulWidget {
  final TableModel table;
  const BillingScreen({super.key, required this.table});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  final _discountController = TextEditingController(text: '0');
  final _extraChargesController = TextEditingController(text: '0');
  String _selectedPaymentMode = 'Cash';
  bool _isLoading = false;

  Map<String, dynamic>? _billPreviewData;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void dispose() {
    _discountController.dispose();
    _extraChargesController.dispose();
    super.dispose();
  }

  Future<void> _loadPreview() async {
    if (widget.table.activeOrderId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active order found for this table')),
        );
        Navigator.pop(context);
      }
      return;
    }
    final branchId = ref.read(activeBranchIdProvider);
    final billingService = BillingService(branchId: branchId ?? 'branch_001');
    final preview = await billingService.previewBill(widget.table.activeOrderId!);
    setState(() => _billPreviewData = preview);
  }

  double get _total {
    if (_billPreviewData == null) return 0.0;
    double subtotal = _billPreviewData!['subtotal'];
    double discount = double.tryParse(_discountController.text) ?? 0;
    double extra = double.tryParse(_extraChargesController.text) ?? 0;
    return (subtotal - (subtotal * discount / 100)) + extra;
  }

  Future<void> _handleShareDigitalBill(BillModel bill) async {
    try {
      final pdfBytes = await PdfService.generateBillPdf(bill);
      final fileName = 'Bill_${bill.tableName}_${DateFormat('ddMMyy_HHmm').format(bill.createdAt)}.pdf';
      final file = await PdfService.savePdfToFile(pdfBytes, fileName);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'E-Bill for Table ${bill.tableName} at Shree Rajmandir',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to share bill: $e')));
      }
    }
  }

  Future<void> _handleGenerateBill() async {
    setState(() => _isLoading = true);
    try {
      final branchId = ref.read(activeBranchIdProvider);
      final billingService = BillingService(branchId: branchId ?? 'branch_001');
      final config = ref.read(printerConfigProvider);
      final printService = ref.read(printServiceProvider);
      final currentUser = ref.read(authServiceProvider).currentUser;
      final cleanUserName = currentUser?.displayName ?? currentUser?.email?.split('@')[0] ?? 'Admin';

      if (widget.table.activeOrderId == null) {
        throw Exception('Cannot generate bill: Missing Order ID');
      }

      final bill = await billingService.generateBill(
        orderId: widget.table.activeOrderId!,
        tableId: widget.table.tableId,
        tableName: widget.table.name,
        userName: cleanUserName,
        discountPercent: double.tryParse(_discountController.text) ?? 0,
        extraCharges: double.tryParse(_extraChargesController.text) ?? 0,
        payments: [Payment(mode: _selectedPaymentMode, amount: _total)],
        userId: currentUser?.uid ?? 'admin',
      );

      // Print Bill Integration
      bool printSuccess = true;
      String? printError;

      try {
        final bytes = await printService.generateBillBytes(bill, config.paperSize);
        printSuccess = await printService.printReceipt(bytes, config);
      } catch (printErr) {
        printSuccess = false;
        printError = printErr.toString();
      }

      if (!printSuccess && mounted) {
        final finishAnyway = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.print_disabled, color: Colors.orange),
                SizedBox(width: 8),
                Text('Print Issue'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('The bill was saved to the system, but the thermal printer is unreachable.'),
                if (printError != null) Text('\nError: $printError', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),
                const Text('Would you like to share a digital copy via WhatsApp or finish anyway?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Returns to retry logic
                child: const Text('RETRY PRINT'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _handleShareDigitalBill(bill);
                  if (context.mounted) Navigator.pop(context, true); // Trigger finalize after share
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.share),
                label: const Text('SHARE WHATSAPP'),
              ),
            ],
          ),
        );

        if (finishAnyway != true) {
          // If they chose retry (returned false), we trigger the printing part again
          setState(() => _isLoading = false);
          return _handleGenerateBill();
        }
      }

      // Finalize and Clear
      await billingService.finalizeAndClearTable(widget.table.tableId, widget.table.activeOrderId!);

      if (mounted) {
        Navigator.pop(context); // Go back to Home
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Bill Generated & Table Cleared!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_billPreviewData == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final List<BillItem> items = _billPreviewData!['items'];
    final double subtotal = _billPreviewData!['subtotal'];
    final List<KOTModel> kots = _billPreviewData!['kots'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing/Checkout - ${widget.table.name}', 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPreview,
            tooltip: 'Refresh Items',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // Desktop/Tablet 3-Panel Layout
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Panel 1: KOT History (25%)
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  child: _buildKOTHistoryPanel(kots),
                ),
                const VerticalDivider(width: 1),
                
                // Panel 2: Aggregated Preview (40%)
                Expanded(
                  flex: 4,
                  child: _buildBillPreviewPanel(items),
                ),
                const VerticalDivider(width: 1),

                // Panel 3: Settlement (35%)
                SizedBox(
                  width: constraints.maxWidth * 0.35,
                  child: _buildSettlementPanel(subtotal),
                ),
              ],
            );
          } else {
            // Mobile Stacked Layout - Modern & Professional
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text('ORDER HISTORY', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                      const SizedBox(height: 12),
                      _buildKOTHistoryPanel(kots, shrinkWrap: true),
                      
                      const SizedBox(height: 24),
                      const Text('BILL PREVIEW', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.maroon)),
                      const SizedBox(height: 12),
                      BillAggregatedList(items: items),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // Persistent Settlement Panel at bottom for Mobile
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
                    ],
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              Text('₹${_total.toStringAsFixed(2)}', 
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.maroon)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildMobileActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMobileActionButtons() {
    return Row(
      children: [
        // Discount/Extra trigger
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showAdjustmentDialog(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ADJUSTMENTS'),
          ),
        ),
        const SizedBox(width: 12),
        // Primary Print & Settle
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleGenerateBill,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.statusOccupied,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: _isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const FittedBox(
                  child: Text('PRINT & SETTLE', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
          ),
        ),
      ],
    );
  }

  void _showAdjustmentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24, right: 24, top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Bill Adjustments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(labelText: 'Discount (%)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.percent)),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _extraChargesController,
              decoration: const InputDecoration(labelText: 'Extra Charges (₹)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.add_circle_outline)),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text('PAYMENT MODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: ['Cash', 'UPI', 'Card'].map((mode) {
                final isSelected = _selectedPaymentMode == mode;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedPaymentMode = mode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.maroon : Colors.white,
                          border: Border.all(color: isSelected ? AppTheme.maroon : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.maroon, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('APPLY'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKOTHistoryPanel(List<KOTModel> kots, {bool shrinkWrap = false}) {
    return Container(
      color: shrinkWrap ? Colors.transparent : Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!shrinkWrap)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.history, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Text('KOT HISTORY (${kots.length})', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                ],
              ),
            ),
          if (!shrinkWrap) 
            Expanded(
              child: _buildKOTList(kots, shrinkWrap),
            )
          else 
            _buildKOTList(kots, shrinkWrap),
        ],
      ),
    );
  }

  Widget _buildKOTList(List<KOTModel> kots, bool shrinkWrap) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: kots.length,
      itemBuilder: (context, index) {
        final kot = kots[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.maroon.withOpacity(0.1),
                child: Text('${index + 1}', style: const TextStyle(color: AppTheme.maroon, fontWeight: FontWeight.bold)),
              ),
              title: Text('KOT #${kot.kotNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(DateFormat('hh:mm a').format(kot.createdAt)),
              children: kot.items.map((item) => ListTile(
                dense: true,
                title: Text(item.name),
                trailing: Text('x${item.qty}', style: const TextStyle(fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillPreviewPanel(List<BillItem> items) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons. receipt_long, color: AppTheme.maroon),
              SizedBox(width: 8),
              Text('BILL PREVIEW', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.maroon)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: BillAggregatedList(items: items),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementPanel(double subtotal, {bool isMobile = false}) {
    final settlementContent = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('SETTLEMENT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          // Summary Rows
          _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          
          // Discount Input
          TextField(
            controller: _discountController,
            decoration: InputDecoration(
              labelText: 'Discount (%)', 
              border: const OutlineInputBorder(), 
              prefixIcon: const Icon(Icons.percent, color: Colors.blue),
              filled: true,
              fillColor: Colors.blue.withOpacity(0.05),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          
          // Extra Charges Input
          TextField(
            controller: _extraChargesController,
            decoration: InputDecoration(
              labelText: 'Extra Charges (₹)', 
              border: const OutlineInputBorder(), 
              prefixIcon: const Icon(Icons.add_circle_outline, color: Colors.green),
              filled: true,
              fillColor: Colors.green.withOpacity(0.05),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 24),
          const Text('PAYMENT MODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          
          // Payment Mode Selector
          Row(
            children: ['Cash', 'UPI', 'Card'].map((mode) {
              final isSelected = _selectedPaymentMode == mode;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => setState(() => _selectedPaymentMode = mode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.maroon : Colors.white,
                        border: Border.all(color: isSelected ? AppTheme.maroon : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        mode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (!isMobile) const Spacer(),
          if (isMobile) const SizedBox(height: 32),
          
          const Divider(),
          const SizedBox(height: 16),
          
          // Grand Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.maroon.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.maroon.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text('GRAND TOTAL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.maroon)),
                Text('₹${_total.toStringAsFixed(2)}', 
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.maroon)),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Primary Action
          SizedBox(
            height: 64,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleGenerateBill,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.statusOccupied, 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('PRINT & SETTLE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Table will be cleared', style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white70)),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: settlementContent,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: settlementContent,
            ),
          ),
        );
      }
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
