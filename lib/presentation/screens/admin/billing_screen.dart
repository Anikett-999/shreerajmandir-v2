import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../domain/models/bill_model.dart';
import '../../../domain/models/table_model.dart';
import '../../../services/billing_service.dart';
import '../../../services/print_service.dart';
import '../../providers/printer_provider.dart';
import '../../providers/auth_provider.dart';

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

  Map<String, dynamic>? _billPreview;

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
    final billingService = BillingService();
    final preview = await billingService.previewBill(widget.table.activeOrderId!);
    setState(() => _billPreview = preview);
  }

  double get _total {
    if (_billPreview == null) return 0.0;
    double subtotal = _billPreview!['subtotal'];
    double discount = double.tryParse(_discountController.text) ?? 0;
    double extra = double.tryParse(_extraChargesController.text) ?? 0;
    return (subtotal - (subtotal * discount / 100)) + extra;
  }

  Future<void> _handleGenerateBill() async {
    setState(() => _isLoading = true);
    try {
      final billingService = BillingService();
      final config = ref.read(printerConfigProvider);
      final printService = ref.read(printServiceProvider);
      final currentUser = ref.read(authServiceProvider).currentUser;
      final cleanUserName = currentUser?.displayName ?? currentUser?.email?.split('@')[0] ?? 'Admin';

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
        await printService.printReceipt(bytes, config);
      } catch (printErr) {
        printSuccess = false;
        printError = printErr.toString();
      }

      if (!printSuccess && mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.print_disabled, color: Colors.orange),
                SizedBox(width: 8),
                Text('Print Failed'),
              ],
            ),
            content: Text(
                'Bill was saved to system, but printing failed.\n\nError: $printError\n\nDo you want to retry printing or finish settling?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('RETRY PRINT'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
                child: const Text('FINISH ANYWAY'),
              ),
            ],
          ),
        );

        if (proceed != true) {
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
    if (_billPreview == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final List<BillItem> items = _billPreview!['items'];
    final double subtotal = _billPreview!['subtotal'];

    return Scaffold(
      appBar: AppBar(title: Text('Billing - ${widget.table.name}')),
      body: Row(
        children: [
          // 1. Bill Summary (Left)
          Expanded(
            flex: 2,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Qty: ${item.qty}'),
                  trailing: Text('₹${(item.price * item.qty).toStringAsFixed(0)}', style: const TextStyle(fontSize: 16)),
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),

          // 2. Billing Controls (Right)
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('BILL DETAILS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _discountController,
                    decoration: const InputDecoration(labelText: 'Discount (%)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.percent)),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _extraChargesController,
                    decoration: const InputDecoration(labelText: 'Extra Charges', border: OutlineInputBorder(), prefixIcon: Icon(Icons.add_circle_outline)),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Spacer(),
                  const Text('PAYMENT MODE', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Cash', 'UPI', 'Card'].map((mode) {
                      return ChoiceChip(
                        label: Text(mode),
                        selected: _selectedPaymentMode == mode,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedPaymentMode = mode);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  _buildSummaryRow('TOTAL', '₹${_total.toStringAsFixed(0)}', isTotal: true),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGenerateBill,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusOccupied, foregroundColor: Colors.white),
                      child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('PRINT & SETTLE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 24 : 18, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(
          fontSize: isTotal ? 32 : 20, 
          fontWeight: FontWeight.bold,
          color: isTotal ? AppTheme.maroon : null,
        )),
      ],
    );
  }
}
