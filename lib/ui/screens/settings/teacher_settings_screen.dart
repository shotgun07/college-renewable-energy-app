import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';

class TeacherSettingsScreen extends ConsumerStatefulWidget {
  const TeacherSettingsScreen({super.key});

  @override
  ConsumerState<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends ConsumerState<TeacherSettingsScreen> {
  final List<String> _departments = ['عام', 'ICT', 'طاقة', 'بيئة'];
  final Map<String, bool> _selectedDepts = {};

  final Map<String, Map<String, bool>> _deptSemesters = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Delay slightly to ensure provider is fully initialized if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    final user = ref.read(authProvider).value;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final keys = List<String>.from(user.teachingKeys);

      for (var key in keys) {
        final parts = key.split('_');
        if (parts.length == 2) {
          final dept = parts[0];
          final sem = parts[1];

          _selectedDepts[dept] = true;
          if (!_deptSemesters.containsKey(dept)) {
            _deptSemesters[dept] = {};
          }
          _deptSemesters[dept]![sem] = true;
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    
    final user = ref.read(authProvider).value;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final newKeys = <String>[];

    _deptSemesters.forEach((dept, semesters) {
      if (_selectedDepts[dept] == true) {
        semesters.forEach((sem, isSelected) {
          if (isSelected) {
            newKeys.add('${dept}_$sem');
          }
        });
      }
    });

    try {
      await ref.read(authProvider.notifier).updateProfile(user.uid, {
        'teachingKeys': newKeys,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<String> _getSemestersFor(String dept) {
    if (dept == 'عام') return ['1', '2'];
    // For other departments, returns semesters 3 to 8
    return ['3', '4', '5', '6', '7', '8'];
  }

  @override
  Widget build(BuildContext context) {
    return TeacherScaffold(
      title: 'إعدادات المواد الدراسية',
      isLoading: _isLoading,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حدد الأقسام والفصول التي تدرسها:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'سيظهر اسمك للطلاب في هذه الفصول فقط لبدء المحادثات.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ..._departments.map((dept) => _buildDeptSection(dept)),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF1976D2).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('حفظ التغييرات',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeptSection(String dept) {
    final isSelected = _selectedDepts[dept] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isSelected
                ? Colors.blueAccent
                : Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          SwitchListTile(
            activeTrackColor: Colors.blueAccent,
            title: Text(dept,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(
                dept == 'عام' ? 'مواد عامة (فصل 1، 2)' : 'مواد تخصصية',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
            value: isSelected,
            onChanged: (val) {
              setState(() {
                _selectedDepts[dept] = val;
                if (val && !_deptSemesters.containsKey(dept)) {
                  _deptSemesters[dept] = {};
                }
              });
            },
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _getSemestersFor(dept).map((sem) {
                  final semMap = _deptSemesters[dept] ?? {};
                  final checked = semMap[sem] ?? false;
                  return FilterChip(
                    label: Text('فصل $sem'),
                    selected: checked,
                    onSelected: (s) {
                      setState(() {
                        if (!_deptSemesters.containsKey(dept)) {
                          _deptSemesters[dept] = {};
                        }
                        _deptSemesters[dept]![sem] = s;
                      });
                    },
                    checkmarkColor: Colors.white,
                    selectedColor: Colors.blueAccent.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                        color: checked ? Colors.white : Colors.white70),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: checked ? Colors.blueAccent : Colors.white24),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
