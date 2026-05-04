import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/app_user.dart';
import '../../constants/app_enums.dart';
import '../../widgets/glass_components.dart';

class ReportsScreen extends StatefulWidget {
  final AppUser user;

  const ReportsScreen({super.key, required this.user});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقارير متاحة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildReportCard(
            title: 'تقرير المستخدمين',
            description: 'إحصائيات شاملة عن جميع المستخدمين',
            icon: Icons.people,
            onGenerate: _generateUsersReport,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            title: 'تقرير المواد الدراسية',
            description: 'إحصائيات المواد والمحاضرات',
            icon: Icons.menu_book,
            onGenerate: _generateCoursesReport,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            title: 'تقرير الحضور',
            description: 'إحصائيات الحضور والغياب',
            icon: Icons.check_circle,
            onGenerate: _generateAttendanceReport,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            title: 'تقرير الإعلانات',
            description: 'إحصائيات الإعلانات والإشعارات',
            icon: Icons.announcement,
            onGenerate: _generateAnnouncementsReport,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onGenerate,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.blueAccent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : onGenerate,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label:
                  Text(_isGenerating ? 'جاري الإنشاء...' : 'إنشاء تقرير PDF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateUsersReport() async {
    setState(() => _isGenerating = true);

    try {
      Query query = FirebaseFirestore.instance.collection('users');
      if (widget.user.role == UserRole.supervisor) {
        query = query.where('departmentName', isEqualTo: widget.user.department.displayName);
      }
      final usersSnap = await query.get();
      if (!context.mounted) return;
      final users = usersSnap.docs.map((doc) {
        return AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>?);
      }).toList();

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير المستخدمين',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('إجمالي المستخدمين: ${users.length}'),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['الاسم', 'البريد الإلكتروني', 'الدور'],
                  data: users
                      .map((user) => [
                            user.fullName,
                            user.email,
                            _getRoleDisplayName(user.role.name),
                          ])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إنشاء التقرير: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateCoursesReport() async {
    setState(() => _isGenerating = true);

    try {
      Query coursesQuery = FirebaseFirestore.instance.collection('courses');
      Query lecturesQuery = FirebaseFirestore.instance.collection('lectures');
      
      if (widget.user.role == UserRole.supervisor) {
        coursesQuery = coursesQuery.where('departmentName', isEqualTo: widget.user.department.displayName);
        lecturesQuery = lecturesQuery.where('departmentName', isEqualTo: widget.user.department.displayName);
      }

      final coursesSnap = await coursesQuery.get();
      final lecturesSnap = await lecturesQuery.get();
      if (!context.mounted) return;

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير المواد الدراسية',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('إجمالي المواد: ${coursesSnap.docs.length}'),
                pw.Text('إجمالي المحاضرات: ${lecturesSnap.docs.length}'),
                pw.SizedBox(height: 10),
                pw.Text('قائمة المواد:'),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['اسم المادة', 'الوصف'],
                  data: coursesSnap.docs
                      .map((doc) => [
                            doc['name'] ?? '',
                            doc['description'] ?? '',
                          ])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إنشاء التقرير: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateAttendanceReport() async {
    setState(() => _isGenerating = true);

    try {
      Query attendanceQuery = FirebaseFirestore.instance.collection('attendance');
      if (widget.user.role == UserRole.supervisor) {
        attendanceQuery = attendanceQuery.where('departmentName', isEqualTo: widget.user.department.displayName);
      }
      final attendanceSnap = await attendanceQuery.get();

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير الحضور',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('إجمالي سجلات الحضور: ${attendanceSnap.docs.length}'),
                pw.SizedBox(height: 10),
                pw.Text('تفاصيل الحضور:'),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['التاريخ', 'المادة', 'الحاضرون', 'الغائبون'],
                  data: attendanceSnap.docs
                      .map((doc) => [
                            doc['date'] ?? '',
                            doc['courseName'] ?? '',
                            (doc['present'] as List<dynamic>?)
                                    ?.length
                                    .toString() ??
                                '0',
                            (doc['absent'] as List<dynamic>?)
                                    ?.length
                                    .toString() ??
                                '0',
                          ])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إنشاء التقرير: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateAnnouncementsReport() async {
    setState(() => _isGenerating = true);

    try {
      Query announcementsQuery = FirebaseFirestore.instance.collection('announcements');
      if (widget.user.role == UserRole.supervisor) {
        announcementsQuery = announcementsQuery.where('departmentName', isEqualTo: widget.user.department.displayName);
      }
      final announcementsSnap = await announcementsQuery.get();

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير الإعلانات',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('إجمالي الإعلانات: ${announcementsSnap.docs.length}'),
                pw.SizedBox(height: 10),
                pw.Text('قائمة الإعلانات:'),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['العنوان', 'المحتوى', 'التاريخ'],
                  data: announcementsSnap.docs
                      .map((doc) => [
                            doc['title'] ?? '',
                            doc['body'] ?? '',
                            (doc['createdAt'] as Timestamp?)
                                    ?.toDate()
                                    .toString() ??
                                '',
                          ])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إنشاء التقرير: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
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
}
