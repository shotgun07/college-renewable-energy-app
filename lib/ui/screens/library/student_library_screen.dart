import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/lecture.dart';
import '../../../services/lecture_service.dart';
import '../../widgets/student/student_scaffold.dart';
import 'package:flutter/foundation.dart';
import '../../widgets/common/error_widgets.dart';

class StudentLibraryScreen extends StatefulWidget {
  final String department;
  final int semester;

  const StudentLibraryScreen({
    super.key,
    required this.department,
    required this.semester,
  });

  @override
  State<StudentLibraryScreen> createState() => _StudentLibraryScreenState();
}

class _StudentLibraryScreenState extends State<StudentLibraryScreen> {
  late final LectureService _service;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _service = LectureService();
  }

  Future<void> _download(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (kDebugMode) debugPrint('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر فتح الملف، يرجى المحاولة مجدداً')),
        );
      }
    }
  }

  void _retry() => setState(() => _refreshKey++);

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'مكتبة المحاضرات - الفصل ${widget.semester}',
      body: StreamBuilder<List<Lecture>>(
        key: ValueKey(_refreshKey),
        stream: _service.getLecturesForStudent(widget.department, widget.semester),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            final isNetworkError = errorMessage.contains('network') ||
                errorMessage.contains('internet') ||
                errorMessage.contains('connection');

            if (isNetworkError) {
              return NoInternetWidget(onRetry: _retry);
            }
            return ServerErrorWidget(
              message: 'خطأ في تحميل المحاضرات، حاول مرة أخرى',
              onRetry: _retry,
            );
          }

          final lectures = snapshot.data ?? [];

          if (lectures.isEmpty) {
            return const EmptyStateWidget(
              title: 'لا توجد محاضرات',
              message: 'لم يقم الأساتذة برفع محاضرات لهذا الفصل حتى الآن',
              icon: Icons.library_books_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];
              return _LectureCard(
                lecture: lecture,
                onDownload: () => _download(lecture.downloadUrl),
              );
            },
          );
        },
      ),
    );
  }
}

class _LectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onDownload;

  const _LectureCard({required this.lecture, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
        ),
        title: Text(
          lecture.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book, size: 13, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text('المادة: ${lecture.subject}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 13, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text('الأستاذ: ${lecture.teacherName}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        trailing: InkWell(
          onTap: onDownload,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.download_rounded,
                color: Colors.greenAccent, size: 22),
          ),
        ),
      ),
    );
  }
}
