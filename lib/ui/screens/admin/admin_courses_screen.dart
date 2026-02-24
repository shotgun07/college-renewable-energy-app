import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/presentation/providers/course_provider.dart';
import 'package:app/ui/widgets/admin/admin_scaffold.dart';
import 'package:app/ui/widgets/common/glass_components.dart';
import 'package:app/domain/entities/course.dart';

class AdminCoursesScreen extends ConsumerStatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  ConsumerState<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends ConsumerState<AdminCoursesScreen> {
  final _nameController = TextEditingController();
  String? _selectedDept;
  String? _selectedSemester;

  final List<String> _departments = ['عام', 'ICT', 'طاقة', 'بيئة'];
  final List<String> _semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  void _showAddCourseDialog({Course? course}) {
    if (course != null) {
      _nameController.text = course.name;
      _selectedDept = course.department;
      _selectedSemester = course.semester.toString();
    } else {
      _nameController.clear();
      _selectedDept = null;
      _selectedSemester = null;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(course == null ? 'إضافة مادة' : 'تعديل مادة',
            style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassTextField(
                controller: _nameController,
                hint: 'اسم المادة',
                icon: Icons.book,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedDept,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'القسم',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                ),
                items: _departments
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => _selectedDept = v,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedSemester,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'الفصل',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                ),
                items: _semesters
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => _selectedSemester = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _selectedDept == null ||
                  _selectedSemester == null) {
                return;
              }

              final data = {
                'name': _nameController.text.trim(),
                'department': _selectedDept,
                'semester': int.parse(_selectedSemester!),
              };

              final repository = ref.read(courseRepositoryProvider);

              try {
                if (course == null) {
                  await repository.addCourse(data);
                } else {
                  await repository.updateCourse(course.id, data);
                }

                if (!context.mounted) return;
                Navigator.pop(context);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ: $e')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesStreamProvider);

    return AdminScaffold(
      title: 'إدارة المواد الدراسية',
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(
          child: Text('خطأ في جلب المواد: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text('لا توجد مواد مضافة بعد', style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return GlassTile(
                title: course.name,
                subtitle: '${course.department} - فصل ${course.semester}',
                icon: Icons.menu_book,
                color: Colors.blueAccent,
                onTap: () => _showAddCourseDialog(course: course),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    try {
                      await ref.read(courseRepositoryProvider).deleteCourse(course.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حذف المادة بنجاح')),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطأ: $e')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddCourseDialog(),
        ),
      ],
    );
  }
}
