import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/chat_provider.dart';
import '../../../presentation/providers/admin_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import 'thread_chat_screen.dart';

class TeacherInbox extends ConsumerWidget {
  const TeacherInbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    if (user == null) {
      return const TeacherScaffold(
        title: 'محادثات الأستاذ',
        body: Center(
            child: Text('يجب تسجيل الدخول أولاً',
                style: TextStyle(color: Colors.white))),
      );
    }

    final uid = user.uid;
    final threadsAsync = ref.watch(myThreadsProvider(uid));

    return TeacherScaffold(
      title: 'محادثات الأستاذ',
      body: threadsAsync.when(
        data: (threads) {
          if (threads.isEmpty) {
            return const Center(
                child: Text('لا توجد محادثات',
                    style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: threads.length,
            itemBuilder: (context, i) {
              final thread = threads[i];
              final threadId = thread.id;
              final last = thread.lastMessage;
              final otherUid = thread.participants.firstWhere(
                (id) => id != uid,
                orElse: () => '',
              );

              final unread = thread.isUnread(uid);

              return FutureBuilder<String>(
                future: ref.read(adminRepositoryProvider).getUserName(otherUid),
                builder: (context, uSnap) {
                  final otherName = uSnap.data ?? '...';

                  return GlassTile(
                    title: otherName,
                    subtitle: last,
                    icon: Icons.person,
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ThreadChatScreen(
                              threadId: threadId, title: otherName),
                        ),
                      );
                    },
                    trailing: unread
                        ? Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle),
                          )
                        : null,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white)),
        error: (error, _) => Center(
          child: Text('خطأ: $error',
              style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
    );
  }
}
