import 'package:flutter/material.dart';
import '../../widgets/admin/admin_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import '../admin/admin_courses_screen.dart';
import '../admin/admin_send_notification_screen.dart';
import '../admin/admin_verify_users_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'لوحة الإدارة العامة',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStatGrid(),
            const SizedBox(height: 30),
            _buildActionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: const [
        _AdminStatCard(
            title: 'إجمالي الطلاب',
            value: '1250',
            icon: Icons.people,
            color: Colors.blue),
        _AdminStatCard(
            title: 'أعضاء هيئة التدريس',
            value: '85',
            icon: Icons.person_pin,
            color: Colors.green),
        _AdminStatCard(
            title: 'المشرفين',
            value: '4',
            icon: Icons.supervisor_account,
            color: Colors.orange),
        _AdminStatCard(
            title: 'الأقسام',
            value: '4',
            icon: Icons.domain,
            color: Colors.purple),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GlassTile(
          title: 'إدارة المواد الدراسية',
          subtitle: 'إضافة وتعديل مواد الأقسام',
          icon: Icons.menu_book,
          color: Colors.blue,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminCoursesScreen()));
          },
        ),
        GlassTile(
          title: 'إدارة المشرفين',
          subtitle: 'تعيين المشرفين للأقسام',
          icon: Icons.manage_accounts,
          color: Colors.orange,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminCoursesScreen()));
          },
        ),
        GlassTile(
          title: 'تأكيد الحسابات',
          subtitle: 'تفعيل حسابات الطلاب المعلقة',
          icon: Icons.verified_user,
          color: Colors.teal,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminVerifyUsersScreen()));
          },
        ),
        GlassTile(
          title: 'إرسال إشعار',
          subtitle: 'إرسال تنبيهات للطلاب والأساتذة',
          icon: Icons.notifications_active,
          color: Colors.redAccent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminSendNotificationScreen()));
          },
        ),
        GlassTile(
          title: 'الإعدادات العامة',
          subtitle: 'ضبط الفصول الدراسية والإعلانات',
          icon: Icons.settings,
          color: Colors.grey,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الإعدادات قيد التطوير')),
            );
          },
        ),
      ],
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
