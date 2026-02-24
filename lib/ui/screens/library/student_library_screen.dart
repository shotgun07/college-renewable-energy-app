import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/lecture.dart';
import '../../../services/lecture_service.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../widgets/common/error_widgets.dart';

class StudentLibraryScreen extends StatelessWidget {
  final String department;
  final int semester;

  const StudentLibraryScreen({
    super.key,
    required this.department,
    required this.semester,
  });

  Future<void> _download(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = LectureService();

    return StudentScaffold(
      title: '????? ?????? - ??? $semester',
      body: StreamBuilder<List<Lecture>>(
        stream: service.getLecturesForStudent(department, semester),
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
              return NoInternetWidget(
                onRetry: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => StudentLibraryScreen(
                        department: department,
                        semester: semester,
                      ),
                    ),
                  );
                },
              );
            }

            return ServerErrorWidget(
              message: '?????? ??? ??? ????? ????? ???????',
              onRetry: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => StudentLibraryScreen(
                      department: department,
                      semester: semester,
                    ),
                  ),
                );
              },
            );
          }

          final lectures = snapshot.data ?? [];

          if (lectures.isEmpty) {
            return const EmptyStateWidget(
              title: '?? ???? ???????',
              message: '?? ??? ???????? ???? ?? ??????? ???? ????? ???',
              icon: Icons.library_books_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.white.withValues(alpha: 0.08),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.blue),
                  ),
                  title: Text(
                    lecture.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('??????: ${lecture.subject}',
                          style: const TextStyle(color: Colors.white70)),
                      Text('???????: ${lecture.teacherName}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded,
                        color: Colors.greenAccent),
                    onPressed: () => _download(lecture.downloadUrl),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
