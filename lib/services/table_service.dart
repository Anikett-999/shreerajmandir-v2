import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/table_model.dart';

class TableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId = 'rajmandir_main';
  final String branchId;

  TableService({required this.branchId});

  CollectionReference get _tableCollection => _firestore
      .collection('businesses')
      .doc(businessId)
      .collection('branches')
      .doc(branchId)
      .collection('tables');

  // Stream of all tables for the current branch
  Stream<List<TableModel>> watchTables() {
    return _tableCollection.snapshots().map((snapshot) {
      final tables = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Fix: Convert Firestore Timestamp to ISO string for Freezed DateTime parsing
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
        }
        return TableModel.fromJson(data);
      }).toList();

      // Implement natural sorting (1, 2, 3... instead of 1, 10, 2)
      tables.sort((a, b) {
        final aNum = int.tryParse(RegExp(r'\d+').stringMatch(a.name) ?? '');
        final bNum = int.tryParse(RegExp(r'\d+').stringMatch(b.name) ?? '');
        
        if (aNum != null && bNum != null) {
          if (aNum != bNum) return aNum.compareTo(bNum);
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return tables;
    });
  }

  // Create a new table (Admin only)
  Future<void> createTable(String name, int capacity) async {
    final docRef = _tableCollection.doc();
    final table = TableModel(
      tableId: docRef.id,
      name: name,
      capacity: capacity,
      updatedAt: DateTime.now(),
    );
    await docRef.set(table.toJson());
  }

  // Lock table for billing
  Future<void> lockForBilling(String tableId) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _tableCollection.doc(tableId);
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) throw Exception('Table not found');
      
      final data = snapshot.data() as Map<String, dynamic>;
      if (data['status'] != 'occupied') {
        throw Exception('Table must be occupied to start billing');
      }

      transaction.update(docRef, {
        'status': 'billing',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Clear table after successful billing
  Future<void> clearTable(String tableId) async {
    await _tableCollection.doc(tableId).update({
      'status': 'available',
      'activeOrderId': null,
      'totalAmount': 0.0,
      'itemCount': 0,
      'kotCount': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
