import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/table_model.dart';
import '../domain/models/dashboard_stats.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DashboardStats> watchDashboardStats(String branchId) {
    // Start of current day
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final billsStream = _firestore
        .collection('bills')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .snapshots();

    final tablesStream = _firestore
        .collection('tables')
        .where('branchId', isEqualTo: branchId)
        .snapshots();
    
    final kotsStream = _firestore
        .collection('kots')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .snapshots();

    return CombineLatestStream.combine3(
      billsStream,
      tablesStream,
      kotsStream,
      (billsSnap, tablesSnap, kotsSnap) {
        final bills = billsSnap.docs.map((doc) => BillModel.fromJson(doc.data())).toList();
        final tables = tablesSnap.docs.map((doc) => TableModel.fromJson(doc.data())).toList();
        final kots = kotsSnap.docs.map((doc) => KOTModel.fromJson(doc.data())).toList();

        // 1. Revenue Calculations
        double totalRevenue = 0;
        Map<String, double> payments = {'cash': 0.0, 'upi': 0.0, 'card': 0.0};
        Map<int, double> hourlyRevenue = {};
        Map<String, TopProduct> productMap = {};

        for (final bill in bills) {
          totalRevenue += bill.total;
          
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
          totalOrders: bills.length,
          avgOrderValue: bills.isEmpty ? 0 : totalRevenue / bills.length,
          growthRate: 15.2, // Placeholder for trend calculation
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
}
