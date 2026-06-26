import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/chat_provider.dart';
import '../../../domain/entities/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'video_call_screen.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../widgets/audio_message_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ThreadChatScreen extends ConsumerStatefulWidget {
  final String threadId;
  final String title;
  const ThreadChatScreen(
      {super.key, required this.threadId, required this.title});

  @override
  ConsumerState<ThreadChatScreen> createState() => _ThreadChatScreenState();
}

class _ThreadChatScreenState extends ConsumerState<ThreadChatScreen> {
  final _c = TextEditingController();
  final _picker = ImagePicker();
  final _audioRecorder = AudioRecorder();
  final _scrollController = ScrollController();
  final List<Message> _olderMessages = [];
  bool _isLoadingOlder = false;
  bool _hasMore = true;

  bool _isTeacher = false;
  bool _isUploading = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        // Mark as read
        ref
            .read(chatRepositoryProvider)
            .markThreadAsRead(widget.threadId, user.uid);
        _checkRole(user.role.name); // Convert enum to String
      }
    });
  }

  void _checkRole(String role) {
    setState(() {
      _isTeacher = role == 'teacher' || role == 'admin' || role == 'supervisor';
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadOlderMessages();
    }
  }

  Future<void> _loadOlderMessages() async {
    if (_isLoadingOlder || !_hasMore) return;

    DateTime? oldestDate;
    if (_olderMessages.isNotEmpty) {
      oldestDate = _olderMessages.last.createdAt;
    } else {
      final currentStream = ref.read(threadMessagesProvider(widget.threadId));
      if (currentStream.value != null && currentStream.value!.isNotEmpty) {
        oldestDate = currentStream.value!.last.createdAt;
      }
    }

    if (oldestDate == null) return;

    setState(() => _isLoadingOlder = true);

    try {
      final olderChunk = await ref.read(chatRepositoryProvider)
          .getMessages(widget.threadId, limit: 20, startAfter: oldestDate).first;
      
      if (olderChunk.isEmpty || olderChunk.length < 20) {
        _hasMore = false;
      }
      
      if (mounted) {
        setState(() {
          final existingIds = _olderMessages.map((m) => m.id).toSet();
          final currentStreamIds = ref.read(threadMessagesProvider(widget.threadId)).value?.map((m) => m.id).toSet() ?? {};
          
          for (var m in olderChunk) {
            if (!existingIds.contains(m.id) && !currentStreamIds.contains(m.id)) {
              _olderMessages.add(m);
            }
          }
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingOlder = false);
    }
  }

  Future<void> _send() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final t = _c.text.trim();
    if (t.isEmpty) return;

    final originalText = _c.text;
    _c.clear();

    try {
      final message = Message(
        id: '',
        senderId: user.uid,
        senderRole: user.role.name,
        text: t,
        createdAt: DateTime.now(),
      );

      await ref.read(sendMessageUseCaseProvider).call(widget.threadId, message);
      await ref
          .read(chatRepositoryProvider)
          .markThreadAsRead(widget.threadId, user.uid);
    } catch (e) {
      if (mounted) {
        _c.text = originalText; // Restore text on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إرسال الرسالة: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final file = File(pickedFile.path);
      final refPath = 'chats/${widget.threadId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(refPath);
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      final message = Message(
        id: '',
        senderId: user.uid,
        senderRole: user.role.name,
        text: '🖼️ صورة',
        type: 'image',
        fileUrl: downloadUrl,
        createdAt: DateTime.now(),
      );

      await ref.read(sendMessageUseCaseProvider).call(widget.threadId, message);
      await ref.read(chatRepositoryProvider).markThreadAsRead(widget.threadId, user.uid);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في رفع الصورة: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickFile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.isEmpty) return;
    
    setState(() => _isUploading = true);

    try {
      final file = File(result.files.single.path!);
      final refPath = 'chats/${widget.threadId}/${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
      final storageRef = FirebaseStorage.instance.ref().child(refPath);
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      final message = Message(
        id: '',
        senderId: user.uid,
        senderRole: user.role.name,
        text: result.files.single.name,
        type: 'pdf',
        fileUrl: downloadUrl,
        createdAt: DateTime.now(),
      );

      await ref.read(sendMessageUseCaseProvider).call(widget.threadId, message);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في رفع الملف: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() => _isRecording = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في بدء التسجيل: $e')),
        );
      }
    }
  }

  Future<void> _stopRecordingAndSend() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);

      if (path != null) {
        setState(() => _isUploading = true);
        
        final user = ref.read(currentUserProvider);
        if (user == null) return;

        final file = File(path);
        final refPath = 'chats/${widget.threadId}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        final storageRef = FirebaseStorage.instance.ref().child(refPath);
        final uploadTask = await storageRef.putFile(file);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        final message = Message(
          id: '',
          senderId: user.uid,
          senderRole: user.role.name,
          text: '🎤 رسالة صوتية',
          type: 'audio',
          fileUrl: downloadUrl,
          createdAt: DateTime.now(),
        );

        await ref.read(sendMessageUseCaseProvider).call(widget.threadId, message);
        await ref.read(chatRepositoryProvider).markThreadAsRead(widget.threadId, user.uid);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في إرسال التسجيل: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _c.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final messagesAsync = ref.watch(threadMessagesProvider(widget.threadId));

    // Auto-scroll on new messages
    ref.listen(threadMessagesProvider(widget.threadId), (prev, next) {
      if (next is AsyncData && next.value!.isNotEmpty) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0, // Since it's reversed, 0 is the bottom
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });

    return StudentScaffold(
      title: widget.title,
      actions: [
        if (_isTeacher)
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VideoCallScreen(otherName: widget.title),
                ),
              );
            },
          ),
      ],
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                      child: Text('ابدأ المحادثة بإرسال رسالة',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5))));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length + _olderMessages.length + (_isLoadingOlder ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == messages.length + _olderMessages.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }

                    final Message msg;
                    if (i < messages.length) {
                      msg = messages[i];
                    } else {
                      msg = _olderMessages[i - messages.length];
                    }

                    final mine = msg.senderId == user.uid;

                    // Mark as read if it's from someone else and unread
                    if (!mine && !msg.isRead && msg.id.isNotEmpty) {
                      Future.microtask(() => ref.read(chatRepositoryProvider).markMessageAsRead(widget.threadId, msg.id));
                    }

                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                        child: msg.type == 'image' && msg.fileUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: msg.fileUrl!,
                                  width: 200,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, color: Colors.red),
                                ),
                              )
                            : msg.type == 'audio' && msg.fileUrl != null
                                ? AudioMessagePlayer(
                                    audioUrl: msg.fileUrl!, isMe: mine)
                                : msg.type == 'pdf' && msg.fileUrl != null
                                  ? InkWell(
                                      onTap: () async {
                                        final uri = Uri.parse(msg.fileUrl!);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                                          const SizedBox(width: 8),
                                          Flexible(child: Text(msg.text, style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline))),
                                        ],
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  msg.text,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: mine ? Colors.white : Colors.white),
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
                                        if (mine) ...[
                                          const SizedBox(width: 5),
                                          Icon(
                                            msg.isRead ? Icons.done_all : Icons.done,
                                            size: 14,
                                            color: msg.isRead ? Colors.blue[300] : Colors.white60,
                                          ),
                                        ],
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
                child: Text('خطأ: $error',
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
                    controller: _c,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
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
                const SizedBox(width: 8),
                if (_isRecording)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('جاري التسجيل...', style: TextStyle(color: Colors.redAccent)),
                  ),
                if (!_isRecording) ...[
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.white70),
                    onPressed: _isUploading ? null : _pickFile,
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_camera, color: Colors.white70),
                    onPressed: _isUploading ? null : _pickImage,
                  ),
                ],
                const SizedBox(width: 8),
                GestureDetector(
                  onLongPress: _isUploading ? null : _startRecording,
                  onLongPressUp: _isUploading ? null : _stopRecordingAndSend,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : const Color(0xFF1976D2),
                      shape: BoxShape.circle,
                    ),
                    child: _isRecording
                        ? const Icon(Icons.mic, color: Colors.white)
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
