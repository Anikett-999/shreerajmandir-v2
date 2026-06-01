
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final firestore = FirebaseFirestore.instance;
  // Use a known branch ID or try to find one
  final branches = await firestore.collection('branches').get();
  for (var branch in branches.docs) {
    print('Checking Branch: ${branch.id}');
    final bills = await branch.reference.collection('bills').get();
    print('Total Bills: ${bills.docs.length}');
    
    int countWithTotal = 0;
    int countWithZeroTotal = 0;
    int countWithItems = 0;
    
    for (var doc in bills.docs) {
      final data = doc.data();
      final total = data['total'] ?? 0;
      final items = data['items'] as List? ?? [];
      
      if (total > 0) countWithTotal++;
      else countWithZeroTotal++;
      
      if (items.isNotEmpty) countWithItems++;
      
      if (total == 0 && items.isNotEmpty) {
        print('Bill ${doc.id} has total 0 but ${items.length} items');
      }
    }
    
    print('Bills with total > 0: $countWithTotal');
    print('Bills with total = 0: $countWithZeroTotal');
    print('Bills with items: $countWithItems');
  }
}
