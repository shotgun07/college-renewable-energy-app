import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _auth = AuthService();

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
      await _auth.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = "تعذر الإرسال";

      setState(() {
        _lastFailedEmail = email;
        if (e.code == 'invalid-email') {
          msg = "البريد غير صحيح";
          _emailError = "أدخل بريد صحيح";
        }
        if (e.code == 'user-not-found') {
          msg = "لا يوجد حساب بهذا البريد";
          _emailError = "لا يوجد حساب بهذا البريد";
        }
        if (e.code == 'too-many-requests') {
          msg = "محاولات كثيرة. انتظر قليلاً";
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _lastFailedEmail = email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تعذر الإرسال: $e")));
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
