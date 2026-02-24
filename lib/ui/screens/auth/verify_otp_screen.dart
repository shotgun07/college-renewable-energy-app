import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../services/auth_service.dart';
import '../home/student_home.dart';
import '../home/teacher_home.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final Function(String) onVerify;

  const VerifyOTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.onVerify,
  });

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final _otpController = TextEditingController();
  final AuthService _authService = AuthService();

  Timer? _timer;
  int _timerSeconds = 25;
  bool _emailFallbackAvailable = false;
  bool _emailRequestInProgress = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (_timerSeconds == 0) {
        setState(() {
          _emailFallbackAvailable = true;
        });
        t.cancel();
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailFallback() async {
    if (_emailRequestInProgress) return;
    _emailRequestInProgress = true;

    final user = _authService.currentUser;

    if (user != null && user.email != null && user.email!.isNotEmpty) {
      await _authService.sendEmailVerificationOnly();
      _navigateToEmailWait();
    } else {
      _showEmailInputDialog();
    }

    _emailRequestInProgress = false;
  }

  void _showEmailInputDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("التحقق بالبريد", textAlign: TextAlign.right),
        content: TextField(
          controller: emailController,
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              emailController.dispose();
            },
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.contains('@')) {
                Navigator.pop(context);
                await _authService.updateAndSendEmailVerification(email);
                _navigateToEmailWait();
              }
              emailController.dispose();
            },
            child: const Text("إرسال"),
          ),
        ],
      ),
    );
  }

  void _navigateToEmailWait() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EmailWaitingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "أدخل رمز التحقق",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(widget.phoneNumber),
              const SizedBox(height: 30),
              Pinput(
                length: 6,
                controller: _otpController,
                onCompleted: widget.onVerify,
              ),
              const SizedBox(height: 40),
              if (!_emailFallbackAvailable)
                Text("إعادة الإرسال خلال $_timerSeconds ثانية"),
              if (_emailFallbackAvailable)
                TextButton(
                  onPressed: _handleEmailFallback,
                  child: const Text("لم يصلك الرمز؟ استخدم البريد"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailWaitingScreen extends StatefulWidget {
  const EmailWaitingScreen({super.key});

  @override
  State<EmailWaitingScreen> createState() => _EmailWaitingScreenState();
}

class _EmailWaitingScreenState extends State<EmailWaitingScreen> {
  final AuthService _authService = AuthService();
  Timer? _checkTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted || _navigated) return;

      final verified = await _authService.checkEmailVerified();
      if (verified) {
        _navigated = true;
        _checkTimer?.cancel();
        _navigateToHome();
      }
    });
  }

  Future<void> _navigateToHome() async {
    final user = _authService.currentUser;
    if (user == null || !mounted) return;

    final doc = await _authService.getUserData(user.uid);
    final role = doc.data()?['role']?.toString().toLowerCase();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            role == 'teacher' ? const TeacherHome() : const StudentHome(),
      ),
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read, size: 80),
            SizedBox(height: 20),
            Text("تم إرسال رابط التحقق"),
            SizedBox(height: 10),
            Text("يرجى تأكيد البريد للمتابعة"),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
