import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../providers/user_provider.dart';
import '../../ui/widgets/custom_error_widget.dart';

class UsersManagementScreen extends ConsumerStatefulWidget {
  final AppUser user;

  const UsersManagementScreen({super.key, required this.user});

  @override
  ConsumerState<UsersManagementScreen> createState() =>
      _UsersManagementScreenState();
}

class _UsersManagementScreenState extends ConsumerState<UsersManagementScreen> {
  String _selectedRole = 'الكل';
  final List<String> _roles = [
    'الكل',
    'student',
    'teacher',
    'admin',
    'supervisor'
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(userProvider.notifier).loadNextPage(
          roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
    }
  }

  Future<void> _refresh() async {
    await ref.read(userProvider.notifier).fetchFirstPage(
        roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    final userStateAsync = ref.watch(userProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('فلترة حسب الدور:'),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child:
                        Text(role == 'الكل' ? role : _getRoleDisplayName(role)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                    ref.read(userProvider.notifier).fetchFirstPage(
                        roleFilter: value == 'الكل' ? null : value);
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: userStateAsync.when(
            data: (state) {
              if (state.users.isEmpty) {
                return const Center(child: Text('لا توجد مستخدمين'));
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final user = state.users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRoleColor(user.role),
                          child: Icon(
                            _getRoleIcon(user.role),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(user.fullName),
                        subtitle: Text(
                            '${user.email}\nالدور: ${_getRoleDisplayName(user.role.name)}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) => _handleUserAction(value, user),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('تعديل'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle_2fa',
                              child: Row(
                                children: [
                                  Icon(
                                    user.twoFactorEnabled
                                        ? Icons.lock_open
                                        : Icons.lock,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(user.twoFactorEnabled
                                      ? 'تعطيل 2FA'
                                      : 'تفعيل 2FA'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('حذف',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => CustomErrorWidget(
              message: 'فشل تحميل بيانات المستخدمين: $e',
              onRetry: _refresh,
            ),
          ),
        ),
      ],
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'student':
        return 'طالب';
      case 'teacher':
        return 'معلم';
      case 'admin':
        return 'مدير';
      case 'supervisor':
        return 'مشرف';
      default:
        return role;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.teacher:
        return Colors.green;
      case UserRole.admin:
        return Colors.red;
      case UserRole.supervisor:
        return Colors.orange;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school;
      case UserRole.teacher:
        return Icons.person;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.supervisor:
        return Icons.supervisor_account;
    }
  }

  void _handleUserAction(String action, AppUser user) {
    switch (action) {
      case 'edit':
        _editUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
      case 'toggle_2fa':
        _toggle2FA(user);
        break;
    }
  }

  void _editUser(AppUser user) {
    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phoneNumber);
    final studentIdCtrl = TextEditingController(text: user.studentID);
    String selectedRole = user.role.name;
    String selectedDept = user.departmentName;
    int selectedSemester = user.semester;

    final roles = ['student', 'teacher', 'supervisor', 'admin'];
    final depts = ['عام', 'بيئة', 'ICT', 'طاقة'];
    final semesters = List.generate(8, (i) => i + 1);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('تعديل: ${user.fullName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: studentIdCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الأكاديمي',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'الدور',
                    border: OutlineInputBorder(),
                  ),
                  items: roles
                      .map((r) => DropdownMenuItem(
                          value: r, child: Text(_getRoleDisplayName(r))))
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedRole = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue:
                      depts.contains(selectedDept) ? selectedDept : depts.first,
                  decoration: const InputDecoration(
                    labelText: 'القسم',
                    border: OutlineInputBorder(),
                  ),
                  items: depts
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedDept = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: semesters.contains(selectedSemester)
                      ? selectedSemester
                      : 1,
                  decoration: const InputDecoration(
                    labelText: 'الفصل الدراسي',
                    border: OutlineInputBorder(),
                  ),
                  items: semesters
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text('الفصل $s')))
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedSemester = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'fullName': nameCtrl.text.trim(),
                    'phoneNumber': phoneCtrl.text.trim(),
                    'studentID': studentIdCtrl.text.trim(),
                    'role': selectedRole,
                    'departmentName': selectedDept,
                    'semester': selectedSemester,
                  });
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('تم تحديث بيانات المستخدم بنجاح')),
                  );
                  ref.read(userProvider.notifier).fetchFirstPage(
                      roleFilter:
                          _selectedRole == 'الكل' ? null : _selectedRole);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ في التحديث: $e')),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${user.fullName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .delete();

              if (!context.mounted) return;

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المستخدم')),
              );
              // Refresh list
              ref.read(userProvider.notifier).fetchFirstPage(
                  roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggle2FA(AppUser user) async {
    final newValue = !user.twoFactorEnabled;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'twoFactorEnabled': newValue});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(newValue
                ? 'تم تفعيل المصادقة الثنائية'
                : 'تم تعطيل المصادقة الثنائية')),
      );
      ref.read(userProvider.notifier).fetchFirstPage(
          roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }
}
