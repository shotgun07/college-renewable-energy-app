import 'package:flutter/material.dart';
import '../../widgets/supervisor/supervisor_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import '../admin/manage_students_screen.dart';
import '../admin/admin_send_notification_screen.dart';
import '../schedules/teacher_schedule_screen.dart';

class SupervisorHome extends StatelessWidget {
  const SupervisorHome({super.key});

  @override
  Widget build(BuildContext context) {
    const departmentName = "قسم الحاسب الآلي";

    return SupervisorScaffold(
      title: 'لوحة المشرف - $departmentName',
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
        _SupervisorStatCard(
            title: 'طلاب القسم',
            value: '320',
            icon: Icons.school,
            color: Colors.cyan),
        _SupervisorStatCard(
            title: 'أساتذة القسم',
            value: '15',
            icon: Icons.cast_for_education,
            color: Colors.teal),
        _SupervisorStatCard(
            title: 'الجداول',
            value: '8',
            icon: Icons.calendar_today,
            color: Colors.indigo),
        _SupervisorStatCard(
            title: 'التقارير',
            value: '2',
            icon: Icons.bar_chart,
            color: Colors.deepPurple),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة القسم',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GlassTile(
          title: 'أساتذة القسم',
          subtitle: 'عرض وإدارة أعضاء هيئة التدريس',
          icon: Icons.people_alt,
          color: Colors.teal,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ManageStudentsScreen()));
          },
        ),
        GlassTile(
          title: 'إدارة الجداول',
          subtitle: 'تعديل الجداول الدراسية',
          icon: Icons.edit_calendar,
          color: Colors.indigo,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TeacherScheduleScreen()));
          },
        ),
        GlassTile(
          title: 'إرسال إعلان',
          subtitle: 'نشر إعلان لطلاب القسم',
          icon: Icons.campaign,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminSendNotificationScreen()));
          },
        ),
      ],
    );
  }
}

class _SupervisorStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SupervisorStatCard({
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
