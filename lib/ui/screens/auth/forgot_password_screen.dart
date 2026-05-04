import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../presentation/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _loading = false;
  String? _emailError;
  String? _lastFailedEmail;

  bool _isValidEmail(String v) {
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(v.trim());
  }

  Future<void> _send() async {
    if (_loading) return;

    FocusScope.of(context).unfocus();
    _emailError = null;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      setState(() {});
      return;
    }

    final email = _email.text.trim();

    if (_lastFailedEmail == email) {
      setState(() {
        _emailError = "غيّر البريد أو تأكد منه ثم حاول";
      });
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(authProvider.notifier).resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _lastFailedEmail = email);
      String msg = "تعذر الإرسال: $e";
      if (e.toString().contains('invalid-email')) {
        msg = "البريد غير صحيح";
        _emailError = "أدخل بريد صحيح";
      } else if (e.toString().contains('user-not-found')) {
        msg = "لا يوجد حساب بهذا البريد";
        _emailError = "لا يوجد حساب بهذا البريد";
      } else if (e.toString().contains('too-many-requests')) {
        msg = "محاولات كثيرة. انتظر قليلاً";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _email.addListener(() {
      if (_emailError != null) setState(() => _emailError = null);
      if (_lastFailedEmail != null && _email.text.trim() != _lastFailedEmail) {
        _lastFailedEmail = null;
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("استعادة كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "البريد الإلكتروني",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  errorText: _emailError,
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return "أدخل البريد الإلكتروني";
                  if (!_isValidEmail(t)) return "أدخل بريد صحيح";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _send,
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("إرسال رابط الاستعادة"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
