import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/ui/widgets/student/student_scaffold.dart';
import 'package:app/ui/widgets/common/error_widgets.dart';
import 'package:app/domain/entities/course.dart';
import 'package:app/domain/entities/course_resource.dart';
import 'package:app/presentation/providers/course_provider.dart';

class StudentCoursesScreen extends ConsumerWidget {
  final String department;
  final int semester;

  const StudentCoursesScreen({
    super.key,
    required this.department,
    required this.semester,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesByDeptSemesterProvider(DeptSemesterParams(department, semester)));

    return StudentScaffold(
      title: 'موادي الدراسية',
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => NoInternetWidget(
            onRetry: () {
            ref.invalidate(coursesByDeptSemesterProvider(DeptSemesterParams(department, semester)));
          },
        ),
        data: (courses) {
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book,
                      size: 80, color: Colors.white.withValues(alpha: 0.1)),
                  const SizedBox(height: 10),
                  const Text('لا توجد مواد مسجلة لهذا الفصل',
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return _CourseCard(course: courses[index]);
            },
          );
        },
      ),
    );
  }
}

class _CourseCard extends ConsumerWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.blueAccent,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.class_, color: Colors.blueAccent),
        ),
        title: Text(
          course.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: [
          _ResourcesList(courseId: course.id),
        ],
      ),
    );
  }
}

class _ResourcesList extends ConsumerWidget {
  final String courseId;

  const _ResourcesList({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(courseResourcesProvider(courseId));

    return resourcesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(10),
        child: Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text('خطأ في جلب المحتوى: $e',
            style: const TextStyle(color: Colors.redAccent)),
      ),
      data: (resources) {
        if (resources.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Text('لم يتم إضافة محتوى بعد',
                style: TextStyle(color: Colors.white38, fontSize: 12)),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resources.length,
          separatorBuilder: (c, i) => const Divider(color: Colors.white10),
          itemBuilder: (context, index) {
            final res = resources[index];
            return ListTile(
              leading: Icon(
                _getIcon(res.type),
                color: _getColor(res.type),
                size: 20,
              ),
              title: Text(res.title,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              trailing: const Icon(Icons.download_rounded,
                  color: Colors.white54, size: 18),
              onTap: () => _launchUrl(res.url),
            );
          },
        );
      },
    );
  }

  IconData _getIcon(ResourceType type) {
    switch (type) {
      case ResourceType.pdf:
        return Icons.picture_as_pdf;
      case ResourceType.video:
        return Icons.play_circle_fill;
      case ResourceType.link:
        return Icons.link;
    }
  }

  Color _getColor(ResourceType type) {
    switch (type) {
      case ResourceType.pdf:
        return Colors.redAccent;
      case ResourceType.video:
        return Colors.orangeAccent;
      case ResourceType.link:
        return Colors.blueAccent;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
