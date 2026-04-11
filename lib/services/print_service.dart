import 'dart:convert';
import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/printer_config.dart';
import 'package:intl/intl.dart';

class PrintService {
  // Generate KOT ESC/POS commands
  Future<List<int>> generateKOTBytes(KOTModel kot, PrinterPaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      paperSize == PrinterPaperSize.mm80 ? PaperSize.mm80 : PaperSize.mm58, 
      profile
    );
    List<int> bytes = [];

    // 0. INITIALIZE PRINTER & RESET MARGIN
    bytes += [0x1B, 0x40]; // Initialize
    bytes += [0x1D, 0x4C, 0x00, 0x00]; // GS L 0 0 (Set left margin to 0)

    // Configuration for 80mm vs 58mm
    final int maxChars = paperSize == PrinterPaperSize.mm80 ? 48 : 32;
    
    // Helper for manual rows (C1: Items, C2: Category, C3: Qty)
    String formatKOTRow(String c1, String c2, String c3) {
      // Configuration for 48-character width (Standard 80mm)
      // [Items: 28] + [Gap: 2] + [Cat: 12] + [Gap: 2] + [Qty: 4] = 48
      int w1 = 28; 
      int w2 = 12; 
      int w3 = 4;  
      
      String s1 = c1.padRight(w1).substring(0, w1);
      String s2 = c2.padRight(w2).substring(0, w2);
      String s3 = c3.padLeft(w3).substring(0, w3);
      
      return "$s1  $s2  $s3"; 
    }

    final String sep = '-' * maxChars;
    final String dsep = '=' * maxChars;

    // 1. Header: Large Bold KOT Number
    final String timeStr = DateFormat('hh:mm a').format(kot.createdAt);
    bytes += generator.text(dsep); // Top divider
    bytes += generator.text('KOT #${kot.kotNumber}', 
      styles: const PosStyles(
        bold: true, 
        align: PosAlign.center, 
        height: PosTextSize.size2, 
        width: PosTextSize.size2
      ));
    
    bytes += generator.feed(1);

    // Header Info: Consolidated into ONE line (Table | Time | By)
    final String cleanUserName = kot.userName.isEmpty ? 'Staff' : kot.userName;
    final String printerBy = "by:${cleanUserName.length > 5 ? cleanUserName.substring(0, 5) : cleanUserName}".toLowerCase();
    
    String timeAndBy = "$timeStr           $printerBy"; 
    String tableInfo = ': ${kot.tableName.toString().toUpperCase()}           ';
    
    String headerLine = tableInfo.padRight(maxChars - timeAndBy.length) + timeAndBy;
    bytes += generator.text(headerLine, styles: const PosStyles(bold: true));

    bytes += generator.text(sep);

    // 3-Column Item Header
    bytes += generator.text(formatKOTRow('ITEMS', 'CAT', 'QTY'), styles: const PosStyles(bold: true));
    bytes += generator.text(sep);

    for (var item in kot.items) {
      bytes += generator.text(formatKOTRow(item.name, item.category, '${item.qty}'));
      
      if (item.note.isNotEmpty) {
        bytes += generator.text('  note: ${item.note.toLowerCase()}');
      }
      bytes += generator.text(sep); // Separator between each KOT item
    }
    
    bytes += generator.text(dsep); // Closing divider
    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  // Generate Bill ESC/POS commands
  Future<List<int>> generateBillBytes(BillModel bill, PrinterPaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      paperSize == PrinterPaperSize.mm80 ? PaperSize.mm80 : PaperSize.mm58, 
      profile
    );
    List<int> bytes = [];

    // Reset & Init
    bytes += [0x1B, 0x40]; 
    bytes += [0x1D, 0x4C, 0x00, 0x00]; 

    final int maxChars = paperSize == PrinterPaperSize.mm80 ? 48 : 32;
    final String sep = '-' * maxChars;
    final String dsep = '=' * maxChars;

    // Helper for Bill rows ( Professional 3-column layout)
    String formatBillRow(String name, String qty, String amt) {
      if (paperSize == PrinterPaperSize.mm80) {
        // [Item: 32] + [Qty: 6] + [Amt: 10] = 48
        String s1 = name.padRight(32).substring(0, 32);
        String s2 = qty.padLeft(6).substring(0, 6);
        String s3 = amt.padLeft(10).substring(0, 10);
        return s1 + s2 + s3;
      } else {
        // [Item: 18] + [Qty: 5] + [Amt: 9] = 32
        String s1 = name.padRight(18).substring(0, 18);
        String s2 = qty.padLeft(5).substring(0, 5);
        String s3 = amt.padLeft(9).substring(0, 9);
        return s1 + s2 + s3;
      }
    }

