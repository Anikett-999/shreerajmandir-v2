import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/bill_model.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/table_model.dart';
import 'package:uuid/uuid.dart';

class BillingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId = 'rajmandir_main';
  final String branchId;

  BillingService({required this.branchId});

  DocumentReference get _branchRef => _firestore
      .collection('businesses')
      .doc(businessId)
      .collection('branches')
      .doc(branchId);

  CollectionReference get _billCollection => _branchRef.collection('bills');
  CollectionReference get _kotCollection => _branchRef.collection('kots');
  CollectionReference get _orderCollection => _branchRef.collection('orders');
  CollectionReference get _tableCollection => _branchRef.collection('tables');

  // Preview Bill (Aggregates all KOTs for an order)
  Future<Map<String, dynamic>> previewBill(String orderId) async {
    final kotSnapshots = await _kotCollection.where('orderId', isEqualTo: orderId).get();
    final kots = kotSnapshots.docs.map((doc) => KOTModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

    List<BillItem> billItems = [];
    double subtotal = 0.0;

    for (var kot in kots) {
      for (var item in kot.items) {
        if (item.status != 'rejected') {
          billItems.add(BillItem(
            name: item.name,
            qty: item.qty,
            price: item.price,
            note: item.note,
          ));
          subtotal += (item.price * item.qty);
        }
      }
    }

    return {
      'items': billItems,
      'subtotal': subtotal,
    };
  }

  // Generate Final Bill
  Future<BillModel> generateBill({
    required String orderId,
    required String tableId,
    required String tableName,
    required String userName,
    required double discountPercent,
    required double extraCharges,
    required List<Payment> payments,
    required String userId,
  }) async {
    return await _firestore.runTransaction((transaction) async {
      // 1. Lock table for billing
      final tableRef = _tableCollection.doc(tableId);
      final tableSnap = await transaction.get(tableRef);
      if (!tableSnap.exists) throw Exception('Table not found');
      
      final tableData = TableModel.fromJson(tableSnap.data() as Map<String, dynamic>);
      if (tableData.status != 'occupied' && tableData.status != 'billing') {
        throw Exception('Invalid table status for billing');
      }

      // 2. Aggregate items
      final kotSnapshots = await _kotCollection.where('orderId', isEqualTo: orderId).get();
      final kots = kotSnapshots.docs.map((doc) => KOTModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      List<BillItem> billItems = [];
      double subtotal = 0.0;

      for (var kot in kots) {
        for (var item in kot.items) {
          if (item.status != 'rejected') {
            billItems.add(BillItem(
              name: item.name,
              qty: item.qty,
              price: item.price,
              note: item.note,
            ));
            subtotal += (item.price * item.qty);
          }
        }
      }

      // 3. Apply calculations
      double discountAmount = (subtotal * discountPercent) / 100;
      double total = (subtotal - discountAmount) + extraCharges;

      // 4. Create Bill Document
      final billId = const Uuid().v4();
      final bill = BillModel(
        billId: billId,
        orderId: orderId,
        tableId: tableId,
        tableName: tableName,
        userName: userName,
        items: billItems,
        subtotal: subtotal,
        discountPercent: discountPercent,
        discountAmount: discountAmount,
        extraCharges: extraCharges,
        total: total,
        payments: payments,
        createdAt: DateTime.now(),
        createdBy: userId,
      );

      transaction.set(_billCollection.doc(billId), bill.toJson());

      // 5. Update Table Status
      transaction.update(tableRef, {
        'status': 'billing',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return bill;
    });
  }

  // Finalize and Clear Table
  Future<void> finalizeAndClearTable(String tableId, String orderId) async {
    await _firestore.runTransaction((transaction) async {
      // 1. Close Order
      transaction.update(_orderCollection.doc(orderId), {
        'status': 'closed',
        'closedAt': FieldValue.serverTimestamp(),
      });

      // 2. Clear Table
      transaction.update(_tableCollection.doc(tableId), {
        'status': 'available',
        'activeOrderId': null,
        'totalAmount': 0.0,
        'itemCount': 0,
        'kotCount': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
