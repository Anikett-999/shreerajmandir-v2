import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/shared/home_screen.dart';
import 'presentation/screens/shared/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/printer_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const ShreeRajmandirPOSApp(),
    ),
  );
}

class ShreeRajmandirPOSApp extends ConsumerWidget {
  const ShreeRajmandirPOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Shree Rajmandir POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: authState.when(
        data: (user) => user == null ? const LoginScreen() : const HomeScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) => Scaffold(body: Center(child: Text('❌ Auth Error: $e'))),
      ),
    );
  }
}
