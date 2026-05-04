import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../constants/app_enums.dart';
import '../../services/department_service.dart';
import '../../widgets/glass_components.dart';

class StudentMigrationWizard extends ConsumerStatefulWidget {
  final AppUser student;
  final VoidCallback onSuccess;

  const StudentMigrationWizard(
      {super.key, required this.student, required this.onSuccess});

  @override
  ConsumerState<StudentMigrationWizard> createState() =>
      _StudentMigrationWizardState();
}

class _StudentMigrationWizardState
    extends ConsumerState<StudentMigrationWizard> {
  late Department _selectedDept;
  late int _selectedSemester;
  bool _isMigrating = false;

  @override
  void initState() {
    super.initState();
    _selectedDept = widget.student.department;
    _selectedSemester = widget.student.semester;
  }

  void _onDepartmentChanged(Department? newDept) {
    if (newDept == null) return;
    setState(() {
      _selectedDept = newDept;
      final validSemesters =
          DepartmentService.getSemestersForDepartment(newDept);
      if (!validSemesters.contains(_selectedSemester)) {
        _selectedSemester = validSemesters.first;
      }
    });
  }

  Future<void> _performMigration() async {
    setState(() => _isMigrating = true);

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final studentRef = db.collection('users').doc(widget.student.uid);
      batch.update(studentRef, {
        'departmentName': _selectedDept.displayName,
        'semester': _selectedSemester,
      });

      final auditRef = db.collection('audit_logs').doc();
      batch.set(auditRef, {
        'action': 'student_migration',
        'studentUid': widget.student.uid,
        'oldDepartment': widget.student.department.displayName,
        'oldSemester': widget.student.semester,
        'newDepartment': _selectedDept.displayName,
        'newSemester': _selectedSemester,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نقل الطالب بنجاح!')),
      );
      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth error $e')),
      );
    } finally {
      if (mounted) setState(() => _isMigrating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final depts = Department.values;
    final validSemesters =
        DepartmentService.getSemestersForDepartment(_selectedDept);

    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      title: Text('نقل الطالب: ${widget.student.fullName}',
          style: const TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('القسم الجديد:', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            GlassDropdown<Department>(
              items: depts,
              value: _selectedDept,
              hint: 'القسم',
              itemLabel: (d) => d.displayName,
              onChanged: _onDepartmentChanged,
            ),
            const SizedBox(height: 16),
            const Text('الفصل الدراسي الجديد:',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            GlassDropdown<int>(
              items: validSemesters,
              value: _selectedSemester,
              hint: 'الفصل الدراسي',
              itemLabel: (s) => 'الفصل $s',
              onChanged: (v) => setState(() => _selectedSemester = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isMigrating ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isMigrating ? null : _performMigration,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          child: _isMigrating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('تنفيذ النقل',
                  style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
