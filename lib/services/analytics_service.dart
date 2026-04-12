import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<DashboardStats> watchDashboardStats(String branchId) {
    // Start of current day
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final branchRef = _getBranchRef(branchId);

    final billsStream = branchRef
        .collection('bills')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .snapshots();

    final tablesStream = branchRef
        .collection('tables')
        .snapshots();
    
    final kotsStream = branchRef
        .collection('kots')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .snapshots();

    return CombineLatestStream.combine3(
      billsStream,
      tablesStream,
      kotsStream,
      (billsSnap, tablesSnap, kotsSnap) {
        final bills = billsSnap.docs.map((doc) {
          final data = doc.data();
          data['billId'] = data['billId'] ?? doc.id;
          data['orderId'] = data['orderId'] ?? 'N/A';
          // Ensure dates are string for the model's converter if needed, 
          // though TimestampConverter should handle it.
          return BillModel.fromJson(data);
        }).toList();

        final tables = tablesSnap.docs.map((doc) {
          final data = doc.data();
          data['tableId'] = data['tableId'] ?? doc.id;
          // Fix for some firestore versions/environments where native Timestamps crash json_serializable
          if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
          }
          return TableModel.fromJson(data);
        }).toList();

        final kots = kotsSnap.docs.map((doc) {
          final data = doc.data();
          data['kotId'] = data['kotId'] ?? doc.id;
          data['orderId'] = data['orderId'] ?? 'N/A';
          return KOTModel.fromJson(data);
        }).toList();

        // 1. Revenue Calculations
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
          
          // Payment Split
          for (final p in bill.payments) {
            final mode = p.mode.toLowerCase();
            payments[mode] = (payments[mode] ?? 0.0) + p.amount;
          }

          // Hourly Trend
          final hour = bill.createdAt.hour;
          hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0.0) + bill.total;

          // Product Performance
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

        // 2. Operational Stats
        final activeTables = tables.where((t) => t.status != 'available').length;
        final pendingKots = kots.where((k) => !k.isPrinted).length;

        // 3. Suspicious Activities
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

        // Format hourly sales for chart
        final List<HourlySales> salesTrend = List.generate(24, (dayHour) {
          return HourlySales(hour: dayHour, revenue: hourlyRevenue[dayHour] ?? 0.0);
        });

        // Sort Top Products
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
  }

  Stream<ProductInsights> watchProductInsights(String branchId) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final branchRef = _getBranchRef(branchId);

    return branchRef
        .collection('bills')
        .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgo)
        .snapshots()
        .map((billsSnap) {
      final bills = billsSnap.docs.map((doc) {
        final data = doc.data();
        data['billId'] = data['billId'] ?? doc.id;
        data['orderId'] = data['orderId'] ?? 'N/A';
        return BillModel.fromJson(data);
      }).toList();

      Map<String, TopProduct> itemMap = {};
      Map<String, TopCategory> categoryMap = {};
      int totalQty = 0;
      double totalRev = 0;

      for (final bill in bills) {
        for (final item in bill.items) {
          totalQty += item.qty;
          totalRev += (item.qty * item.price);

          // Items
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

          // Categories
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
    // We adjust end to include the entire day
    final rangeEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    final branchRef = _getBranchRef(branchId);

    final billsStream = branchRef
        .collection('bills')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: rangeEnd)
        .snapshots();

    return billsStream.map((billsSnap) {
      final bills = billsSnap.docs.map((doc) {
        final data = doc.data();
        data['billId'] = data['billId'] ?? doc.id;
        data['orderId'] = data['orderId'] ?? 'N/A';
        return BillModel.fromJson(data);
      }).toList();

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
        
        // Payment Split
        for (final p in bill.payments) {
          final mode = p.mode.toLowerCase();
          payments[mode] = (payments[mode] ?? 0.0) + p.amount;
        }

        // Hourly Trend
        final hour = bill.createdAt.hour;
        hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0.0) + bill.total;

        // Product Performance
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

      // Format hourly sales for chart
      final List<HourlySales> salesTrend = List.generate(24, (dayHour) {
        return HourlySales(hour: dayHour, revenue: hourlyRevenue[dayHour] ?? 0.0);
      });

      // Sort Top Products
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

