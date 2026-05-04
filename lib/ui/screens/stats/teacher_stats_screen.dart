import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/presentation/providers/stats_provider.dart';
import 'package:app/ui/widgets/teacher/teacher_scaffold.dart';
import 'package:app/ui/widgets/common/glass_components.dart';
import 'package:app/domain/entities/stats.dart';

class TeacherStatsScreen extends ConsumerWidget {
  const TeacherStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(teacherStatsProvider);

    return TeacherScaffold(
      title: 'إحصائيات المدرس',
      body: statsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) =>
            const Center(child: Text('خطأ في جلب البيانات', style: TextStyle(color: Colors.white))),
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatGrid(stats),
                const SizedBox(height: 30),
                _buildPerformanceChart(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatGrid(Stats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildStatCard('الطلاب', stats.totalStudents.toString(), Icons.people,
            Colors.blue),
        _buildStatCard('المحاضرات', stats.totalLectures.toString(), Icons.book,
            Colors.orange),
        _buildStatCard('المحادثات', stats.totalChats.toString(), Icons.chat,
            Colors.green),
        _buildStatCard('الجداول', stats.totalSchedules.toString(),
            Icons.calendar_today, Colors.purple),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    // Simple visual weekly activity using bars
    const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
    const values = [0.6, 0.9, 0.4, 0.75, 0.5]; // relative heights

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Color(0xFF64B5F6), size: 22),
              const SizedBox(width: 8),
              const Text(
                'نشاط الأسبوع الحالي',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 80 * values[i],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF42A5F5).withValues(alpha: 0.9),
                                const Color(0xFF1976D2).withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i],
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 15),
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
