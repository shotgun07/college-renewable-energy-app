import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';

class NotificationsScreen extends StatefulWidget {
  final AppUser user;

  const NotificationsScreen({super.key, required this.user});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _targetGroup = 'الكل';
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إرسال إشعار جديد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الإشعار',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bodyController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'محتوى الإشعار',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _targetGroup,
                      decoration: const InputDecoration(
                        labelText: 'المجموعة المستهدفة',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                        DropdownMenuItem(
                            value: 'student', child: Text('الطلاب')),
                        DropdownMenuItem(
                            value: 'teacher', child: Text('المعلمين')),
                        DropdownMenuItem(
                            value: 'admin', child: Text('الإداريين')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _targetGroup = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSending ? null : _sendNotification,
                        icon: _isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                            _isSending ? 'جاري الإرسال...' : 'إرسال الإشعار'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'الإشعارات المرسلة سابقاً',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .orderBy('createdAt', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد إشعارات'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final timestamp = data['createdAt'] as Timestamp?;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading:
                            const Icon(Icons.notifications, color: Colors.blue),
                        title: Text(data['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['body'] ?? ''),
                            const SizedBox(height: 4),
                            Text(
                              'المجموعة: ${_getGroupDisplayName(data['department'] ?? 'الكل')}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            if (timestamp != null)
                              Text(
                                'التاريخ: ${timestamp.toDate().toString().split('.')[0]}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNotification(doc.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة العنوان والمحتوى')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'department': _targetGroup,
        'semester': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _titleController.clear();
      _bodyController.clear();
      setState(() => _targetGroup = 'الكل');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الإشعار بنجاح')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الإرسال: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _deleteNotification(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('announcements')
                  .doc(id)
                  .delete();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الإشعار')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getGroupDisplayName(String group) {
    switch (group) {
      case 'student':
        return 'الطلاب';
      case 'teacher':
        return 'المعلمين';
      case 'admin':
        return 'الإداريين';
      default:
        return 'الكل';
    }
  }
}
