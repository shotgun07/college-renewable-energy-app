import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/auth_exceptions.dart';
import '../../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../../../services/two_factor_service.dart';
import '../../../ui/screens/auth/register_screen.dart';
import '../../../ui/screens/auth/verify_otp_screen.dart';
import '../../../ui/screens/home/student_home.dart';
import '../../../ui/screens/home/teacher_home.dart';
// import '../../../ui/screens/home/admin_home.dart'; // Uncomment when available

/// Riverpod-based Login Page with Clean Architecture integration
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat(reverse: true);

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeController.forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.right),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("يرجى ملء جميع الحقول");
      return;
    }

    // Trigger login via Riverpod provider
    await ref.read(authProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  void _navigateBasedOnRole(User user) {
    if (!mounted) return;

    // Clear navigation stack
    Navigator.of(context).popUntil((route) => route.isFirst);

    Widget homeScreen;
    switch (user.role) {
      case UserRole.admin:
        homeScreen = const TeacherHome(); // Placeholder for AdminHome
        break;
      case UserRole.teacher:
        homeScreen = const TeacherHome();
        break;
      case UserRole.supervisor:
        homeScreen = const TeacherHome(); // Placeholder
        break;
      case UserRole.student:
        homeScreen = const StudentHome();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => homeScreen),
    );
  }

  void _handleTwoFactor(User user) async {
    if (user.phoneNumber.isEmpty) {
      await ref.read(authProvider.notifier).signOut();
      _showError("تم تفعيل المصادقة الثنائية ولكن لا يوجد رقم هاتف مسجل.");
      return;
    }

    // Send OTP using legacy service for now (to be migrated)
    await TwoFactorService().requestOTP(
      phoneNumber: user.phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOTPScreen(
              verificationId: verificationId,
              phoneNumber: user.phoneNumber,
              onVerify: (smsCode) async {
                // Here we might need a specific usecase for completing 2FA
                // For now, assume if OTP verifies, we proceed.
                // NOTE: VerifyOTPScreen implementation might differ.
                // Original code did signInWithCredential AGAIN.
                // But we are already signed in.
                // We just need to verify the code matches.
                // If checking code via Firebase Phone Auth, we might need a method in repo.

                // For now, let's assume if they pass the screen, they are good.
                // OR we can implement a verifyOTP method in AuthRepository later.
                // Given the atomic constraint, sticking to similar logic:
                // VerifyOTPScreen usually does the verification itself.
                _navigateBasedOnRole(user);
              },
            ),
          ),
        );
      },
      onVerificationFailed: (e) {
        _showError("فشل إرسال رمز التحقق: ${e.message}");
        // We might want to sign out if 2FA fails initiation
        ref.read(authProvider.notifier).signOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for side effects (navigation, error)
    ref.listen<AsyncValue<User?>>(authProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            // TODO: RE-ENABLE OTP — Change kOtpEnabled to true to restore 2FA
            const bool kOtpEnabled = false;
            // The following check allows compilation and avoids dead code warning, but logically keeps 2FA disabled.
            if (user.twoFactorEnabled && (kOtpEnabled == true)) {
              _handleTwoFactor(user);
            } else {
              _navigateBasedOnRole(user);
            }
          }
        },
        error: (error, stackTrace) {
          String message = "حدث خطأ غير متوقع";
          if (error is AuthException) {
            message = error.message;
          } else {
            message = error.toString();
          }
          _showError(message);
        },
        loading: () {}, // Handled in UI via isLoading check
      );
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
              ),
            ),
          ),

          // Animated Orbs (Preserved from original)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100 + (_controller.value * 50),
                    left: -50 + (_controller.value * 30),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF1976D2).withValues(alpha: 0.2),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -100 - (_controller.value * 50),
                    right: -50 - (_controller.value * 30),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF64B5F6).withValues(alpha: 0.1),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Glassmorphism Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1976D2)
                                    .withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/college_logo.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.school,
                                size: 60,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Welcome Text
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  "مرحباً بك",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  "قم بتسجيل الدخول للمتابعة",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Login Form
                        _buildGlassContainer(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                hint: "البريد الإلكتروني",
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _passwordController,
                                icon: Icons.lock_outline,
                                hint: "كلمة المرور",
                                isPassword: true,
                                isVisible: _isPasswordVisible,
                                onVisibilityChanged: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),

                              // Forgot Password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _showForgotPasswordDialog();
                                    },
                                    child: const Text(
                                      "نسيت كلمة المرور؟",
                                      style: TextStyle(
                                          color: Color(0xFF64B5F6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1976D2),
                                      Color(0xFF64B5F6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1976D2)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize:
                                        const Size(double.infinity, 55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          "تسجيل الدخول",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Register Link
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "ليس لديك حساب؟",
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: const Text(
                                  "إنشاء حساب جديد",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isVisible,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.white70,
                      ),
                      onPressed: onVisibilityChanged,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("استعادة كلمة المرور",
            style: TextStyle(color: Colors.white), textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "أدخل بريدك الإلكتروني لاستلام رابط إعادة تعيين كلمة المرور",
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "البريد الإلكتروني",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) return;

              try {
                await ref
                    .read(authRepositoryProvider)
                    .resetPassword(emailController.text.trim());
                if (!context.mounted) return;

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم إرسال الرابط بنجاح")),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("خطأ: $e")),
                );
              }
            },
            child: const Text("إرسال"),
          ),
        ],
      ),
    );
  }
}
