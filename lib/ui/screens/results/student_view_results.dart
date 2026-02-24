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
        title: "?????? ????????",
        body: Center(
            child: Text("?? ???? ??? ??????? ??? ??? ????? ??? ?????.",
                style: TextStyle(color: Colors.white))),
      );
    }

    final resultsAsync = ref.watch(resultsStreamProvider(studentID));

    return StudentScaffold(
      title: "?????? ????????",
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => Center(
            child: Text("???: $e", style: const TextStyle(color: Colors.white))),
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_ind_outlined,
                      size: 60, color: Colors.white.withValues(alpha: 0.2)),
                  const SizedBox(height: 15),
                  Text(
                    "?? ??? ??? ????? ???? ????? ???",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.badge_outlined, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Text(
                      "??? ?????: $studentID",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "??? ???????",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Table(
                    border: TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1)
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                        ),
                        children: [
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("??????",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("??????",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...results.map((d) {
                        final subject = (d['subject'] ?? '').toString();
                        final grade = d['grade'];
                        return TableRow(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(subject,
                                    style: const TextStyle(color: Colors.white))),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                grade.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _gradeColor(grade)),
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
      if (grade >= 50) return Colors.lightBlueAccent;
      return Colors.redAccent;
    }
    return Colors.white;
  }
}
