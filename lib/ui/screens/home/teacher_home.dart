import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../../services/chat_service.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import '../../widgets/verification_banner_widget.dart';
import '../chat/teacher_inbox.dart';
import '../lectures/teacher_upload_screen.dart';
import '../attendance/attendance_screen.dart';
import '../schedules/teacher_schedule_screen.dart';
import '../stats/teacher_stats_screen.dart';
import '../settings/teacher_settings_screen.dart';
import '../profile/teacher_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherHome extends ConsumerWidget {
  const TeacherHome({super.key});

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TeacherInbox()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;

    return authState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(child: Text("خطأ: \$e", style: const TextStyle(color: Colors.white))),
      ),
      data: (user) {
        return TeacherScaffold(
          title: 'بوابة الأستاذ',
          actions: [
            if (firebaseUser != null)
              _TeacherChatBadgeIcon(
                uid: firebaseUser.uid,
                onTap: () => _openChat(context),
              ),
          ],
          drawer: _buildPremiumDrawer(context, user, ref),
          body: Column(
            children: [
              // Verification banner for unverified teachers
              if (firebaseUser != null)
                VerificationBannerWidget(
                  userId: firebaseUser.uid,
                ),
              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWelcomeCard(user?.fullName),
                        const SizedBox(height: 30),
                        _buildGridMenu(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(String? name) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1976D2).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Color(0xFF1976D2)),
          ),
          const SizedBox(height: 15),
          Text(
            'مرحباً بك، \${name ?? "يا أستاذ"}',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'لوحة التحكم الأكاديمية',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _menuCard(
          title: 'رفع المحاضرات',
          icon: Icons.cloud_upload_outlined,
          color: Colors.blueAccent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TeacherUploadScreen())),
        ),
        _menuCard(
          title: 'رصد الغياب',
          icon: Icons.assignment_turned_in_outlined,
          color: Colors.greenAccent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AttendanceScreen())),
        ),
        _menuCard(
          title: 'الجدول الدراسي',
          icon: Icons.calendar_month_outlined,
          color: Colors.orangeAccent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TeacherScheduleScreen())),
        ),
        _menuCard(
          title: 'الإحصائيات',
          icon: Icons.analytics_outlined,
          color: Colors.purpleAccent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TeacherStatsScreen())),
        ),
        _menuCard(
          title: 'البريد الوارد',
          icon: Icons.chat_bubble_outline,
          color: Colors.pinkAccent,
          onTap: () => _openChat(context),
        ),
        _menuCard(
          title: 'إعدادات المواد',
          icon: Icons.settings_suggest_outlined,
          color: Colors.tealAccent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TeacherSettingsScreen())),
        ),
      ],
    );
  }

  Widget _menuCard(
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GlassCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumDrawer(BuildContext context, dynamic u, WidgetRef ref) {
    final name = u?.fullName ?? 'الأستاذ';
    final email = u?.email ?? 'عضو هيئة التدريس';

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              accountName: Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail:
                  Text(email, style: const TextStyle(color: Colors.white70)),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(child: Icon(Icons.person, size: 30)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white70),
              title: const Text('الملف الشخصي',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TeacherProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white70),
              title: const Text('إعدادات المواد',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TeacherSettingsScreen()));
              },
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('تسجيل الخروج',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherChatBadgeIcon extends StatelessWidget {
  final String uid;
  final VoidCallback onTap;

  const _TeacherChatBadgeIcon({required this.uid, required this.onTap});

  int _unreadCount(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    int c = 0;
    for (final d in docs) {
      final data = d.data();
      final updatedAt = data['updatedAt'];
      final readMap = data['read'];

      DateTime? updated;
      if (updatedAt is Timestamp) updated = updatedAt.toDate();

      DateTime? readTime;
      if (readMap is Map && readMap[uid] is Timestamp) {
        readTime = (readMap[uid] as Timestamp).toDate();
      }

      if (updated != null) {
        if (readTime == null || readTime.isBefore(updated)) c++;
      }
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    final chat = ChatService(); // NOTE: Might want to refactor this too eventually

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chat.watchMyThreads(uid),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? const [];
        final unread = _unreadCount(docs);

        return IconButton(
          onPressed: onTap,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.chat_bubble_outline, color: Colors.white),
              if (unread > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unread > 99 ? '99+' : unread.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
