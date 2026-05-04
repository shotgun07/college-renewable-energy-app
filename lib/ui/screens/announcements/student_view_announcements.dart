import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../domain/entities/announcement.dart';
import '../../../presentation/providers/announcement_provider.dart';

class StudentViewAnnouncements extends ConsumerStatefulWidget {
  const StudentViewAnnouncements({super.key});

  @override
  ConsumerState<StudentViewAnnouncements> createState() => _StudentViewAnnouncementsState();
}

class _StudentViewAnnouncementsState extends ConsumerState<StudentViewAnnouncements> {
  final _scrollController = ScrollController();
  final List<dynamic> _olderAnnouncements = [];
  bool _isLoadingOlder = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadOlderAnnouncements();
    }
  }

  Future<void> _loadOlderAnnouncements() async {
    if (_isLoadingOlder || !_hasMore) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    DateTime? oldestDate;
    if (_olderAnnouncements.isNotEmpty) {
      oldestDate = _olderAnnouncements.last.createdAt;
    } else {
      final currentStream = ref.read(announcementsProvider(user.departmentName, user.semester));
      if (currentStream.value != null && currentStream.value!.isNotEmpty) {
        oldestDate = currentStream.value!.last.createdAt;
      }
    }

    if (oldestDate == null) return;

    setState(() => _isLoadingOlder = true);

    try {
      final olderChunk = await ref.read(announcementRepositoryProvider)
          .getAnnouncements(user.departmentName, user.semester, limit: 20, startAfter: oldestDate).first;
      
      if (olderChunk.isEmpty || olderChunk.length < 20) {
        _hasMore = false;
      }
      
      if (mounted) {
        setState(() {
          final existingIds = _olderAnnouncements.map((a) => a.id).toSet();
          final currentStreamIds = ref.read(announcementsProvider(user.departmentName, user.semester)).value?.map((a) => a.id).toSet() ?? {};
          
          for (var a in olderChunk) {
            if (!existingIds.contains(a.id) && !currentStreamIds.contains(a.id)) {
              _olderAnnouncements.add(a);
            }
          }
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingOlder = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    // Handle user loading/null state
    if (userAsync == null) {
      return const StudentScaffold(
        title: 'الإعلانات الرسمية',
        isLoading: true,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final announcementsAsync = ref.watch(
      announcementsProvider(userAsync.departmentName, userAsync.semester),
    );

    return StudentScaffold(
      title: 'الإعلانات الرسمية',
      isLoading: false,
      body: announcementsAsync.when(
        data: (announcements) {
          if (announcements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined,
                      size: 60, color: Colors.white.withValues(alpha: 0.2)),
                  const SizedBox(height: 15),
                  Text(
                    "لا توجد إعلانات حالياً",
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: announcements.length + _olderAnnouncements.length + (_isLoadingOlder ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == announcements.length + _olderAnnouncements.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                );
              }

              final Announcement announcement;
              if (index < announcements.length) {
                announcement = announcements[index];
              } else {
                announcement = _olderAnnouncements[index - announcements.length];
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.campaign, color: Colors.orange),
                    ),
                    title: Text(
                      announcement.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("صادر من: ${announcement.department}",
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(announcement.createdAt),
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white70,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                        ),
                        child: Text(
                          announcement.body,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => Center(
          child:
              Text("حدث خطأ: $e", style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year  $hour:$min';
  }
}
