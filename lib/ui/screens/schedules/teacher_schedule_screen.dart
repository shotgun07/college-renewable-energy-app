import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/ui/widgets/teacher/teacher_scaffold.dart';
import 'package:app/ui/widgets/common/glass_components.dart';
import 'package:app/presentation/providers/schedule_provider.dart';

class TeacherScheduleScreen extends ConsumerWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(allSchedulesProvider);

    return TeacherScaffold(
      title: 'الجدول الدراسي',
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => const Center(
            child: Text('حدث خطأ', style: TextStyle(color: Colors.white))),
        data: (docs) {
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_outlined,
                      size: 80, color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(height: 20),
                  Text(
                    'لا يوجد جدول دراسي بعد',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'سيتم إضافة الجداول من قبل الإدارة',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return _buildScheduleCard(docs[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> data) {
    final day = (data['day'] ?? 'يوم').toString();
    final sessions = (data['sessions'] ?? []) as List<dynamic>;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64B5F6),
            ),
          ),
          const Divider(color: Colors.white10),
          if (sessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('لا توجد محاضرات',
                  style: TextStyle(color: Colors.white38)),
            )
          else
            ...sessions.map((s) {
              final session = s as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(session['time'] ?? '',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session['subject'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          if ((session['location'] ?? '').toString().isNotEmpty)
                            Text(session['location'] ?? '',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
