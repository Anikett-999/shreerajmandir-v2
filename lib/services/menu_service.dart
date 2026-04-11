import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/category.dart';
import '../domain/models/item.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId = 'rajmandir_main';
  final String branchId;

  MenuService({required this.branchId});

  CollectionReference get _branchDoc => _firestore
      .collection('businesses')
      .doc(businessId)
      .collection('branches')
      .doc(branchId)
      .collection('menu_categories');

  CollectionReference get _itemsCollection => _firestore
      .collection('businesses')
      .doc(businessId)
      .collection('branches')
      .doc(branchId)
      .collection('menu_items');

  // Watch categories
  Stream<List<Category>> watchCategories() {
    return _branchDoc.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Category.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Watch items by category
  Stream<List<Item>> watchItemsByCategory(String categoryId) {
    return _itemsCollection
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Watch all available items
  Stream<List<Item>> watchAvailableItems() {
    return _itemsCollection
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
