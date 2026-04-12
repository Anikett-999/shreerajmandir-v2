import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/table_model.dart';
import '../domain/models/dashboard_stats.dart';
import '../domain/models/product_insights.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _businessId = 'rajmandir_main';

  DocumentReference _getBranchRef(String branchId) {
    return _firestore
        .collection('businesses')
        .doc(_businessId)
        .collection('branches')
        .doc(branchId);
  }

  // --- Safe Parsing Helpers ---

  BillModel? _safeParseBill(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      // Inject IDs and provide structural fallbacks
      data['billId'] = data['billId'] ?? doc.id;
      data['orderId'] = data['orderId'] ?? 'N/A';
      data['tableId'] = data['tableId'] ?? 'N/A';
      data['tableName'] = data['tableName'] ?? 'N/A';
      data['userName'] = data['userName'] ?? 'N/A';
      data['createdBy'] = data['createdBy'] ?? 'N/A';
      data['items'] = data['items'] ?? [];
      data['payments'] = data['payments'] ?? [];
      
      // Ensure numeric fields are non-null and doubles
      data['subtotal'] = (data['subtotal'] ?? 0.0).toDouble();
      data['total'] = (data['total'] ?? 0.0).toDouble();
      data['discountPercent'] = (data['discountPercent'] ?? 0.0).toDouble();
      data['discountAmount'] = (data['discountAmount'] ?? 0.0).toDouble();
      data['extraCharges'] = (data['extraCharges'] ?? 0.0).toDouble();

      // Ensure createdAt exists
      if (data['createdAt'] == null) return null;

      return BillModel.fromJson(data);
    } catch (e) {
      debugPrint('Error parsing Bill ${doc.id}: $e');
      return null;
    }
  }

  TableModel? _safeParseTable(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      data['tableId'] = data['tableId'] ?? doc.id;
      
      // Handle timestamp to string conversion for UI stability
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }
      
      return TableModel.fromJson(data);
    } catch (e) {
      print('Error parsing Table ${doc.id}: $e');
      return null;
    }
  }

  KOTModel? _safeParseKOT(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      data['kotId'] = data['kotId'] ?? doc.id;
      data['orderId'] = data['orderId'] ?? 'N/A';
      
      return KOTModel.fromJson(data);
    } catch (e) {
      print('Error parsing KOT ${doc.id}: $e');
      return null;
    }
  }

  // --- Analytics Streams ---

  Stream<DashboardStats> watchDashboardStats(String branchId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final branchRef = _getBranchRef(branchId);

    // Fetch snapshots without strict timestamp filter to allow for the legacy String format transition.
    return branchRef.collection('bills').snapshots().map((billsSnap) {
      final bills = billsSnap.docs
          .map((doc) => _safeParseBill(doc))
          .whereType<BillModel>()
          .where((b) => b.createdAt.isAfter(startOfDay.subtract(const Duration(seconds: 1))))
          .toList();

      final tablesStream = branchRef.collection('tables').get();
      final kotsStream = branchRef.collection('kots').get();

      // For simplicity in this stream-based architecture, we'll keep the combine3 approach 
      // but the key fix is the bill filtering above.
      // Re-implementing correctly with combine for the dashboard
      return bills;
    }).switchMap((bills) {
      // Re-using the logic from the previous turn but correctly integrated
      return CombineLatestStream.combine2(
        branchRef.collection('tables').snapshots(),
        branchRef.collection('kots').snapshots(),
        (tablesSnap, kotsSnap) {
          final tables = tablesSnap.docs.map((doc) => _safeParseTable(doc)).whereType<TableModel>().toList();
          final kots = kotsSnap.docs
              .map((doc) => _safeParseKOT(doc))
              .whereType<KOTModel>()
              .where((k) => k.createdAt.isAfter(startOfDay))
              .toList();

          double totalRevenue = 0;
          double grossSales = 0;
          double totalDiscounts = 0;
          Map<String, double> payments = {'cash': 0.0, 'upi': 0.0, 'card': 0.0};
          Map<int, double> hourlyRevenue = {};
          Map<String, TopProduct> productMap = {};

          for (final bill in bills) {
            totalRevenue += bill.total;
            grossSales += bill.subtotal + bill.extraCharges;
            totalDiscounts += bill.discountAmount;
            
            for (final p in bill.payments) {
              final mode = p.mode.toLowerCase();
              payments[mode] = (payments[mode] ?? 0.0) + p.amount;
            }

            final hour = bill.createdAt.hour;
            hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0.0) + bill.total;

            for (final item in bill.items) {
              final existing = productMap[item.name];
              if (existing != null) {
                productMap[item.name] = existing.copyWith(
                  quantity: existing.quantity + item.qty,
                  revenue: existing.revenue + (item.qty * item.price),
                );
              } else {
                productMap[item.name] = TopProduct(
                  name: item.name,
                  quantity: item.qty,
                  revenue: item.qty * item.price,
                );
              }
            }
          }

          final activeTables = tables.where((t) => t.status != 'available').length;
          final pendingKots = kots.where((k) => !k.isPrinted).length;

          final suspicious = bills
              .where((b) => b.isSuspicious || b.printCount > 1)
              .map((b) => SuspiciousBill(
                    billId: b.billId,
                    printCount: b.printCount,
                    tableId: b.tableName,
                    total: b.total,
                    createdAt: b.createdAt,
                  ))
              .toList();

          final List<HourlySales> salesTrend = List.generate(24, (dayHour) {
            return HourlySales(hour: dayHour, revenue: hourlyRevenue[dayHour] ?? 0.0);
          });

          final topProducts = productMap.values.toList()
            ..sort((a, b) => b.revenue.compareTo(a.revenue));

          return DashboardStats(
            totalRevenue: totalRevenue,
            grossSales: grossSales,
            totalDiscounts: totalDiscounts,
            totalOrders: bills.length,
            avgOrderValue: bills.isEmpty ? 0 : totalRevenue / bills.length,
            revenueTrend: 0.0,
            ordersTrend: 0.0,
            hourlySales: salesTrend,
            paymentSplit: payments,
            activeTables: activeTables,
            pendingKots: pendingKots,
            topProducts: topProducts.take(10).toList(),
            suspiciousBills: suspicious,
          );
        },
      );
    });
  }

  Stream<ProductInsights> watchProductInsights(String branchId) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final branchRef = _getBranchRef(branchId);

    return branchRef.collection('bills').snapshots().map((billsSnap) {
      final bills = billsSnap.docs
          .map((doc) => _safeParseBill(doc))
          .whereType<BillModel>()
          .where((b) => b.createdAt.isAfter(thirtyDaysAgo.subtract(const Duration(seconds: 1))))
          .toList();

      Map<String, TopProduct> itemMap = {};
      Map<String, TopCategory> categoryMap = {};
      int totalQty = 0;
      double totalRev = 0;

      for (final bill in bills) {
        for (final item in bill.items) {
          totalQty += item.qty;
          totalRev += (item.qty * item.price);

          final existingItem = itemMap[item.name];
          if (existingItem != null) {
            itemMap[item.name] = existingItem.copyWith(
              quantity: existingItem.quantity + item.qty,
              revenue: existingItem.revenue + (item.qty * item.price),
            );
          } else {
            itemMap[item.name] = TopProduct(
              name: item.name,
              quantity: item.qty,
              revenue: item.qty * item.price,
            );
          }

          final catName = item.category.isEmpty ? 'Uncategorized' : item.category;
          final existingCat = categoryMap[catName];
          if (existingCat != null) {
            categoryMap[catName] = existingCat.copyWith(
              quantity: existingCat.quantity + item.qty,
              revenue: existingCat.revenue + (item.qty * item.price),
            );
          } else {
            categoryMap[catName] = TopCategory(
              name: catName,
              quantity: item.qty,
              revenue: item.qty * item.price,
            );
          }
        }
      }

      final sortedItems = itemMap.values.toList()..sort((a, b) => b.quantity.compareTo(a.quantity));
      final sortedCats = categoryMap.values.toList()..sort((a, b) => b.quantity.compareTo(a.quantity));

      return ProductInsights(
        topItems: sortedItems,
        topCategories: sortedCats,
        totalQuantity: totalQty,
        totalRevenue: totalRev,
      );
    });
  }

  Stream<DashboardStats> watchReportForRange(String branchId, DateTime start, DateTime end) {
    final rangeStart = DateTime(start.year, start.month, start.day);
    final rangeEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    final branchRef = _getBranchRef(branchId);

    return branchRef.collection('bills').snapshots().map((billsSnap) {
      final bills = billsSnap.docs
          .map((doc) => _safeParseBill(doc))
          .whereType<BillModel>()
          .where((b) {
            return b.createdAt.isAfter(rangeStart.subtract(const Duration(seconds: 1))) && 
                   b.createdAt.isBefore(rangeEnd.add(const Duration(seconds: 1)));
          })
          .toList();

      double totalRevenue = 0;
      double grossSales = 0;
      double totalDiscounts = 0;
      Map<String, double> payments = {'cash': 0.0, 'upi': 0.0, 'card': 0.0};
      Map<int, double> hourlyRevenue = {};
      Map<String, TopProduct> productMap = {};

      for (final bill in bills) {
        totalRevenue += bill.total;
        grossSales += bill.subtotal + bill.extraCharges;
        totalDiscounts += bill.discountAmount;
        
        for (final p in bill.payments) {
          final mode = p.mode.toLowerCase();
          payments[mode] = (payments[mode] ?? 0.0) + p.amount;
        }

        final hour = bill.createdAt.hour;
        hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0.0) + bill.total;

        for (final item in bill.items) {
          final existing = productMap[item.name];
          if (existing != null) {
            productMap[item.name] = existing.copyWith(
              quantity: existing.quantity + item.qty,
              revenue: existing.revenue + (item.qty * item.price),
            );
          } else {
            productMap[item.name] = TopProduct(
              name: item.name,
              quantity: item.qty,
              revenue: item.qty * item.price,
            );
          }
        }
      }

      final List<HourlySales> salesTrend = List.generate(24, (dayHour) {
        return HourlySales(hour: dayHour, revenue: hourlyRevenue[dayHour] ?? 0.0);
      });

      final topProducts = productMap.values.toList()
        ..sort((a, b) => b.revenue.compareTo(a.revenue));

      return DashboardStats(
        totalRevenue: totalRevenue,
        grossSales: grossSales,
        totalDiscounts: totalDiscounts,
        totalOrders: bills.length,
        avgOrderValue: bills.isEmpty ? 0 : totalRevenue / bills.length,
        revenueTrend: 0.0,
        ordersTrend: 0.0,
        hourlySales: salesTrend,
        paymentSplit: payments,
        activeTables: 0,
        pendingKots: 0,
        topProducts: topProducts.take(15).toList(),
        suspiciousBills: [],
      );
    });
  }


}

