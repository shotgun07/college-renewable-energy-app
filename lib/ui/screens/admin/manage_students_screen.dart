import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/admin_provider.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/admin/admin_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import 'package:app/domain/entities/user.dart';

class ManageStudentsScreen extends ConsumerStatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  ConsumerState<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends ConsumerState<ManageStudentsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsStreamProvider);

    return AdminScaffold(
      title: "إدارة بيانات الطلاب",
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: GlassTextField(
              controller: _searchController,
              hint: "بحث بالاسم أو رقم الهاتف...",
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: studentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (err, stack) => Center(
                child: Text('خطأ في جلب الطلاب: \$err', style: const TextStyle(color: Colors.white)),
              ),
              data: (students) {
                var filteredStudents = students;
                
                if (_searchQuery.isNotEmpty) {
                  filteredStudents = students.where((student) {
                    final name = student.fullName.toLowerCase();
                    final phone = student.phoneNumber;
                    return name.contains(_searchQuery.toLowerCase()) ||
                        phone.contains(_searchQuery);
                  }).toList();
                }

                if (filteredStudents.isEmpty) {
                  return const Center(
                    child: Text("لا يوجد طلاب مطابقين للبحث",
                        style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return _buildStudentTile(student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(User student) {
    final name = student.fullName;
    final phone = student.phoneNumber;
    final studentId = student.studentID;
    final docId = student.uid;

    return GlassTile(
      title: name,
      subtitle: "هاتف: $phone\nرقم القيد: ${studentId.isEmpty ? 'غير محدد' : studentId}",
      icon: Icons.person,
      color: Colors.blueAccent,
      onTap: () => _showEditDialog(docId, name, studentId),
      trailing: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
    );
  }

  void _showEditDialog(String docId, String name, String currentId) {
    final controller = TextEditingController(text: currentId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("تعديل رقم القيد لـ \$name",
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "رقم القيد",
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newId = controller.text.trim();
              await _updateStudentId(docId, name, newId);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStudentId(String docId, String name, String newId) async {
    try {
      final adminUid = ref.read(authProvider).value?.uid ?? 'unknown_admin';

      await ref.read(adminRepositoryProvider).updateStudentID(docId, name, newId, adminUid);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحديث رقم القيد بنجاح")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ: \$e")),
      );
    }
  }
}
