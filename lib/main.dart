import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';
// import 'services/verification_reminder_service.dart'; // Removed as unused
// import 'models/app_user.dart'; // Removed legacy model to avoid conflict

import 'domain/entities/user.dart'; // Domain Entity
import 'presentation/providers/auth_provider.dart'; // Riverpod Provider
import 'presentation/providers/notification_topics_provider.dart'; // FCM Topics

import 'providers/theme_provider.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/widgets/offline_banner.dart';

import 'presentation/pages/auth/login_page.dart';

import 'ui/screens/home/student_home.dart';
import 'ui/screens/home/teacher_home.dart';
import 'ui/screens/home/admin_home.dart';
import 'ui/screens/home/supervisor_home.dart';
import 'core/widgets/custom_error_widget.dart';
import 'core/security/http_overrides.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = AppHttpOverrides();

  // Initialize Local Key-Value Database
  await Hive.initFlutter();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await NotificationService().initialize();
  // Initialize other services
  // VerificationReminderService does not need explicit initialization

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Renamed from CollegeApp
  const MyApp({super.key}); // Renamed from CollegeApp

  @override
  Widget build(BuildContext context) {
    // The ThemeProvider should now be managed by Riverpod's ProviderScope
    // and accessed via ref.watch or similar.
    // Assuming themeProvider is now a Riverpod provider.
    // This part of the code needs to be adapted to Riverpod's way of consuming providers.
    // For now, I'll keep the ChangeNotifierProvider structure as it was in the original,
    // but this would typically be removed when moving to Riverpod fully.
    return legacy_provider.ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: legacy_provider.Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'كلية الطاقة المتجددة',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: OfflineBanner(child: child ?? const SizedBox.shrink()),
              );
            },
            home: const SplashScreen(next: AuthGate()),
          );
        },
      ),
    );
  }
}

// ... (imports will be updated at the top of file separately if needed, but I'll try to do it all if possible or assume imports exist)

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Triggers auto-subscription to Push Notifications based on user profile
    ref.watch(notificationTopicsProvider);
    
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginPage();
        }

        switch (user.role) {
          case UserRole.admin:
            return const AdminHome();
          case UserRole.supervisor:
            return const SupervisorHome();
          case UserRole.teacher:
            return const TeacherHome();
          case UserRole.student:
            return const StudentHome();
        }
      },
      loading: () => const _LoadingScreen(),
      error: (e, st) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: CustomErrorWidget(
          message: 'حدث خطأ أثناء تحميل البيانات: $e',
          onRetry: () => ref.refresh(authProvider),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
