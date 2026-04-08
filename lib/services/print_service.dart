import 'dart:convert';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import 'package:intl/intl.dart';

class PrintService {
  // Generate KOT ESC/POS commands
  Future<List<int>> generateKOTBytes(KOTModel kot) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('KOT #${kot.kotNumber}', 
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    bytes += generator.text('Table: ${kot.tableId}', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('Time: ${DateFormat('HH:mm').format(kot.createdAt)}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    for (var item in kot.items) {
      bytes += generator.row([
        PosColumn(text: item.name, width: 9),
        PosColumn(text: 'x${item.qty}', width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
      if (item.note.isNotEmpty) {
        bytes += generator.text('Note: ${item.note}');
      }
    }
    
    bytes += generator.hr();
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  // Generate Bill ESC/POS commands
  Future<List<int>> generateBillBytes(BillModel bill) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('SHREE RAJMANDIR', 
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    bytes += generator.text('Ice Cream POS', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.text('Bill ID: ${bill.billId.substring(0, 8)}', styles: const PosStyles(bold: true));
    bytes += generator.text('Table: ${bill.tableId}');
    bytes += generator.text('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(bill.createdAt)}');
    bytes += generator.hr();

    for (var item in bill.items) {
      bytes += generator.row([
        PosColumn(text: item.name, width: 7),
        PosColumn(text: '${item.qty}', width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: (item.price * item.qty).toStringAsFixed(0), width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Subtotal', width: 8),
      PosColumn(text: bill.subtotal.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    if (bill.discountAmount > 0) {
      bytes += generator.row([
        PosColumn(text: 'Discount (${bill.discountPercent}%)', width: 8),
        PosColumn(text: '-${bill.discountAmount.toStringAsFixed(2)}', width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    if (bill.extraCharges > 0) {
      bytes += generator.row([
        PosColumn(text: 'Extra Charges', width: 8),
        PosColumn(text: '+${bill.extraCharges.toStringAsFixed(2)}', width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.text('TOTAL: ${bill.total.toStringAsFixed(2)}', 
        styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    
    bytes += generator.hr();
    bytes += generator.text('Thank You!', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  // Print via RawBT (Android)
  Future<void> sendToRawBT(List<int> bytes) async {
    try {
      final String base64Data = base64.encode(bytes);
      final String url = 'rawbt:base64,$base64Data';
      
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not launch RawBT app. Is it installed?');
      }
    } catch (e) {
      print('❌ Print Error: $e');
      rethrow;
    }
  }
}
