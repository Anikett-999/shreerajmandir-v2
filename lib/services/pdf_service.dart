import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/models/bill_model.dart';

class PdfService {
  static Future<Uint8List> generateBillPdf(BillModel bill) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd-MMM-yyyy HH:mm').format(bill.createdAt);

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
          marginAll: 5 * PdfPageFormat.mm,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('SHREE RAJMANDIR',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('ICE CREAM & MORE', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 5),
                    pw.Text('DIGITAL RECEIPT',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),

              // Bill Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bill: ${bill.billId.substring(0, 8)}',
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Table: ${bill.tableName}',
                      style: pw.TextStyle(
                          fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Text('Date: $dateStr', style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Cashier: ${bill.userName}', style: const pw.TextStyle(fontSize: 9)),
              pw.Divider(thickness: 0.5),

              // Items Header
              pw.Row(
                children: [
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Item',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Qty',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center)),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Total',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider(thickness: 0.5),

              // Items
              ...bill.items.map((item) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text(item.name,
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text(item.qty.toString(),
                                style: const pw.TextStyle(fontSize: 9),
                                textAlign: pw.TextAlign.center)),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                                (item.price * item.qty).toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 9),
                                textAlign: pw.TextAlign.right)),
                      ],
                    ),
                  )),

              pw.Divider(thickness: 0.5),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(bill.subtotal.toStringAsFixed(2),
                      style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              if (bill.discountAmount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Discount (${bill.discountPercent}%):',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('-${bill.discountAmount.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              if (bill.extraCharges > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Extra Charges:', style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(bill.extraCharges.toStringAsFixed(2),
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL:',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rs. ${bill.total.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(thickness: 1),

              // Footer
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Thank You!', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Visit Again', style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<File> savePdfToFile(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
