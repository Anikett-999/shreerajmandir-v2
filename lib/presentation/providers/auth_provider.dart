import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';

final authChangeNotifierProvider = ChangeNotifierProvider<AuthService>((ref) => AuthService());

// We keep authServiceProvider for legacy compat within the rest of the app
final authServiceProvider = Provider<AuthService>((ref) => ref.watch(authChangeNotifierProvider));

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
