import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/result_provider.dart';
import '../../widgets/student/student_scaffold.dart';

class StudentViewResults extends ConsumerWidget {
  final String studentID;
  const StudentViewResults({super.key, required this.studentID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (studentID.isEmpty) {
      return const StudentScaffold(
        title: "النتائج الدراسية",
        body: Center(
            child: Text("لم يتم تعيين رقم الطالب، يرجى التواصل مع الإدارة.",
                style: TextStyle(color: Colors.white))),
      );
    }

    final resultsAsync = ref.watch(resultsStreamProvider(studentID));

    return StudentScaffold(
      title: "النتائج الدراسية",
      body: resultsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text("حدث خطأ في تحميل النتائج",
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8), fontSize: 16)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => ref.invalidate(resultsStreamProvider(studentID)),
              icon: const Icon(Icons.refresh, color: Colors.white70),
              label: const Text("أعد المحاولة",
                  style: TextStyle(color: Colors.white70)),
            ),
          ],
        )),
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_ind_outlined,
                      size: 70, color: Colors.white.withValues(alpha: 0.15)),
                  const SizedBox(height: 15),
                  Text(
                    "لا توجد نتائج مسجلة لهذا الطالب حتى الآن",
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Calculate summary stats
          final numericGrades = results
              .map((d) => d['grade'])
              .whereType<num>()
              .toList();
          final average = numericGrades.isNotEmpty
              ? numericGrades.reduce((a, b) => a + b) / numericGrades.length
              : null;
          final passed =
              numericGrades.where((g) => g >= 50).length;
          final failed = numericGrades.length - passed;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Student ID card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.badge_outlined,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("رقم قيد الطالب",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        Text(
                          studentID,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats row
              if (average != null)
                Row(
                  children: [
                    Expanded(
                        child: _StatCard(
                      icon: Icons.calculate_outlined,
                      label: 'المعدل',
                      value: average.toStringAsFixed(1),
                      color: _gradeColor(average),
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _StatCard(
                      icon: Icons.check_circle_outline,
                      label: 'ناجح',
                      value: '$passed',
                      color: Colors.greenAccent,
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _StatCard(
                      icon: Icons.cancel_outlined,
                      label: 'راسب',
                      value: '$failed',
                      color: Colors.redAccent,
                    )),
                  ],
                ),
              const SizedBox(height: 20),

              const Text(
                "كشف الدرجات",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08))),
                    columnWidths: const {
                      0: FlexColumnWidth(2.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1.2),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                        ),
                        children: const [
                          Padding(
                              padding: EdgeInsets.all(14),
                              child: Text("المادة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          Padding(
                              padding: EdgeInsets.all(14),
                              child: Text("الدرجة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          Padding(
                              padding: EdgeInsets.all(14),
                              child: Text("التقدير",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                        ],
                      ),
                      ...results.map((d) {
                        final subject = (d['subject'] ?? '').toString();
                        final grade = d['grade'];
                        final letterGrade = _letterGrade(grade);
                        return TableRow(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(subject,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13))),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                grade.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _gradeColor(grade)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      _gradeColor(grade).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  letterGrade,
                                  style: TextStyle(
                                      color: _gradeColor(grade),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _gradeColor(dynamic grade) {
    if (grade is num) {
      if (grade >= 85) return Colors.greenAccent;
      if (grade >= 70) return Colors.lightBlueAccent;
      if (grade >= 50) return Colors.orangeAccent;
      return Colors.redAccent;
    }
    return Colors.white;
  }

  String _letterGrade(dynamic grade) {
    if (grade is num) {
      if (grade >= 90) return 'A+';
      if (grade >= 85) return 'A';
      if (grade >= 80) return 'B+';
      if (grade >= 75) return 'B';
      if (grade >= 70) return 'C+';
      if (grade >= 65) return 'C';
      if (grade >= 60) return 'D+';
      if (grade >= 50) return 'D';
      return 'F';
    }
    return '-';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
