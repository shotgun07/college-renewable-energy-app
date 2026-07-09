import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb, PlatformDispatcher;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'models/app_user.dart';
import 'constants/app_enums.dart'; 
import 'ui/auth/admin_login_screen.dart';
import 'ui/screens/main_screen.dart';
import 'ui/widgets/connectivity_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Configure Firestore persistence (for cloud_firestore v5+ compatibility)
  // Web defaults to memory cache, keeping multi-tab environments safe.
  // Native defaults to persistent storage.
  FirebaseFirestore.instance.settings = const Settings();

  runApp(
    const riverpod.ProviderScope(
      child: AdminDashboardApp(),
    ),
  );
}

final themeProvider = riverpod.NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());

class AdminDashboardApp extends riverpod.ConsumerWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة إدارة الكلية',
      theme: ThemeNotifier.lightTheme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(ThemeNotifier.lightTheme.textTheme),
      ),
      darkTheme: ThemeNotifier.darkTheme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(ThemeNotifier.darkTheme.textTheme),
      ),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      locale: const Locale('ar', 'AE'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ConnectivityWrapper(child: child ?? const SizedBox.shrink()),
        );
      },
      home: const AdminAuthGate(),
    );
  }
}

class AdminAuthGate extends StatelessWidget {
  const AdminAuthGate({super.key});

  Future<AppUser?> _fetchUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, doc.data());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<auth.User?>(
      stream: auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final user = authSnap.data;
        if (user == null) {
          return const AdminLoginScreen();
        }

        return FutureBuilder(
          future: user.reload(),
          builder: (context, _) {
            final refreshed = auth.FirebaseAuth.instance.currentUser;
            if (refreshed == null) return const AdminLoginScreen();

            return FutureBuilder<AppUser?>(
              future: _fetchUser(refreshed.uid),
              builder: (context, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return const _LoadingScreen();
                }

                final appUser = userSnap.data;
                if (appUser == null) {
                  return _MissingProfileScreen(
                    uid: refreshed.uid,
                    email: refreshed.email,
                  );
                }

                // Only allow admin and supervisor roles
                if (appUser.role != UserRole.admin &&
                    appUser.role != UserRole.supervisor) {
                  return const _UnauthorizedScreen();
                }

                return MainScreen(user: appUser);
              },
            );
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF64B5F6))),
    );
  }
}

class _MissingProfileScreen extends StatelessWidget {
  final String uid;
  final String? email;

  const _MissingProfileScreen({required this.uid, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('بيانات المستخدم غير مكتملة'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم تسجيل الدخول، لكن لا توجد وثيقة مستخدم في Firestore.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text('UID: $uid', style: const TextStyle(color: Colors.white70)),
            if (email != null)
              Text(
                'Email: $email',
                style: const TextStyle(color: Colors.white70),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => auth.FirebaseAuth.instance.signOut(),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnauthorizedScreen extends StatelessWidget {
  const _UnauthorizedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.redAccent),
              const SizedBox(height: 24),
              const Text(
                'غير مصرح لك بالدخول',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'هذه اللوحة مخصصة للإداريين والمشرفين فقط',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => auth.FirebaseAuth.instance.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
