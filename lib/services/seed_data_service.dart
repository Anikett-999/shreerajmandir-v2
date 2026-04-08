import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../domain/models/category.dart';
import '../domain/models/item.dart';
import 'package:uuid/uuid.dart';

class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId = 'rajmandir_main';
  final String branchId = 'branch_001';

  Future<void> seedMenuData() async {
    try {
      // 1. Read JSON file
      final String jsonString = await rootBundle.loadString('assets/data/menu_items.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // 2. Identify unique categories
      final Set<String> categoryNames = jsonData.map((item) => item['category'] as String).toSet();
      
      final Map<String, String> categoryNameToId = {};

      // 3. Create categories in Firestore
      int catOrder = 1;
      for (final catName in categoryNames) {
        final categoryId = const Uuid().v4();
        categoryNameToId[catName] = categoryId;

        final category = Category(
          categoryId: categoryId,
          name: catName,
          order: catOrder++,
        );

        await _firestore
            .collection('businesses')
            .doc(businessId)
            .collection('branches')
            .doc(branchId)
            .collection('menu_categories')
            .doc(categoryId)
            .set(category.toJson());
      }

      // 4. Create items in Firestore
      for (final itemData in jsonData) {
        final itemId = const Uuid().v4();
        final catName = itemData['category'] as String;
        final catId = categoryNameToId[catName]!;

        final item = Item(
          itemId: itemId,
          name: itemData['name'],
          categoryId: catId,
          price: (itemData['price'] as num).toDouble(),
          isAvailable: true,
        );

        await _firestore
            .collection('businesses')
            .doc(businessId)
            .collection('branches')
            .doc(branchId)
            .collection('menu_items')
            .doc(itemId)
            .set(item.toJson());
      }

      print('✅ Database seeded successfully!');
    } catch (e) {
      print('❌ Error seeding database: $e');
      rethrow;
    }
  }

  Future<void> seedInitialTables() async {
    try {
      for (int i = 1; i <= 10; i++) {
        final tableId = 'T$i';
        await _firestore
            .collection('businesses')
            .doc(businessId)
            .collection('branches')
            .doc(branchId)
            .collection('tables')
            .doc(tableId)
            .set({
          'tableId': tableId,
          'name': 'Table $i',
          'capacity': 4,
          'status': 'available',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      print('✅ Tables seeded successfully!');
    } catch (e) {
      print('❌ Error seeding tables: $e');
      rethrow;
    }
  }
}
