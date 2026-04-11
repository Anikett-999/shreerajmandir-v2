import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/branch_model.dart';

import './active_branch_provider.dart';

final branchProvider = StreamProvider<BranchModel>((ref) {
  final activeBranchId = ref.watch(activeBranchIdProvider);
  
  // Default to Main if nothing selected (should mostly be handled by UI/Gate)
  final branchId = activeBranchId ?? 'branch_001';
  final branchPath = 'businesses/rajmandir_main/branches/$branchId';
  
  return FirebaseFirestore.instance
      .doc(branchPath)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      return const BranchModel(
        branchId: 'branch_001',
        branchName: 'Rajmandir - Main Branch',
        location: 'Pune',
        address: 'Pune, Maharashtra',
        phone: '9999999999',
      );
    }
    return BranchModel.fromJson(snapshot.data()!);
  });
});

final allBranchesProvider = StreamProvider<List<BranchModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('businesses/rajmandir_main/branches')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data['branchId'] == null || data['branchId'].toString().isEmpty) {
              data['branchId'] = doc.id;
            }
            if (data['branchName'] == null || data['branchName'].toString().isEmpty) {
              data['branchName'] = doc.id.toUpperCase();
            }
            return BranchModel.fromJson(data);
          })
          .toList());
});
