import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/admin/presentation/admin_access_gate_screen.dart';
import 'features/auth/presentation/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      final missingFirebaseWebConfig =
          _webFirebaseOptions.apiKey.trim().isEmpty ||
          _webFirebaseOptions.appId.trim().isEmpty;
      if (missingFirebaseWebConfig) {
        throw Exception(
          'Eksik Firebase web ayari. FIREBASE_API_KEY ve FIREBASE_APP_ID dart-define olarak verilmeli.',
        );
      }
    }

    await Firebase.initializeApp(
      options: kIsWeb ? _webFirebaseOptions : null,
    );
  } catch (e) {
    runApp(_BootstrapErrorApp(error: e.toString()));
    return;
  }
  runApp(const ZodionaApp());
}

const FirebaseOptions _webFirebaseOptions = FirebaseOptions(
  apiKey: String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  ),
  appId: String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '',
  ),
  messagingSenderId: String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '525715666823',
  ),
  projectId: String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'zodiona-93e39',
  ),
  storageBucket: String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'zodiona-93e39.firebasestorage.app',
  ),
);

class ZodionaApp extends StatelessWidget {
  const ZodionaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const entry = String.fromEnvironment('START_PAGE', defaultValue: 'auth');

    return MaterialApp(
      title: 'Zodiona',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF2C98A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1026),
        fontFamily: 'Arial',
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFF2C98A)),
        ),
      ),
      home: entry == 'admin'
          ? const AdminAccessGateScreen()
          : const AuthScreen(),
    );
  }
}

class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Uygulama baslatilamadi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