    // 1. Branding Header (Premium Centered)
    bytes += generator.text('SHREE RAJMANDIR', 
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    bytes += generator.text('QUALITY ICE CREAM & SNACKS', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(1);

    // 2. Transaction Info
    bytes += generator.text(dsep);
    bytes += generator.text('TABLE: ${bill.tableName.toUpperCase()}', styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.text(dsep);
    
    final dateStr = DateFormat('dd/MM/yy').format(bill.createdAt);
    final timeStr = DateFormat('hh:mm a').format(bill.createdAt);
    bytes += generator.text('Bill ID: ${bill.billId.substring(0, 8).toUpperCase()}'.padRight(maxChars - dateStr.length) + dateStr);
    bytes += generator.text('Time:   $timeStr'.padRight(maxChars - bill.userName.length) + bill.userName.toLowerCase());
    
    bytes += generator.text(sep);
    bytes += generator.text(formatBillRow('ITEMS', 'QTY', 'AMOUNT'), styles: const PosStyles(bold: true));
    bytes += generator.text(sep);

    // 3. Items List
    for (var item in bill.items) {
      bytes += generator.text(formatBillRow(item.name, '${item.qty}', (item.price * item.qty).toStringAsFixed(0)));
    }

    bytes += generator.text(sep);

    // 4. Totals Logic
    void printTotalLine(String label, String value, {bool isLarge = false}) {
      if (isLarge) {
         bytes += generator.text(label.padRight(maxChars - value.length) + value, 
            styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
      } else {
         bytes += generator.text(label.padRight(maxChars - value.length) + value);
      }
    }

    printTotalLine('Subtotal', 'Rs. ${bill.subtotal.toStringAsFixed(2)}');

    if (bill.discountAmount > 0) {
      printTotalLine('Discount (${bill.discountPercent}%)', '-Rs. ${bill.discountAmount.toStringAsFixed(2)}');
    }

    if (bill.extraCharges > 0) {
      printTotalLine('Extra Charges', '+Rs. ${bill.extraCharges.toStringAsFixed(2)}');
    }

    bytes += generator.text(sep);
    
    // Total Amount (Double Height)
    final String totalStr = 'Rs.${bill.total.toStringAsFixed(2)}';
    bytes += generator.text('GRAND TOTAL'.padRight(maxChars - totalStr.length) + totalStr, 
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    
    bytes += generator.text(dsep);
    
    // 5. Footer
    bytes += generator.feed(1);
    bytes += generator.text('THANK YOU FOR VISITING!', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('HAVE A GREAT DAY', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(dsep);
    bytes += generator.feed(3); 
    bytes += generator.cut();
    
    return bytes;
  }

  // Master Print Function
  Future<bool> printReceipt(List<int> bytes, PrinterConfig config) async {
    print('-----------------------------------------');
    print('🚀 STARTING PRINT JOB');
    print('📡 Protocol: ${config.connectionType.name}');
    print('📍 Address: ${config.address}');
    
    if (config.connectionType == PrinterConnectionType.rawbt && Platform.isAndroid) {
      try {
        print('📱 Invoking RawBT Intent...');
        await sendToRawBT(bytes);
        return true; 
      } catch (e) {
        print('❌ RawBT Error: $e');
        return false;
      }
    }

    if (config.address == null || config.address!.isEmpty) {
      print('⚠️ ERROR: Printer address is NOT CONFIGURED.');
      return false;
    }

    // Direct Printing via flutter_pos_printer_platform
    late PrinterType type;
    late BasePrinterInput model;

    switch (config.connectionType) {
      case PrinterConnectionType.usb:
        type = PrinterType.usb;
        model = UsbPrinterInput(
          name: config.address ?? 'USB Printer',
        );
        break;
      case PrinterConnectionType.network:
        type = PrinterType.network;
        model = TcpPrinterInput(
          ipAddress: config.address ?? '',
          port: config.port,
        );
        break;
      case PrinterConnectionType.bluetooth:
        type = PrinterType.bluetooth;
        model = BluetoothPrinterInput(
          name: config.name,
          address: config.address ?? '',
          isBle: config.isBle,
        );
        break;
      case PrinterConnectionType.rawbt:
        return false;
    }

    try {
      print('🔌 Attempting Connection to ${config.connectionType.name} at ${config.address}...');
      
      final connected = await PrinterManager.instance.connect(
        type: type,
        model: model,
      ).timeout(const Duration(seconds: 7), onTimeout: () {
        print('⏳ CONNECTION TIMEOUT (7s)');
        return false;
      });

      if (!connected) {
        print('❌ CONNECTION FAILED: PrinterManager returned false');
        return false;
      }

      print('✅ CONNECTED! Preparing to send data...');
      
      if (type == PrinterType.bluetooth) {
        print('📡 Initializing Bluetooth delay (1.5s)...');
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      print('📤 Sending ${bytes.length} bytes...');
      final sent = await PrinterManager.instance.send(type: type, bytes: bytes);
      
      if (!sent) {
        print('❌ DATA SEND FAILED');
        return false;
      }
      
      print('🎉 Bytes sent successfully! Waiting for spooling (0.8s)...');
      await Future.delayed(const Duration(milliseconds: 800));
      
      print('🔌 Disconnecting...');
      await PrinterManager.instance.disconnect(type: type);
      print('🏁 PRINT JOB COMPLETED SUCCESSFULLY');
      print('-----------------------------------------');
      return true;
    } catch (e, stack) {
      print('🛑 CRITICAL PRINT ERROR: $e');
      print('Stacktrace: $stack');
      return false;
    }
  }

  // Print via RawBT (Android)
  Future<void> sendToRawBT(List<int> bytes) async {
    try {
      final String base64Data = base64.encode(bytes);
      final String url = 'rawbt:base64,$base64Data';
      
      print('📦 Byte length: ${bytes.length}, B64 length: ${base64Data.length}');
      
      final Uri uri = Uri.parse(url);
      final bool canLaunch = await canLaunchUrl(uri);
      
      print('🔍 RawBT canLaunch: $canLaunch');
      
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('🚀 RawBT launch command sent successfully');
      } else {
        print('❌ ERROR: System says it cannot launch "rawbt:" scheme. Is RawBT installed?');
        throw Exception('Could not launch RawBT app. Please ensure it is installed from Play Store.');
      }
    } catch (e) {
      print('❌ sendToRawBT Error: $e');
      rethrow;
    }
  }
}
