import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/student/student_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import 'thread_chat_screen.dart';
import '../../../services/chat_service.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/admin_provider.dart';

class SelectTeacherScreen extends ConsumerWidget {
  final String departmentName;
  final int semester;

  const SelectTeacherScreen({
    super.key,
    required this.departmentName,
    required this.semester,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final key = '$departmentName-$semester';
    final teachersAsync = ref.watch(teachersByKeyProvider(key));

    return StudentScaffold(
      title: '???? ???????',
      body: teachersAsync.when(
        data: (teachers) {
          if (teachers.isEmpty) {
            return const Center(
              child: Text(
                '?? ???? ?????? ?????? ?????? ???? ????? ??????',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final t = teachers[index];
              return GlassTile(
                title: t.fullName,
                subtitle: '????? ?????? ?? ???????',
                icon: Icons.person,
                color: Colors.tealAccent,
                onTap: () async {
                  if (user == null) return;
                  final chat = ChatService();
                  final threadId = await chat.getOrCreateDirectThread(
                    t.uid,
                    'teacher',
                    meta: {
                      'studentName': user.fullName,
                      'teacherName': t.fullName,
                      'department': departmentName,
                      'semester': semester,
                    },
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ThreadChatScreen(
                          threadId: threadId,
                          title: t.fullName,
                        ),
                      ),
                    );
                  }
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
    );
  }
}
