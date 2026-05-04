import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';
import '../../../presentation/providers/admin_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';
import '../../widgets/common/glass_components.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  String? _selectedDept;
  int? _selectedSemester;
  bool _isLoading = false;
  List<User> _students = [];
  final Map<String, bool> _attendanceMap = {};

  final List<String> _departments = ['عام', 'ICT', 'طاقة', 'بيئة'];

  List<int> _getSemesters() {
    if (_selectedDept == 'عام') return [1, 2];
    if (_selectedDept != null) return [3, 4, 5, 6, 7, 8];
    return [];
  }

  Future<void> _fetchStudents() async {
    if (_selectedDept == null || _selectedSemester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار القسم والفصل')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final users = await ref
          .read(adminRepositoryProvider)
          .getStudentsByDeptSemester(_selectedDept!, _selectedSemester!);

      final list = users.toList();

      setState(() {
        _students = list;
        _attendanceMap.clear();
        for (var s in list) {
          _attendanceMap[s.uid] = true;
        }
      });

      if (list.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يوجد طلاب مسجلون في هذا الفصل')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAttendance() async {
    if (_students.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الغياب بنجاح')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TeacherScaffold(
      title: 'رصد الغياب',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GlassDropdown<String>(
                        hint: 'القسم',
                        value: _selectedDept,
                        items: _departments,
                        itemLabel: (x) => x,
                        onChanged: (v) {
                          setState(() {
                            _selectedDept = v;
                            _selectedSemester = null;
                            _students = [];
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GlassDropdown<int>(
                        hint: 'الفصل',
                        value: _selectedSemester,
                        items: _getSemesters(),
                        itemLabel: (x) => x.toString(),
                        onChanged: (v) => setState(() => _selectedSemester = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fetchStudents,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                            color: Colors.blue.withValues(alpha: 0.5)),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('عرض الطلاب'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: _students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.1)),
                        const SizedBox(height: 10),
                        Text(
                          _isLoading
                              ? 'جاري التحميل...'
                              : 'قم باختيار القسم والفصل لعرض القائمة',
                          style: const TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      final isPresent = _attendanceMap[student.uid] ?? true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isPresent
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: SwitchListTile(
                          title: Text(student.fullName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('رقم القيد: ${student.studentID}',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6))),
                          value: isPresent,
                          activeThumbColor: Colors.greenAccent,
                          inactiveThumbColor: Colors.redAccent,
                          activeTrackColor: Colors.green.withValues(alpha: 0.3),
                          inactiveTrackColor: Colors.red.withValues(alpha: 0.3),
                          onChanged: (val) {
                            setState(() {
                              _attendanceMap[student.uid] = val;
                            });
                          },
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPresent ? Icons.check : Icons.close,
                              color: isPresent
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _students.isNotEmpty
                    ? const LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)])
                    : LinearGradient(
                        colors: [Colors.grey.shade800, Colors.grey.shade700]),
                boxShadow: _students.isNotEmpty
                    ? [
                        BoxShadow(
                            color:
                                const Color(0xFF1976D2).withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8))
                      ]
                    : [],
              ),
              child: ElevatedButton(
                onPressed: _students.isNotEmpty ? _saveAttendance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'حفظ الغياب',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
