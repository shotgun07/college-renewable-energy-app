import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _sending = false;
  bool _checking = false;

  Future<void> _resend() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    setState(() => _sending = true);
    try {
      await u.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال رابط التحقق إلى بريدك الإلكتروني")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تعذر الإرسال: $e")));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _check() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    setState(() => _checking = true);
    try {
      await u.reload();
      final refreshed = FirebaseAuth.instance.currentUser;
      if (refreshed != null && refreshed.emailVerified) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم التحقق بنجاح ✅")));
        setState(() {});
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لم يتم التحقق بعد. افتح البريد واضغط رابط التحقق.")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;
    final email = u?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("تأكيد البريد الإلكتروني"),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 90),
            const SizedBox(height: 12),
            const Text(
              "تم إنشاء الحساب بنجاح ✅\nيرجى تأكيد البريد الإلكتروني للمتابعة",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (email.isNotEmpty) Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _sending ? null : _resend,
                icon: const Icon(Icons.send),
                label: _sending ? const Text("جاري الإرسال...") : const Text("إعادة إرسال رابط التحقق"),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _checking ? null : _check,
                icon: const Icon(Icons.verified),
                label: _checking ? const Text("جاري التحقق...") : const Text("تحققت من البريد (تم)"),
              ),
            ),
            const Spacer(),
            const Text(
              "ملاحظة: قد يصل الرابط إلى البريد غير الهام (Spam).",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
