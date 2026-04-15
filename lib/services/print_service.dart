import 'dart:ui' as ui;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/branch_model.dart';
import '../domain/models/printer_config.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
  Future<List<int>> generateBillBytes(BillModel bill, BranchModel branch, PrinterPaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      paperSize == PrinterPaperSize.mm80 ? PaperSize.mm80 : PaperSize.mm58, 
      profile
    );
    List<int> bytes = [];

    bytes += [0x1B, 0x40]; 
    bytes += [0x1D, 0x4C, 0x00, 0x00]; 

    final int maxChars = paperSize == PrinterPaperSize.mm80 ? 48 : 32;
    final String sep = '-' * maxChars;
    final String dsep = '=' * maxChars;

    // Helper for Bill rows (Optimized for 80mm/48chars)
    String formatBillRow(String name, String qty, String amt) {
      if (maxChars == 48) {
        // [Item: 32] + [Qty: 6] + [Amt: 10] = 48
        // We use 30 for name to leave some padding
        String s1 = name.padRight(32).substring(0, 32);
        String s2 = qty.padLeft(6).substring(0, 6);
        String s3 = amt.padLeft(10).substring(0, 10);
        return s1 + s2 + s3;
      } else {
        // fallback for 58mm
        String s1 = name.padRight(18).substring(0, 18);
        String s2 = qty.padLeft(5).substring(0, 5);
        String s3 = amt.padLeft(9).substring(0, 9);
        return s1 + s2 + s3;
      }
    }

    // 1. Branding Header
    bytes += generator.text(dsep);
    bytes += generator.text('SHREE RAJMANDIR', 
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    bytes += generator.text(branch.location.toUpperCase(), styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(branch.address, styles: const PosStyles(align: PosAlign.center));
    if (branch.phone.isNotEmpty) {
      bytes += generator.text('Phone: ${branch.phone}', styles: const PosStyles(align: PosAlign.center));
    }
    bytes += generator.feed(1);

    // 2. Metadata (Professional Layout)
    // Professional Row: Bill ID (Left) | Date (Center) | Time & by:User (Right)
    final dateStr = DateFormat('dd/MM/yy').format(bill.createdAt);
    final timeStr = DateFormat('hh:mm a').format(bill.createdAt);
    final shortUser = bill.userName.length > 5 ? bill.userName.substring(0, 5) : bill.userName;
    final timeAndBy = "$timeStr by:$shortUser";
    
    // Calculate spacing for 48 chars
    // [ID: 15] [Date: 10] [Time/By: 23] = 48
    String idPart = bill.billId.padRight(15).substring(0, 15);
    String datePart = dateStr.padLeft(11).padRight(16); // Centerish
    String rightPart = timeAndBy.padLeft(17);
    
    bytes += generator.text(idPart + datePart + rightPart);
    bytes += generator.text('TABLE: ${bill.tableName.toUpperCase()}', styles: const PosStyles(bold: true, align: PosAlign.center));
    
    bytes += generator.text(sep);
    bytes += generator.text(formatBillRow('ITEMS', 'QTY', 'AMOUNT'), styles: const PosStyles(bold: true));
    bytes += generator.text(sep);

    // 3. Items List (with Category prefix)
    for (var item in bill.items) {
      String itemName = item.category.isNotEmpty ? "[${item.category.toUpperCase()}] ${item.name}" : item.name;
      bytes += generator.text(formatBillRow(itemName, '${item.qty}', (item.price * item.qty).toStringAsFixed(0)));
      // Sub-item spacing
      bytes += generator.text(sep);
    }

    // 4. Totals Logic
    String formatTotalLine(String label, String value) {
      return label.padRight(maxChars - value.length) + value;
    }

    bytes += generator.text(formatTotalLine('Subtotal', 'Rs. ${bill.subtotal.toStringAsFixed(2)}'));

    if (bill.discountAmount > 0) {
      final discountLabel = bill.discountType == 'flat'
          ? 'Discount (Flat)'
          : 'Discount (${bill.discountPercent.toStringAsFixed(0)}%)';
      bytes += generator.text(formatTotalLine(discountLabel, '-Rs. ${bill.discountAmount.toStringAsFixed(2)}'));
    }

    if (bill.extraCharges > 0) {
      bytes += generator.text(formatTotalLine('Extra Charges', '+Rs. ${bill.extraCharges.toStringAsFixed(2)}'));
    }

    bytes += generator.text(sep);
    
    // Total Amount (Double Height, Right Aligned)
    final String totalStr = 'Rs.${bill.total.toStringAsFixed(2)}';
    bytes += generator.text('GRAND TOTAL'.padRight(maxChars - totalStr.length) + totalStr, 
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    
    bytes += generator.text(dsep);
    
    // 5. Footer (Side-by-Side QR & Branding)
    if (branch.reviewQrUrl.isNotEmpty || branch.instagramId.isNotEmpty) {
      bytes += generator.feed(1);
      try {
        final int imageWidth = paperSize == PrinterPaperSize.mm80 ? 512 : 384; // Leave margins
        final footerImg = await _generateFooterGraphic(branch, imageWidth);
        if (footerImg != null) {
          bytes += generator.image(footerImg);
        } else {
           bytes += generator.text('Visit Again!', styles: const PosStyles(align: PosAlign.center));
        }
      } catch (e) {
        print("Error generating footer image: $e");
        bytes += generator.text('Visit Again!', styles: const PosStyles(align: PosAlign.center));
      }
    } else {
      bytes += generator.text('Visit Again!', styles: const PosStyles(align: PosAlign.center));
    }
    
    bytes += generator.text('THANK YOU', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(dsep);
    bytes += generator.feed(2);
    bytes += generator.cut();
    
    return bytes;
  }

  // Master Print Function
  Future<bool> printReceipt(List<int> bytes, PrinterConfig config) async {
    if (config.connectionType == PrinterConnectionType.rawbt && Platform.isAndroid) {
      try {
        await sendToRawBT(bytes);
        return true; // Sent to external app successfully
      } catch (e) {
        return false;
      }
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
      print(' Connecting to ${config.connectionType.name} at ${config.address}...');
      
      // Use a timeout for connection
      final connected = await PrinterManager.instance.connect(
        type: type,
        model: model,
      ).timeout(const Duration(seconds: 5), onTimeout: () {
        print(' Connection Timeout');
        return false;
      });

      if (!connected) {
        print(' Failed to connect to printer');
        return false;
      }

      // Give Bluetooth printers a moment to initialize after connection
      if (type == PrinterType.bluetooth) {
        print(' Bluetooth connected, waiting for initialization...');
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      print(' Sending ${bytes.length} bytes to printer...');
      final sent = await PrinterManager.instance.send(type: type, bytes: bytes);
      
      if (!sent) {
        print(' Failed to send bytes to printer');
        return false;
      }
      
      // Short delay for some printers to finish processing before disconnect
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('🔌 Disconnecting...');
      await PrinterManager.instance.disconnect(type: type);
      print(' Print Job Completed.');
      return true;
    } catch (e) {
      print(' Native Print Error: $e');
      return false;
    }
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
      print(' Print Error: $e');
      rethrow;
    }
  }

  /// Generates a side-by-side footer graphic with a framed QR code and a warm message.
  Future<img.Image?> _generateFooterGraphic(BranchModel branch, int totalWidth) async {
    const double height = 180.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, totalWidth.toDouble(), height));
    
    // Background (White)
    final paint = ui.Paint()..color = Colors.white;
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, totalWidth.toDouble(), height), paint);

    // 1. Left Side: Framed QR Code
    final double qrBoxSize = 140.0;
    final double qrX = 10.0;
    final double qrY = (height - qrBoxSize) / 2;

    if (branch.reviewQrUrl.isNotEmpty) {
      // Draw Thin Frame
      final framePaint = ui.Paint()
        ..color = Colors.black
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(ui.Rect.fromLTWH(qrX, qrY, qrBoxSize, qrBoxSize), const Radius.circular(8)), 
        framePaint
      );

      // Label above QR
      final textPainter = TextPainter(
        textDirection: ui.TextDirection.ltr,
        text: const TextSpan(
          text: 'REVIEW US',
          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      )..layout();
      textPainter.paint(canvas, ui.Offset(qrX + (qrBoxSize - textPainter.width) / 2, qrY - 12));

      // Draw QR Code
      final qrValidationResult = QrValidator.validate(
        data: branch.reviewQrUrl,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode!;
        final painter = QrPainter.withQr(
          qr: qrCode,
          color: const Color(0xFF000000),
          emptyColor: const Color(0xFFFFFFFF),
          gapless: true,
        );
        
        // Draw centered inside the box with some padding
        const double padding = 15.0;
        canvas.save();
        canvas.translate(qrX + padding, qrY + padding);
        painter.paint(canvas, ui.Size(qrBoxSize - padding * 2, qrBoxSize - padding * 2));
        canvas.restore();
      }
    }

    // 2. Right Side: Warm Message + Instagram
    final double textLeft = qrBoxSize + 30.0;
    final double textWidth = totalWidth - textLeft - 10.0;

    const String warmMessage = "Crafted with love, served with a smile. Every scoop tells a story of pure cream and joy!";
    
    // Message text
    final messagePainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: ui.TextAlign.left,
      text: const TextSpan(
        text: warmMessage,
        style: TextStyle(color: Colors.black, fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
      ),
    )..layout(maxWidth: textWidth);
    messagePainter.paint(canvas, ui.Offset(textLeft, qrY + 10));

    // Instagram Handle
    if (branch.instagramId.isNotEmpty) {
      final igPainter = TextPainter(
        textDirection: ui.TextDirection.ltr,
        text: TextSpan(
          children: [
            const TextSpan(text: 'FOLLOW US ', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            TextSpan(text: '@${branch.instagramId}', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900)),
          ],
        ),
      )..layout(maxWidth: textWidth);
      igPainter.paint(canvas, ui.Offset(textLeft, qrY + messagePainter.height + 25));
    }

    // Convert to Image
    final picture = recorder.endRecording();
    final img_ui = await picture.toImage(totalWidth, height.toInt());
    final byteData = await img_ui.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData == null) return null;
    
    // Decode into 'image' package format for esc_pos_utils
    final decoded = img.decodePng(byteData.buffer.asUint8List());
    return decoded;
  }
}
