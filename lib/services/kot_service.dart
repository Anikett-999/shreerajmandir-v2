import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/order_model.dart';
import 'package:uuid/uuid.dart';

class KOTService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId = 'rajmandir_main';
  final String branchId = 'branch_001';

  DocumentReference get _branchRef => _firestore
      .collection('businesses')
      .doc(businessId)
      .collection('branches')
      .doc(branchId);

  CollectionReference get _kotCollection => _branchRef.collection('kots');
  CollectionReference get _orderCollection => _branchRef.collection('orders');
  CollectionReference get _tableCollection => _branchRef.collection('tables');
  DocumentReference get _counterDoc => _branchRef.collection('counters').doc('global');

  // Create KOT for a table
  Future<KOTModel> createKOT({
    required String tableId,
    required List<KOTItem> items,
    required String userId,
  }) async {
    return await _firestore.runTransaction((transaction) async {
      // 1. Get or Create active order for table
      final tableSnapshot = await transaction.get(_tableCollection.doc(tableId));
      if (!tableSnapshot.exists) throw Exception('Table not found');

      final tableData = tableSnapshot.data() as Map<String, dynamic>;
      String? orderId = tableData['activeOrderId'];

      if (orderId == null) {
        final newOrderRef = _orderCollection.doc();
        orderId = newOrderRef.id;

        final newOrder = OrderModel(
          orderId: orderId,
          tableId: tableId,
          createdAt: DateTime.now(),
        );

        transaction.set(newOrderRef, newOrder.toJson());
        transaction.update(_tableCollection.doc(tableId), {
          'activeOrderId': orderId,
          'status': 'occupied',
        });
      }

      // 2. Increment global KOT counter
      final counterSnapshot = await transaction.get(_counterDoc);
      int kotNumber = 1001;
      if (counterSnapshot.exists) {
        kotNumber = (counterSnapshot.data() as Map<String, dynamic>)['kotCounter'] + 1;
      }
      transaction.set(_counterDoc, {'kotCounter': kotNumber});

      // 3. Create KOT document
      final kotId = const Uuid().v4();
      final double kotTotal = items.fold(0.0, (sum, i) => sum + (i.price * i.qty));

      final kot = KOTModel(
        kotId: kotId,
        kotNumber: kotNumber,
        orderId: orderId,
        tableId: tableId,
        items: items,
        totalAmount: kotTotal,
        createdBy: userId,
        createdAt: DateTime.now(),
      );

      transaction.set(_kotCollection.doc(kotId), kot.toJson());

      // 4. Update order with new KOT ID
      transaction.update(_orderCollection.doc(orderId), {
        'kotIds': FieldValue.arrayUnion([kotId]),
      });

      // 5. Update Table denormalized counts/totals
      final double currentTotal = (tableData['totalAmount'] ?? 0.0) + kotTotal;
      final int currentItemCount = (tableData['itemCount'] ?? 0) + items.length;
      final int currentKotCount = (tableData['kotCount'] ?? 0) + 1;

      transaction.update(_tableCollection.doc(tableId), {
        'totalAmount': currentTotal,
        'itemCount': currentItemCount,
        'kotCount': currentKotCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return kot;
    });
  }

  // Watch KOTs for a specific order
  Stream<List<KOTModel>> watchKOTsByOrder(String orderId) {
    return _kotCollection
        .where('orderId', isEqualTo: orderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return KOTModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
