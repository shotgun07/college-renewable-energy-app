import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../presentation/providers/auth_provider.dart';

class AdminVerifyUsersScreen extends ConsumerWidget {
  const AdminVerifyUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unverifiedUsersAsync = ref.watch(unverifiedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمون بانتظار التحقق'),
      ),
      body: unverifiedUsersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد مستخدمون بانتظار التحقق',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(user.fullName),
                  subtitle: Text(user.email ?? 'لا يوجد بريد إلكتروني'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.vpn_key, color: Colors.blue),
                        onPressed: () => _generateCode(context, ref, user.uid),
                        tooltip: 'توليد رمز',
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () =>
                            _manuallyVerify(context, ref, user.uid),
                        tooltip: 'تحقق يدوي',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('حدث خطأ: $e')),
      ),
    );
  }

  Future<void> _generateCode(
      BuildContext context, WidgetRef ref, String uid) async {
    try {
      final code =
          await ref.read(authProvider.notifier).generateVerificationCode(uid);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تم توليد الرمز'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('رمز التحقق للمستخدم هو:'),
                const SizedBox(height: 16),
                SelectableText(
                  code,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4),
                ),
                const SizedBox(height: 16),
                const Text('قم بإعطاء هذا الرمز للمستخدم لإدخاله في التطبيق.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الرمز')),
                  );
                },
                child: const Text('نسخ'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل توليد الرمز: $e')),
        );
      }
    }
  }

  Future<void> _manuallyVerify(
      BuildContext context, WidgetRef ref, String uid) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد التحقق'),
        content: const Text(
            'هل أنت متأكد من رغبتك في توثيق حساب هذا المستخدم يدوياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('نعم، وثق الحساب'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final admin = ref.read(currentUserProvider);
      if (admin == null) return;

      await ref.read(authProvider.notifier).manuallyVerifyUser(uid, admin.uid);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم توثيق الحساب بنجاح')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التوثيق: $e')),
        );
      }
    }
  }
}
