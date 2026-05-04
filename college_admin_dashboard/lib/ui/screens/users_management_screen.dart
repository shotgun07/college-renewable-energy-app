import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../constants/app_enums.dart';
import '../../providers/user_provider.dart';
import '../../ui/widgets/custom_error_widget.dart';
import '../../services/department_service.dart';
import '../../widgets/glass_components.dart';
import '../widgets/student_migration_wizard.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator(color: Colors.white70)),
                      );
                    }

                    final user = state.users[index];
                    return GlassTile(
                      title: user.fullName,
                      subtitle: '${user.email}\nالدور: ${_getRoleDisplayName(user.role.name)}',
                      icon: _getRoleIcon(user.role),
                      color: _getRoleColor(user.role),
                      onTap: () => _handleUserAction('edit', user),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white70),
                        onSelected: (value) => _handleUserAction(value, user),
                        color: const Color(0xFF1E293B),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('تعديل', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'migrate',
                            child: Row(
                              children: [
                                Icon(Icons.swap_horiz, size: 18, color: Colors.purpleAccent),
                                SizedBox(width: 8),
                                Text('نقل القسم', style: TextStyle(color: Colors.white)),
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
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user.twoFactorEnabled
                                      ? 'تعطيل 2FA'
                                      : 'تفعيل 2FA',
                                  style: const TextStyle(color: Colors.white),
                                ),
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
      case 'migrate':
        _migrateUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
      case 'toggle_2fa':
        _toggle2FA(user);
        break;
    }
  }

  void _migrateUser(AppUser user) {
    if (user.role != UserRole.student) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نقل القسم متاح للطلاب فقط')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => StudentMigrationWizard(
        student: user,
        onSuccess: () {
          ref.read(userProvider.notifier).fetchFirstPage(
              roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
        },
      ),
    );
  }

  void _editUser(AppUser user) {
    showDialog(
      context: context,
      builder: (ctx) => EditUserDialog(
        user: user,
        onSuccess: () {
          ref.read(userProvider.notifier).fetchFirstPage(
              roleFilter: _selectedRole == 'الكل' ? null : _selectedRole);
        },
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

class EditUserDialog extends ConsumerStatefulWidget {
  final AppUser user;
  final VoidCallback onSuccess;

  const EditUserDialog({super.key, required this.user, required this.onSuccess});

  @override
  ConsumerState<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<EditUserDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _studentIdCtrl;
  
  late UserRole _selectedRole;
  late Department _selectedDept;
  late int _selectedSemester;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _phoneCtrl = TextEditingController(text: widget.user.phoneNumber);
    _studentIdCtrl = TextEditingController(text: widget.user.studentID);
    
    _selectedRole = widget.user.role;
    _selectedDept = widget.user.department;
    _selectedSemester = widget.user.semester;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
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

  Future<void> _saveChanges() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
        'fullName': _nameCtrl.text.trim(),
        'phoneNumber': _phoneCtrl.text.trim(),
        'studentID': _studentIdCtrl.text.trim(),
        'role': _selectedRole.name,
        'departmentName': _selectedDept.displayName,
        'semester': _selectedSemester,
      });

      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث بيانات المستخدم بنجاح')),
      );
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في التحديث: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = UserRole.values;
    final depts = Department.values;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      title: Text('تعديل: ${widget.user.fullName}', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassTextField(
              controller: _nameCtrl,
              hint: 'الاسم الكامل',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            GlassTextField(
              controller: _phoneCtrl,
              hint: 'رقم الهاتف',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            GlassTextField(
              controller: _studentIdCtrl,
              hint: 'الرقم الأكاديمي',
              icon: Icons.badge,
            ),
            const SizedBox(height: 12),
            GlassDropdown<UserRole>(
              items: roles,
              value: _selectedRole,
              hint: 'الدور',
              itemLabel: (r) => _getRoleDisplayName(r.name),
              onChanged: (v) => setState(() => _selectedRole = v!),
            ),
            const SizedBox(height: 12),
            GlassDropdown<Department>(
              items: depts,
              value: _selectedDept,
              hint: 'القسم',
              itemLabel: (d) => d.displayName,
              onChanged: (v) {
                setState(() {
                  _selectedDept = v!;
                  final validSems = DepartmentService.getSemestersForDepartment(v);
                  if (!validSems.contains(_selectedSemester)) {
                    _selectedSemester = validSems.first;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            GlassDropdown<int>(
              items: DepartmentService.getSemestersForDepartment(_selectedDept),
              value: DepartmentService.getSemestersForDepartment(_selectedDept).contains(_selectedSemester) 
                  ? _selectedSemester 
                  : DepartmentService.getSemestersForDepartment(_selectedDept).first,
              hint: 'الفصل الدراسي',
              itemLabel: (s) => 'الفصل $s',
              onChanged: (v) => setState(() => _selectedSemester = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveChanges,
          child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('حفظ'),
        ),
      ],
    );
  }
}
