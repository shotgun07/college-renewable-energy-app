import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart' as legacy;
import '../../models/app_user.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/glass_components.dart';
import '../screens/feedback_analytics_screen.dart';

class DashboardHome extends StatefulWidget {
  final AppUser user;

  const DashboardHome({super.key, required this.user});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _totalStudents = 0;
  int _totalTeachers = 0;
  int _totalCourses = 0;
  static const int _totalLectures = 0; // Fixed finality as per request
  int _totalAnnouncements = 0;
  int _totalAttendanceRecords = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      // Count students
      final studentsSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'student')
          .count()
          .get();
      _totalStudents = studentsSnap.count ?? 0;

      // Count teachers
      final teachersSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .count()
          .get();
      _totalTeachers = teachersSnap.count ?? 0;

      // Count courses
      final coursesSnap =
          await FirebaseFirestore.instance.collection('courses').count().get();
      _totalCourses = coursesSnap.count ?? 0;

      // Count announcements
      final announcementsSnap = await FirebaseFirestore.instance
          .collection('announcements')
          .count()
          .get();
      _totalAnnouncements = announcementsSnap.count ?? 0;

      // Count attendance records
      final attendanceSnap = await FirebaseFirestore.instance
          .collection('attendance')
          .count()
          .get();
      _totalAttendanceRecords = attendanceSnap.count ?? 0;

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error loading statistics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = legacy.Provider.of<ThemeProvider>(context);

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message
                  Text(
                    'مرحباً، ${widget.user.fullName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.user.role == UserRole.admin ? 'مدير النظام' : 'مشرف',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.isDarkMode
                          ? Colors.white60
                          : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Statistics Grid
                  _buildStatisticsGrid(),

                  const SizedBox(height: 30),

                  // Quick Actions
                  Text(
                    'الإجراءات السريعة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActions(),

                  const SizedBox(height: 30),

                  // Charts Section
                  Text(
                    'الإحصائيات التفصيلية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(),
                ],
              ),
            ),
          );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'إجمالي الطلاب',
          value: _totalStudents.toString(),
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'أعضاء التدريس',
          value: _totalTeachers.toString(),
          icon: Icons.person_pin,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'المواد الدراسية',
          value: _totalCourses.toString(),
          icon: Icons.menu_book,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'المحاضرات',
          value: _totalLectures.toString(),
          icon: Icons.video_library,
          color: Colors.purple,
        ),
        _buildStatCard(
          title: 'الإعلانات',
          value: _totalAnnouncements.toString(),
          icon: Icons.announcement,
          color: Colors.red,
        ),
        _buildStatCard(
          title: 'سجلات الحضور',
          value: _totalAttendanceRecords.toString(),
          icon: Icons.check_circle,
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        GlassTile(
          title: 'إدارة الطلاب',
          subtitle: 'عرض وتعديل بيانات الطلاب',
          icon: Icons.people_alt,
          color: Colors.blue,
          onTap: () {
            // Navigate to students management
          },
        ),
        GlassTile(
          title: 'إدارة المعلمين',
          subtitle: 'عرض وتعديل بيانات المعلمين',
          icon: Icons.person,
          color: Colors.green,
          onTap: () {
            // Navigate to teachers management
          },
        ),
        GlassTile(
          title: 'إدارة المواد',
          subtitle: 'إضافة وتعديل المواد الدراسية',
          icon: Icons.menu_book,
          color: Colors.orange,
          onTap: () {
            // Navigate to courses management
          },
        ),
        GlassTile(
          title: 'إدارة المحاضرات',
          subtitle: 'عرض وإدارة المحاضرات المرفوعة',
          icon: Icons.video_library,
          color: Colors.purple,
          onTap: () {
            // Navigate to lectures management
          },
        ),
        GlassTile(
          title: 'إرسال إشعار',
          subtitle: 'إرسال تنبيهات للطلاب والأساتذة',
          icon: Icons.notifications_active,
          color: Colors.red,
          onTap: () {
            // Navigate to send notification
          },
        ),
        GlassTile(
          title: 'التقييمات والاستبيانات',
          subtitle: 'عرض آراء الطلاب وتقييماتهم',
          icon: Icons.star_rate,
          color: Colors.yellow,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FeedbackAnalyticsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'توزيع المستخدمين',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (_totalStudents > _totalTeachers
                            ? _totalStudents
                            : _totalTeachers)
                        .toDouble() *
                    1.2,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return const Text('طلاب', style: style);
                          case 1:
                            return const Text('معلمون', style: style);
                          case 2:
                            return const Text('مواد', style: style);
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: _totalStudents.toDouble(),
                        color: Colors.blue,
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: _totalTeachers.toDouble(),
                        color: Colors.green,
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: _totalCourses.toDouble(),
                        color: Colors.orange,
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
