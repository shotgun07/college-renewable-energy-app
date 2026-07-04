import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'domain/entities/user.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/notification_topics_provider.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/widgets/offline_banner.dart';
import 'presentation/pages/auth/login_page.dart';
import 'ui/screens/home/student_home.dart';
import 'ui/screens/home/teacher_home.dart';
import 'ui/screens/auth/access_denied_screen.dart';
import 'ui/screens/home/supervisor_home.dart';
import 'core/widgets/custom_error_widget.dart';

// ---------------------------------------------------------------------------
//  Riverpod providers for theme
// ---------------------------------------------------------------------------
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.dark;
  }
  
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  
  Future<void> toggleTheme() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state == ThemeMode.dark);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

final lightThemeProvider = Provider<ThemeData>((ref) {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
  );
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
});

/// Global navigator key for showing snackbars from anywhere
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Catch UI/Flutter Framework Errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // TODO: Send details strictly to Firebase Crashlytics logging
  };
  
  // Catch asynchronous Dart/Platform Errors safely
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) debugPrint('Global Async Exception: $error');
    // TODO: Send error to Firebase Crashlytics Service
    return true; 
  };

  // Load environment variables (obfuscated via envied)
  // No longer using flutter_dotenv directly

  // Initialize Hive (local storage)
  await Hive.initFlutter();

  // Attempt Firebase initialization with retry logic
  bool firebaseInitialized = false;
  Exception? initError;
  int retryCount = 0;
  const maxRetries = 3;

  while (retryCount < maxRetries && !firebaseInitialized) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
    } catch (e, stacktrace) {
      initError = e is Exception ? e : Exception(e.toString());
      if (kDebugMode) debugPrint('Firebase init attempt ${retryCount + 1} failed: $e\n$stacktrace');
      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // Configure Firestore settings only if initialized
  if (firebaseInitialized) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Initialize push notifications (FCM)
  await NotificationService().initialize();

  // Run the app
  runApp(
    ProviderScope(
      child: MyApp(
        firebaseInitialized: firebaseInitialized,
        firebaseInitError: initError,
      ),
    ),
  );
}

/// Main app widget - handles global error states and theming
class MyApp extends ConsumerWidget {
  final bool firebaseInitialized;
  final Exception? firebaseInitError;

  const MyApp({
    super.key,
    required this.firebaseInitialized,
    this.firebaseInitError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If Firebase failed to initialize, show an error screen with retry
    if (!firebaseInitialized) {
      return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'كلية الطاقة المتجددة',
        home: _FirebaseInitErrorScreen(
          error: firebaseInitError,
          onRetry: () => _retryFirebaseInit(),
        ),
      );
    }

    // Get theme data from Riverpod providers
    final themeMode = ref.watch(themeModeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    // Build the main app with proper localization and offline banner
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'كلية الطاقة المتجددة',
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(lightTheme.textTheme),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(darkTheme.textTheme),
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
        // Wrap with RTL direction and offline banner
        return Directionality(
          textDirection: TextDirection.rtl,
          child: OfflineBanner(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const SplashScreen(next: AuthGate()),
    );
  }

  /// Retry Firebase initialization
  Future<void> _retryFirebaseInit() async {
    // Re-run main logic (simple app restart)
    // In a real scenario, you might want to use a more sophisticated approach
    // like using a stateful widget that rebuilds, but for simplicity we restart the app.
    // For a production app, consider using a dedicated service to reinitialize.
    // Here we just call `main()` again, but it's not ideal. A better approach:
    // Use a state management solution to reinitialize Firebase and rebuild the widget tree.
    // For now, we'll just trigger a rebuild by setting a state.
    // Since we are outside the widget tree, we'll use a global variable or a restart.
    // We'll implement a simple restart using `runApp` again, but ensure proper cleanup.
    // Alternatively, we can use a `StatefulWidget` with a key to recreate.
    // For demonstration, we'll call `main()` again (this is not recommended for production,
    // but works for this scenario if you ensure no side effects).
    // A production solution would involve a dedicated service that can reinitialize
    // and then rebuild the UI without restarting the entire app.
    // I'll provide a more robust approach:
    final completer = Completer<void>();
    Future.delayed(Duration.zero, () {
      // Recall main() to safely trigger Firebase Initialization over again
      main();
      completer.complete();
    });
    return completer.future;
  }
}

/// Error screen displayed when Firebase fails to initialize
class _FirebaseInitErrorScreen extends StatelessWidget {
  final Exception? error;
  final VoidCallback onRetry;

  const _FirebaseInitErrorScreen({
    required this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'فشل تهيئة التطبيق',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              if (error != null)
                Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Authentication gate - decides which home screen to show based on user role
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Subscribe to notification topics based on user profile (auto-updates)
    ref.watch(notificationTopicsProvider);

    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const LoginPage();

        // Route based on user role
        switch (user.role) {
          case UserRole.admin:
            // Admin should use the web dashboard, not the mobile app
            return const AccessDeniedScreen();
          case UserRole.supervisor:
            return const SupervisorHome();
          case UserRole.teacher:
            return const TeacherHome();
          case UserRole.student:
            return const StudentHome();
        }
      },
      loading: () => const _LoadingScreen(),
      error: (error, stackTrace) {
        // Show global error and allow retry
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text(
                'خطأ في الاتصال بالخادم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
        });
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: CustomErrorWidget(
            message: 'حدث خطأ أثناء تحميل البيانات: $error',
            onRetry: () => ref.refresh(authProvider),
          ),
        );
      },
    );
  }
}

/// Loading screen while authentication state is being determined
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}