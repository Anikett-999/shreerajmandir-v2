import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../domain/models/bill_model.dart';
import '../../domain/models/table_model.dart';
import '../../services/billing_service.dart';
import '../../services/print_service.dart';

class BillingScreen extends StatefulWidget {
  final TableModel table;
  const BillingScreen({super.key, required this.table});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
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
      final printService = PrintService();

      final bill = await billingService.generateBill(
        orderId: widget.table.activeOrderId!,
        tableId: widget.table.tableId,
        discountPercent: double.tryParse(_discountController.text) ?? 0,
        extraCharges: double.tryParse(_extraChargesController.text) ?? 0,
        payments: [Payment(mode: _selectedPaymentMode, amount: _total)],
        userId: 'admin', // TODO: Get from auth
      );

      // Print Bill
      final bytes = await printService.generateBillBytes(bill);
      await printService.sendToRawBT(bytes);

      // Finalize and Clear
      await billingService.finalizeAndClearTable(widget.table.tableId, widget.table.activeOrderId!);

      if (mounted) {
        Navigator.pop(context); // Go back to Home
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Bill Generated & Table Cleared!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() => _isLoading = false);
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
