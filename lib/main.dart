import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/admin/presentation/admin_access_gate_screen.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'models/app_user.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZodionaApp());
}

const FirebaseOptions _webFirebaseOptions = FirebaseOptions(
  apiKey: String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyB99kZTlsXFGgkWznaTHnzaQoEYlSXezlY',
  ),
  appId: String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '1:525715666823:web:1b44d64408c8bf56b50522',
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
    const entry = String.fromEnvironment('START_PAGE', defaultValue: 'auto');

    // Web'de hostname'e göre giriş sayfasını belirle
    final String resolvedEntry;
    if (kIsWeb && entry == 'auto') {
      final hostname = Uri.base.host;
      resolvedEntry = hostname.startsWith('admin') ? 'admin' : 'auth';
    } else {
      resolvedEntry = entry;
    }

    return MaterialApp(
      title: 'Zodiona',
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
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
      home: _AppBootstrap(entry: resolvedEntry),
    );
  }
}

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap({required this.entry});

  final String entry;

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _BootstrapResult {
  const _BootstrapResult({this.error, this.autoLoginUser});
  final String? error;
  final AppUser? autoLoginUser;
}

class _AppBootstrapState extends State<_AppBootstrap> {
  static const _minSplashDuration = Duration(seconds: 5);

  late final Future<_BootstrapResult> _bootstrapFuture = _initialize();

  Future<_BootstrapResult> _initialize() async {
    final startedAt = DateTime.now();

    String? error;
    try {
      // Firebase web config artik hardcoded default degerlerle geliyor

      await Firebase.initializeApp(
        options: kIsWeb ? _webFirebaseOptions : null,
      );
    } catch (e) {
      error = e.toString();
    }

    final elapsed = DateTime.now().difference(startedAt);
    final remaining = _minSplashDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (error != null) {
      return _BootstrapResult(error: error);
    }

    // Mevcut Firebase oturumunu kontrol et (uygulama yeniden açılışı)
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        final appUser = await AuthService().currentUser;
        if (appUser != null) {
          return _BootstrapResult(autoLoginUser: appUser);
        }
      }
    } catch (_) {
      // Oturum kontrolü başarısız olursa normal giriş ekranı gösterilsin
    }

    return const _BootstrapResult();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_BootstrapResult>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupSplashScreen();
        }

        final result = snapshot.data;
        if (result?.error != null) {
          return _BootstrapErrorScreen(error: result!.error!);
        }

        // Admin sayfasinda her zaman AdminAccessGateScreen'i goster
        if (widget.entry == 'admin') {
          return const AdminAccessGateScreen();
        }

        if (result?.autoLoginUser != null) {
          final user = result!.autoLoginUser!;
          return user.onboardingCompleted
              ? const HomeScreen()
              : OnboardingScreen(userId: user.uid);
        }

        return const AuthScreen();
      },
    );
  }
}

class _StartupSplashScreen extends StatefulWidget {
  const _StartupSplashScreen();

  @override
  State<_StartupSplashScreen> createState() => _StartupSplashScreenState();
}

class _StartupSplashScreenState extends State<_StartupSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/zodiona_loading.png', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.08)),
          Center(child: _StarOrbitLoader(rotation: _controller)),
        ],
      ),
    );
  }
}

class _StarOrbitLoader extends StatelessWidget {
  const _StarOrbitLoader({required this.rotation});

  final Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: AnimatedBuilder(
        animation: rotation,
        builder: (context, child) {
          final angle = rotation.value * math.pi * 2;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: angle,
                child: _OrbitRing(size: 92, radius: 36, starSize: 10),
              ),
              Transform.rotate(
                angle: -angle * 1.25,
                child: _OrbitRing(size: 66, radius: 24, starSize: 7),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x22F2C98A),
                  border: Border.all(
                    color: const Color(0xFFF2C98A),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 12,
                  color: Color(0xFFF2C98A),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitRing extends StatelessWidget {
  const _OrbitRing({
    required this.size,
    required this.radius,
    required this.starSize,
  });

  final double size;
  final double radius;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < 8; i++)
            Positioned(
              left:
                  size / 2 + radius * math.cos(i * math.pi / 4) - starSize / 2,
              top: size / 2 + radius * math.sin(i * math.pi / 4) - starSize / 2,
              child: Icon(
                Icons.auto_awesome,
                size: starSize,
                color: Color.lerp(
                  const Color(0x55F2C98A),
                  const Color(0xFFF2C98A),
                  i / 7,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(error, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
