import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/models/bill_model.dart';
import '../domain/models/dashboard_stats.dart';
import '../domain/models/branch_model.dart';

class PdfService {
  static Future<Uint8List> generateBillPdf(BillModel bill) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd/MM/yy').format(bill.createdAt);
    final timeStr = DateFormat('hh:mm a').format(bill.createdAt);
    final shortUser = bill.userName.length > 5 ? bill.userName.substring(0, 5) : bill.userName;

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
                    pw.Text('QUALITY ICE CREAM & SNACKS', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 5),
                    pw.Text('DIGITAL RECEIPT',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),

              // Metadata Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(bill.billId, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  pw.Text(dateStr, style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('$timeStr by:$shortUser', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.Center(child: pw.Text('TABLE: ${bill.tableName.toUpperCase()}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
              pw.Divider(thickness: 0.5),

              // Items Header
              pw.Row(
                children: [
                  pw.Expanded(
                      flex: 4,
                      child: pw.Text('ITEMS',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('QTY',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center)),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('AMOUNT',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider(thickness: 0.5),

              // Items
              ...bill.items.map((item) {
                final itemName = item.category.isNotEmpty ? "[${item.category.toUpperCase()}] ${item.name}" : item.name;
                return pw.Column(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 4,
                              child: pw.Text(itemName,
                                  style: const pw.TextStyle(fontSize: 8))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text(item.qty.toString(),
                                  style: const pw.TextStyle(fontSize: 9),
                                  textAlign: pw.TextAlign.center)),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                  (item.price * item.qty).toStringAsFixed(0),
                                  style: const pw.TextStyle(fontSize: 9),
                                  textAlign: pw.TextAlign.right)),
                        ],
                      ),
                    ),
                    pw.Divider(thickness: 0.2, borderStyle: pw.BorderStyle.dashed),
                  ],
                );
              }),

              pw.SizedBox(height: 5),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Rs. ${bill.subtotal.toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              if (bill.discountAmount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Discount (${bill.discountPercent.toStringAsFixed(0)}%):',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('-Rs. ${bill.discountAmount.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              if (bill.extraCharges > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Extra Charges:', style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('+Rs. ${bill.extraCharges.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              pw.Divider(thickness: 0.5),
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
                    pw.Text('Visit Again!', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('THANK YOU', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
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

  static Future<Uint8List> generateBusinessReportPdf({
    required DashboardStats stats,
    required DateTimeRange range,
    required BranchModel branch,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');
    final rangeStr = "${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}";
    final timestampStr = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 16),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount} | Generated on $timestampStr',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // Header Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(branch.branchName.toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    pw.Text(branch.address, style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Phone: ${branch.phone}', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('BUSINESS REPORT',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                    pw.Text(rangeStr, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 2, color: PdfColors.blue900),
            pw.SizedBox(height: 20),

            // Financial Summary Section
            pw.Text('FINANCIAL PERFORMANCE',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                _buildStatBox('GROSS SALES', 'Rs. ${stats.grossSales.toStringAsFixed(2)}', PdfColors.blue),
                pw.SizedBox(width: 10),
                _buildStatBox('DISCOUNTS', 'Rs. ${stats.totalDiscounts.toStringAsFixed(2)}', PdfColors.red),
                pw.SizedBox(width: 10),
                _buildStatBox('NET EARNINGS', 'Rs. ${stats.totalRevenue.toStringAsFixed(2)}', PdfColors.green, isPrimary: true),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                _buildStatBox('TOTAL ORDERS', '${stats.totalOrders}', PdfColors.orange),
                pw.SizedBox(width: 10),
                _buildStatBox('AVG TICKET', 'Rs. ${stats.avgOrderValue.toStringAsFixed(2)}', PdfColors.purple),
              ],
            ),
            pw.SizedBox(height: 30),

            // Payment Distribution
            pw.Text('PAYMENT DISTRIBUTION',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('Payment Mode', isHeader: true),
                    _buildTableCell('Amount', isHeader: true, alignRight: true),
                    _buildTableCell('% Of Total', isHeader: true, alignRight: true),
                  ],
                ),
                ...stats.paymentSplit.entries.map((entry) {
                  final percent = stats.totalRevenue > 0 ? (entry.value / stats.totalRevenue) * 100 : 0.0;
                  return pw.TableRow(
                    children: [
                      _buildTableCell(entry.key.toUpperCase()),
                      _buildTableCell('Rs. ${entry.value.toStringAsFixed(2)}', alignRight: true),
                      _buildTableCell('${percent.toStringAsFixed(1)}%', alignRight: true),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 30),

            // Top Products
            pw.Text('TOP PERFORMING PRODUCTS',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FixedColumnWidth(40),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('#', isHeader: true),
                    _buildTableCell('Product Name', isHeader: true),
                    _buildTableCell('Qty', isHeader: true, alignRight: true),
                    _buildTableCell('Revenue', isHeader: true, alignRight: true),
                  ],
                ),
                ...stats.topProducts.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final product = entry.value;
                  return pw.TableRow(
                    children: [
                      _buildTableCell(index.toString()),
                      _buildTableCell(product.name),
                      _buildTableCell(product.quantity.toString(), alignRight: true),
                      _buildTableCell('Rs. ${product.revenue.toStringAsFixed(2)}', alignRight: true),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildStatBox(String label, String value, PdfColor color, {bool isPrimary = false}) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 2),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          color: isPrimary ? color.luminance > 0.5 ? PdfColors.white : color : PdfColors.white,
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: color)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: isPrimary ? PdfColors.black : color)),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static Future<File> savePdfToFile(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
