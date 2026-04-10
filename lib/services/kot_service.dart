import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/kot_model.dart';
import '../domain/models/order_model.dart';
import 'package:uuid/uuid.dart';

class KOTService {
  final FirebaseFirestore _firestore;
  final String businessId = 'rajmandir_main';
  final String branchId = 'branch_001';

  KOTService({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

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
    required String tableName,
    required List<KOTItem> items,
    required String userId,
    required String userName,
  }) async {
    return await _firestore.runTransaction((transaction) async {
      // --- READS (All reads MUST happen before any writes) ---
      // 1. Get active order for table
      final tableSnapshot = await transaction.get(_tableCollection.doc(tableId));
      if (!tableSnapshot.exists) throw Exception('Table not found');

      // 2. Get global KOT counter
      final counterSnapshot = await transaction.get(_counterDoc);
      
      // --- WRITES ---
      final tableData = tableSnapshot.data() as Map<String, dynamic>;
      String? orderId = tableData['activeOrderId'];

      final Map<String, dynamic> tableUpdates = {};

      final kotId = const Uuid().v4();
      final double kotTotal = items.fold(0.0, (total, i) => total + (i.price * i.qty));

      if (orderId == null) {
        final newOrderRef = _orderCollection.doc();
        orderId = newOrderRef.id;

        final newOrder = OrderModel(
          orderId: orderId,
          tableId: tableId,
          kotIds: [kotId],
          createdAt: DateTime.now(),
        );

        transaction.set(newOrderRef, newOrder.toJson());
        
        tableUpdates['activeOrderId'] = orderId;
        tableUpdates['status'] = 'occupied';
      } else {
        transaction.update(_orderCollection.doc(orderId), {
          'kotIds': FieldValue.arrayUnion([kotId]),
        });
      }

      // 2. Fetch/Calculate KOT number with Daily Reset (Start from 1001)
      final now = DateTime.now();
      final String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      
      int kotNumber = 1001;
      if (counterSnapshot.exists) {
        final counterData = counterSnapshot.data() as Map<String, dynamic>;
        final String lastReset = counterData['lastResetDate'] ?? '';
        
        if (lastReset == todayStr) {
          kotNumber = (counterData['kotCounter'] ?? 1000) + 1;
        } else {
          // New day reset
          kotNumber = 1001;
        }
      }

      // Update counters (Global)
      transaction.set(_counterDoc, {
        'kotCounter': kotNumber,
        'lastResetDate': todayStr,
      });

      // Update Daily Stats summary
      final dailyStatRef = _branchRef.collection('daily_stats').doc(todayStr);
      transaction.set(dailyStatRef, {
        'totalKots': kotNumber - 1000, // actual count of the day
        'lastKotNumber': kotNumber,
        'date': todayStr,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 3. Create KOT document
      final kot = KOTModel(
        kotId: kotId,
        kotNumber: kotNumber,
        orderId: orderId,
        tableId: tableId,
        tableName: tableName,
        items: items,
        totalAmount: kotTotal,
        createdBy: userId,
        userName: userName,
        createdAt: now,
      );

      transaction.set(_kotCollection.doc(kotId), kot.toJson());

      // 4. Update Table denormalized counts/totals
      final double currentTotal = (tableData['totalAmount'] ?? 0.0) + kotTotal;
      final int currentItemCount = (tableData['itemCount'] ?? 0) + items.length;
      final int currentKotCount = (tableData['kotCount'] ?? 0) + 1;

      tableUpdates['totalAmount'] = currentTotal;
      tableUpdates['itemCount'] = currentItemCount;
      tableUpdates['kotCount'] = currentKotCount;
      tableUpdates['updatedAt'] = FieldValue.serverTimestamp();

      transaction.update(_tableCollection.doc(tableId), tableUpdates);

      return kot;
    });
  }

  // Watch KOTs for a specific order
  Stream<List<KOTModel>> watchKOTsByOrder(String orderId) {
    return _kotCollection
        .where('orderId', isEqualTo: orderId)
        // .orderBy('createdAt', descending: true) // Using client-side sort as failsafe
        .snapshots()
        .map((snapshot) {
      final List<KOTModel> kots = [];
      for (var doc in snapshot.docs) {
        try {
          kots.add(KOTModel.fromJson(doc.data() as Map<String, dynamic>));
        } catch (e) {
          print('❌ Skipping corrupted KOT ${doc.id}: $e');
        }
      }
      // Client-side sort by createdAt descending
      kots.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return kots;
    });
  }

  // Watch all active KOTs for a branch (live KOT screen)
  Stream<List<KOTModel>> watchLiveKOTs() {
    return _kotCollection
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final List<KOTModel> kots = [];
      for (var doc in snapshot.docs) {
        try {
          kots.add(KOTModel.fromJson(doc.data() as Map<String, dynamic>));
        } catch (e) {
          print('❌ Skipping corrupted KOT ${doc.id}: $e');
        }
      }
      return kots;
    });
  }

  // Update status of a specific item in a KOT
  Future<void> updateItemStatus({
    required String kotId,
    required String itemUniqueId,
    required String status,
  }) async {
    final kotRef = _kotCollection.doc(kotId);
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(kotRef);
      if (!snapshot.exists) throw Exception('KOT not found');
      
      final kotData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> items = List.from(kotData['items']);
      
      final itemIndex = items.indexWhere((i) => i['uniqueId'] == itemUniqueId);
      if (itemIndex != -1) {
        items[itemIndex]['status'] = status;
        transaction.update(kotRef, {'items': items});
      }
    });
  }
}
