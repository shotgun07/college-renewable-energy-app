import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../widgets/student/glass_tile.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/chat_provider.dart';
import '../../../presentation/providers/admin_provider.dart';
import 'select_teacher_screen.dart';
import 'thread_chat_screen.dart';
import 'student_admin_chat.dart';

class StudentChatHub extends ConsumerWidget {
  final String departmentName;
  final int semester;

  const StudentChatHub(
      {super.key, required this.departmentName, required this.semester});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    if (userAsync == null) {
      return const StudentScaffold(
        title: "???? ???????",
        body: Center(
            child: Text('??? ????? ?????? ?????',
                style: TextStyle(color: Colors.white))),
      );
    }

    final uid = userAsync.uid;
    final dept = departmentName;
    final sem = semester;

    // Watch unread count
    final unreadAsync = ref.watch(unreadCountProvider(uid));

    // Watch threads
    final threadsAsync = ref.watch(myThreadsProvider(uid));

    return StudentScaffold(
      title: '???? ???????',
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.chat_bubble_outline, color: Colors.white),
              unreadAsync.when(
                data: (unreadCount) {
                  if (unreadCount > 0) {
                    return Positioned(
                      top: 6,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4)
                          ],
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassTile(
              title: '?????? ?? ???????',
              icon: Icons.admin_panel_settings,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StudentAdminChat()));
              },
            ),
            GlassTile(
              title: '??? ?????? ?? ?????',
              subtitle: '??? ?????: $dept | ?????: $sem',
              icon: Icons.school,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectTeacherScreen(
                        departmentName: dept, semester: sem),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(Icons.history, color: Colors.white70),
                const SizedBox(width: 8),
                Text('????????? ???????',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            threadsAsync.when(
              data: (threads) {
                if (threads.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text('?? ???? ??????? ?????',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5))),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: threads.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final thread = threads[i];
                    final otherUid = thread.participants.firstWhere(
                      (id) => id != uid,
                      orElse: () => '',
                    );

                    return FutureBuilder<String>(
                      future: _resolveTitle(ref, thread.type, otherUid),
                      builder: (context, titleSnap) {
                        final title = titleSnap.data ?? '...';
                        return GlassTile(
                          title: title,
                          subtitle: thread.lastMessage,
                          icon: thread.type == 'admin_user'
                              ? Icons.security
                              : Icons.person,
                          color: thread.type == 'admin_user'
                              ? Colors.redAccent
                              : Colors.tealAccent,
                          trailing: thread.isUnread(uid)
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ThreadChatScreen(
                                    threadId: thread.id, title: title),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
              error: (error, _) => Center(
                child: Text('???: $error',
                    style: const TextStyle(color: Colors.redAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _resolveTitle(
      WidgetRef ref, String type, String otherUid) async {
    if (type == 'admin_user') return '???????';
    if (otherUid.isEmpty) return '??????';
    // Use AdminRepository via provider instead of direct Firestore call
    return ref.read(adminRepositoryProvider).getUserName(otherUid);
  }
}
