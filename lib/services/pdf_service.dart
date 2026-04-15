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
import '../domain/models/daily_analytics.dart';

class PdfService {
  static Future<Uint8List> generateBillPdf(BillModel bill, BranchModel branch) async {
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
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(branch.location.toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text(branch.address,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 8)),
                    if (branch.phone.isNotEmpty)
                      pw.Text('Phone: ${branch.phone}',
                          style: const pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(height: 5),
                    pw.Text('DIGITAL RECEIPT',
                        style: pw.TextStyle(
                            fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),

              // Metadata Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(bill.billId, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text(dateStr, style: const pw.TextStyle(fontSize: 8)),
                  pw.Text('$timeStr by:$shortUser', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              pw.Center(child: pw.Text('TABLE: ${bill.tableName.toUpperCase()}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
              pw.Divider(thickness: 0.5),

              // Items Header
              pw.Row(
                children: [
                  pw.Expanded(
                      flex: 4,
                      child: pw.Text('ITEMS',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('QTY',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center)),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('AMOUNT',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold),
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
                                  style: const pw.TextStyle(fontSize: 7))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text(item.qty.toString(),
                                  style: const pw.TextStyle(fontSize: 8),
                                  textAlign: pw.TextAlign.center)),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                  (item.price * item.qty).toStringAsFixed(0),
                                  style: const pw.TextStyle(fontSize: 8),
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
                  pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text('Rs. ${bill.subtotal.toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              if (bill.discountAmount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(bill.discountType == 'flat'
                        ? 'Discount (Flat):'
                        : 'Discount (${bill.discountPercent.toStringAsFixed(0)}%):',
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('-Rs. ${bill.discountAmount.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              if (bill.extraCharges > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Extra Charges:', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('+Rs. ${bill.extraCharges.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL:',
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rs. ${bill.total.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // NEW ENHANCED FOOTER (Side-by-Side)
              if (branch.reviewQrUrl.isNotEmpty || branch.instagramId.isNotEmpty)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Left: QR Code Section
                    if (branch.reviewQrUrl.isNotEmpty)
                      pw.Container(
                        width: 70,
                        height: 70,
                        padding: const pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black, width: 0.5),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text('REVIEW US', style: pw.TextStyle(fontSize: 5, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 2),
                            pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: branch.reviewQrUrl,
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    
                    pw.SizedBox(width: 10),

                    // Right: Warm Message & Instagram
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Crafted with love, served with a smile. Every scoop tells a story of pure cream and joy!",
                            style: pw.TextStyle(fontSize: 7, fontStyle: pw.FontStyle.italic),
                          ),
                          if (branch.instagramId.isNotEmpty) ...[
                             pw.SizedBox(height: 5),
                             pw.Row(
                               children: [
                                 pw.Text('FOLLOW US ', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                                 pw.Text('@${branch.instagramId}', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                               ]
                             )
                          ]
                        ],
                      ),
                    ),
                  ],
                ),

              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Visit Again!', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('THANK YOU', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
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
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
          marginLeft: 4 * PdfPageFormat.mm,
          marginRight: 4 * PdfPageFormat.mm,
          marginTop: 8 * PdfPageFormat.mm,
          marginBottom: 8 * PdfPageFormat.mm,
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount} | Generated on $timestampStr',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // Header Section
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(branch.branchName.toUpperCase(),
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  pw.SizedBox(height: 5),
                  pw.Text(branch.address, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Phone: ${branch.phone}', style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 12),
                  pw.Text('BUSINESS REPORT',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  pw.Text(rangeStr, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 30),

            // Financial Summary Section (Stacked for 80mm)
            pw.Text('FINANCIAL PERFORMANCE',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildStatBox('GROSS SALES', 'Rs. ${stats.grossSales.toStringAsFixed(2)}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('DISCOUNTS', 'Rs. ${stats.totalDiscounts.toStringAsFixed(2)}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('NET EARNINGS', 'Rs. ${stats.totalRevenue.toStringAsFixed(2)}', PdfColors.black, isPrimary: true),
            pw.SizedBox(height: 8),
            _buildStatBox('TOTAL ORDERS', '${stats.totalOrders}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('AVG TICKET', 'Rs. ${stats.avgOrderValue.toStringAsFixed(2)}', PdfColors.black),
            pw.SizedBox(height: 40),

            // Payment Distribution
            pw.Text('PAYMENT DISTRIBUTION',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell('Mode', isHeader: true, large: true),
                    _buildTableCell('Amount', isHeader: true, alignRight: true, large: true),
                    _buildTableCell('%', isHeader: true, alignRight: true, large: true),
                  ],
                ),
                ...stats.paymentSplit.entries.map((entry) {
                  final percent = stats.totalRevenue > 0 ? (entry.value / stats.totalRevenue) * 100 : 0.0;
                  return pw.TableRow(
                    children: [
                      _buildTableCell(entry.key.toUpperCase(), large: false),
                      _buildTableCell(entry.value.toStringAsFixed(0), alignRight: true, large: true),
                      _buildTableCell('${percent.toStringAsFixed(0)}%', alignRight: true, large: false),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 40),

            // Top Products
            pw.Text('TOP PERFORMING PRODUCTS',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell('#', isHeader: true, large: true),
                    _buildTableCell('Product Name', isHeader: true, large: true),
                    _buildTableCell('Qty', isHeader: true, alignRight: true, large: true),
                    _buildTableCell('Revenue', isHeader: true, alignRight: true, large: true),
                  ],
                ),
                ...stats.topProducts.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final product = entry.value;
                  return pw.TableRow(
                    children: [
                      _buildTableCell(index.toString(), large: true),
                      _buildTableCell(product.name.toUpperCase(), large: true),
                      _buildTableCell(product.quantity.toString(), alignRight: true, large: true),
                      _buildTableCell('Rs. ${product.revenue.toStringAsFixed(2)}', alignRight: true, large: true),
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
    // Force grayscale for analytics
    final displayColor = PdfColors.black;
    
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: displayColor, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: isPrimary ? PdfColors.grey100 : PdfColors.white,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, bool alignRight = false, bool large = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: large ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: PdfColors.black,
        ),
      ),
    );
  }

  static Future<Uint8List> generateDailyAnalyticsPdf({
    required DailyAnalytics analytics,
    required String dateRangeStr,
    required BranchModel branch,
  }) async {
    final pdf = pw.Document();
    final timestampStr = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
          marginLeft: 4 * PdfPageFormat.mm,
          marginRight: 4 * PdfPageFormat.mm,
          marginTop: 8 * PdfPageFormat.mm,
          marginBottom: 8 * PdfPageFormat.mm,
        ),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount} | Generated on $timestampStr',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // Header Section
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(branch.branchName.toUpperCase(),
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  pw.SizedBox(height: 5),
                  pw.Text(branch.address, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Phone: ${branch.phone}', style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 12),
                  pw.Text('ANALYTICS REPORT',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  pw.Text(dateRangeStr, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 30),

            // Financial Summary Section (Stacked)
            pw.Text('FINANCIAL PERFORMANCE',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildStatBox('TOTAL SALES', 'Rs. ${analytics.totalSales.toStringAsFixed(2)}', PdfColors.black, isPrimary: true),
            pw.SizedBox(height: 8),
            _buildStatBox('TOTAL BILLS', '${analytics.totalBills}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('AVG TICKET', 'Rs. ${(analytics.totalBills > 0 ? analytics.totalSales / analytics.totalBills : 0).toStringAsFixed(2)}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('DISCOUNTS', 'Rs. ${analytics.totalDiscount.toStringAsFixed(2)}', PdfColors.black),
            pw.SizedBox(height: 8),
            _buildStatBox('NET COLLECTION', 'Rs. ${(analytics.totalSales - analytics.totalDiscount).toStringAsFixed(2)}', PdfColors.black, isPrimary: true),
            pw.SizedBox(height: 40),

            // Payment Distribution
            pw.Text('PAYMENT BREAKDOWN',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell('Mode', isHeader: true, large: true),
                    _buildTableCell('Amount', isHeader: true, alignRight: true, large: true),
                    _buildTableCell('%', isHeader: true, alignRight: true, large: true),
                  ],
                ),
                ...analytics.paymentStats.entries.where((e) => e.value > 0).map((entry) {
                  final totalPayment = analytics.paymentStats.values.fold(0.0, (p, c) => p + c);
                  final percent = totalPayment > 0 ? (entry.value / totalPayment) * 100 : 0.0;
                  return pw.TableRow(
                    children: [
                      _buildTableCell(entry.key.toUpperCase(), large: false),
                      _buildTableCell(entry.value.toStringAsFixed(0), alignRight: true, large: true),
                      _buildTableCell('${percent.toStringAsFixed(0)}%', alignRight: true, large: false),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 40),

            // Top Products
            pw.Text('TOP PERFORMING PRODUCTS',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell('#', isHeader: true, large: true),
                    _buildTableCell('Product Name', isHeader: true, large: true),
                    _buildTableCell('Qty', isHeader: true, alignRight: true, large: true),
                    _buildTableCell('Revenue', isHeader: true, alignRight: true, large: true),
                  ],
                ),
                ... (analytics.itemStats.entries.toList()
                  ..sort((a, b) => b.value.revenue.compareTo(a.value.revenue)))
                  .take(20)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key + 1;
                    final item = entry.value.value;
                    return pw.TableRow(
                      children: [
                        _buildTableCell(index.toString(), large: true),
                        _buildTableCell(item.name.toUpperCase(), large: true),
                        _buildTableCell(item.qty.toString(), alignRight: true, large: true),
                        _buildTableCell('Rs. ${item.revenue.toStringAsFixed(2)}', alignRight: true, large: true),
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

  static Future<File> savePdfToFile(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}

