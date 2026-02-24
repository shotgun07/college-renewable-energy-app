import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/app_user.dart';

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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.blue),
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey[600]),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateUsersReport() async {
    setState(() => _isGenerating = true);

    try {
      final usersSnap =
          await FirebaseFirestore.instance.collection('users').get();
      if (!context.mounted) return;
      final users = usersSnap.docs.map((doc) {
        return AppUser.fromMap(doc.id, doc.data());
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
      final coursesSnap =
          await FirebaseFirestore.instance.collection('courses').get();
      final lecturesSnap =
          await FirebaseFirestore.instance.collection('lectures').get();
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
      final attendanceSnap =
          await FirebaseFirestore.instance.collection('attendance').get();

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
      final announcementsSnap =
          await FirebaseFirestore.instance.collection('announcements').get();

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
