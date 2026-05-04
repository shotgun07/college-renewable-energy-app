import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/chat_provider.dart';
import '../../../services/chat_service.dart';
import 'package:intl/intl.dart';
import '../../widgets/verification_banner_widget.dart';

class StudentAdminChat extends ConsumerStatefulWidget {
  const StudentAdminChat({super.key});

  @override
  ConsumerState<StudentAdminChat> createState() => _StudentAdminChatState();
}

class _StudentAdminChatState extends ConsumerState<StudentAdminChat> {
  final _text = TextEditingController();
  final _chat = ChatService(); // Still used for sending messages/logic for now

  String _uid = '';
  bool _ready = false;
  String _threadId = '';
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    _uid = user.uid;
    _threadId = (await _chat.adminThreadIdForStudent(_uid)) ?? 'admin_$_uid';

    final name = user.fullName.isEmpty ? 'طالب' : user.fullName;
    final dept = user.departmentName.isEmpty ? 'عام' : user.departmentName;
    final studentId = user.studentID.trim();
    final semester = user.semester;

    final adminUid = await _chat.adminUid();

    await _chat.ensureThread(
      threadId: _threadId,
      type: 'admin_user',
      participants: [_uid, adminUid],
      meta: {
        'studentUid': _uid,
        'studentName': name,
        'studentId': studentId,
        'departmentName': dept,
        'semester': semester,
      },
    );

    await _chat.markRead(threadId: _threadId, uid: _uid);

    if (mounted) setState(() => _ready = true);
  }

  Future<void> _send() async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    final msg = _text.text.trim();
    if (msg.isEmpty) return;

    final originalText = _text.text;
    _text.clear();

    try {
      await _chat.sendMessage(
        threadId: _threadId,
        text: msg,
        senderId: user.uid,
        senderRole: 'student',
      );

      await _chat.markRead(threadId: _threadId, uid: user.uid);
    } catch (e) {
      if (mounted) {
        _text.text = originalText; // Restore on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إرسال الرسالة: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _text.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const StudentScaffold(
        title: 'دعم الإدارة',
        isLoading: true,
        body: SizedBox(),
      );
    }

    final user = ref.watch(currentUserProvider);
    final messagesAsync = ref.watch(threadMessagesProvider(_threadId));

    // Auto-scroll on new messages
    ref.listen(threadMessagesProvider(_threadId), (prev, next) {
      if (next is AsyncData && next.value!.isNotEmpty) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });

    return StudentScaffold(
      title: 'دعم الإدارة',
      body: Column(
        children: [
          if (user != null) VerificationBannerWidget(userId: user.uid),
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.headset_mic,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.3)),
                        const SizedBox(height: 10),
                        Text('ابدأ التواصل مع الإدارة الآن',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5))),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final mine = msg.senderId == _uid;

                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: mine
                              ? const Color(0xFF1976D2)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft:
                                mine ? const Radius.circular(14) : Radius.zero,
                            bottomRight:
                                mine ? Radius.zero : const Radius.circular(14),
                          ),
                          border: Border.all(
                            color: mine
                                ? Colors.transparent
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.text,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('hh:mm a').format(msg.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: mine ? Colors.white70 : Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
              error: (error, _) => Center(
                child: Text('حدث خطأ: $error',
                    style: const TextStyle(color: Colors.redAccent)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _text,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                       hintText: 'اكتب رسالتك للإدارة...',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
