import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/branch_model.dart';

final branchProvider = StreamProvider<BranchModel>((ref) {
  // Hardcoded for now but in a real app this might come from auth/user profiles
  const branchPath = 'businesses/rajmandir_main/branches/branch_001';
  
  return FirebaseFirestore.instance
      .doc(branchPath)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      // Return a default if not found (for safety)
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
