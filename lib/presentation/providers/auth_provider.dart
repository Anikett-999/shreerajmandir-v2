import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../domain/models/user_model.dart';

final authChangeNotifierProvider = ChangeNotifierProvider<AuthService>((ref) => AuthService());

// We keep authServiceProvider for legacy compat within the rest of the app
final authServiceProvider = Provider<AuthService>((ref) => ref.watch(authChangeNotifierProvider));

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userModelProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(authState.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return null;
        return UserModel.fromJson(snapshot.data()!);
      });
});

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList());
});
