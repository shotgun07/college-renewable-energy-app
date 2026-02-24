import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/schedule_provider.dart';
import '../../widgets/student/student_scaffold.dart';

class StudentViewSchedule extends ConsumerWidget {
  final String department;
  const StudentViewSchedule({super.key, required this.department});

  String _deptToCode(String deptName) {
    switch (deptName) {
      case 'ICT':
        return 'ICT';
      case 'طاقة':
        return 'RE';
      case 'بيئة':
        return 'ENV';
      case 'عام':
      default:
        return 'GEN';
    }
  }

  int _asInt(dynamic v, {int fallback = 1}) {
    if (v == null) return fallback;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? fallback;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => const StudentScaffold(
        title: "?????? ???????",
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (e, st) => StudentScaffold(
        title: "?????? ???????",
        body: Center(child: Text("???: $e", style: const TextStyle(color: Colors.white))),
      ),
      data: (user) {
        if (user == null) {
          return const StudentScaffold(
            title: "?????? ???????",
            body: Center(
                child: Text("??? ????? ?????? ?????",
                    style: TextStyle(color: Colors.white))),
          );
        }

        final deptName = (user.departmentName.isNotEmpty ? user.departmentName : department);
        final deptCode = _deptToCode(deptName);
        final semester = _asInt(user.semester, fallback: 1);

        final schedulesAsync = ref.watch(scheduleStreamProvider(deptCode, semester));

        return StudentScaffold(
          title: "?????? ???????",
          body: schedulesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (e, st) => Center(
                child: Text("???: $e", style: const TextStyle(color: Colors.white))),
            data: (docs) {
              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 60, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(height: 15),
                      Text(
                        "?? ???? ???? ????? ???? $deptName (??? $semester) ??????",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final data = docs.first;
              final title = (data['title'] ?? '?????? ???????').toString();
              final items = (data['items'] is List) ? (data['items'] as List) : [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (items.isEmpty)
                    const Center(
                        child: Text("?????? ????? ??? ???? ?????",
                            style: TextStyle(color: Colors.white38)))
                  else
                    ...items.map((e) {
                      final m = (e is Map)
                          ? Map<String, dynamic>.from(e)
                          : <String, dynamic>{};
                      final day = (m['day'] ?? '').toString();
                      final time = (m['time'] ?? '').toString();
                      final course = (m['course'] ?? '').toString();
                      final room = (m['room'] ?? '').toString();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.calendar_month, color: Colors.blue),
                          ),
                          title: Text(
                            course.isEmpty ? "??????" : course,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                if (day.isNotEmpty) ...[
                                  Icon(Icons.today,
                                      size: 14,
                                      color: Colors.white.withValues(alpha: 0.6)),
                                  const SizedBox(width: 4),
                                  Text(day,
                                      style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 13)),
                                  const SizedBox(width: 15),
                                ],
                                if (time.isNotEmpty) ...[
                                  Icon(Icons.access_time,
                                      size: 14,
                                      color: Colors.white.withValues(alpha: 0.6)),
                                  const SizedBox(width: 4),
                                  Text(time,
                                      style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 13)),
                                ],
                              ],
                            ),
                          ),
                          trailing: room.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(room,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                )
                              : null,
                        ),
                      );
                    }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
