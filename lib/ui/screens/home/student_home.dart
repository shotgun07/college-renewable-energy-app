import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/student/student_scaffold.dart';
// import '../../widgets/student/student_provider.dart'; // Removed
import '../../widgets/verification_banner_widget.dart';

import '../../../presentation/providers/auth_provider.dart';

import '../announcements/student_view_announcements.dart';
import '../results/student_view_results.dart';
import '../schedules/student_view_schedule.dart';
import '../profile/profile_screen.dart';
import '../chat/student_chat_hub.dart';
import '../library/student_library_screen.dart';
import '../lectures/student_courses_screen.dart';
import '../student/student_feedback_screen.dart';
import '../../../features/ai_assistant/presentation/pages/ai_chat_screen.dart';

class StudentHome extends ConsumerWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      // In case we are somehow here without a user (e.g. initial load or direct nav)
      return const StudentScaffold(
        title: '????? ??????',
        isLoading: true,
        body: SizedBox(),
      );
    }

    final fullName = user.fullName;
    final deptName = user.departmentName;
    final semester = user.semester;
    final studentID = user.studentID;

    return StudentScaffold(
      title: '????? ?????? ??????',
      showBackButton: false,
      drawer:
          _buildDrawer(context, ref, fullName, deptName, semester, studentID),
      body: Column(
        children: [
          // Verification banner for unverified users
          VerificationBannerWidget(
            userId: user.uid,
          ),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildWelcomeCard(fullName, deptName, semester, studentID),
                  const SizedBox(height: 30),
                  _buildInfoText(),
                  const SizedBox(height: 30),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                    ),
                    children: [
                      _QuickAccessCard(
                        title: '??????',
                        icon: Icons.calendar_month,
                        color: Colors.orangeAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  StudentViewSchedule(department: deptName)),
                        ),
                      ),
                      _QuickAccessCard(
                        title: '???????',
                        icon: Icons.emoji_events,
                        color: Colors.greenAccent,
                        onTap: () => _openResults(context, studentID),
                      ),
                      _QuickAccessCard(
                        title: '???????',
                        icon: Icons.menu_book,
                        color: Colors.purpleAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StudentLibraryScreen(
                                  department: deptName, semester: semester)),
                        ),
                      ),
                      _QuickAccessCard(
                        title: '?????',
                        icon: Icons.class_,
                        color: Colors.blueAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StudentCoursesScreen(
                                  department: deptName, semester: semester)),
                        ),
                      ),
                      _QuickAccessCard(
                        title: '???????',
                        icon: Icons.forum,
                        color: Colors.pinkAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StudentChatHub(
                                  departmentName: deptName,
                                  semester: semester)),
                        ),
                      ),
                      _QuickAccessCard(
                        title: '??????? ?????',
                        icon: Icons.auto_awesome,
                        color: Colors.cyanAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AiChatScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(
      String name, String dept, int semester, String studentID) {
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
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF1976D2)),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '?????: $dept | ?????: $semester',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          if (studentID.isNotEmpty && studentID != 'null')
            Text(
              '??? ?????: $studentID',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '???? ???? ?? ??????? ????? ?????',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, String name,
      String dept, int semester, String studentID) {
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
              accountEmail: Text('$dept - ??? $semester',
                  style: const TextStyle(color: Colors.white70)),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(child: Icon(Icons.person, size: 30)),
              ),
            ),
            _drawerItem(context, Icons.home, '????????', Colors.blue,
                () => Navigator.pop(context)),
            _drawerItem(context, Icons.calendar_month, '?????? ???????',
                Colors.orangeAccent, () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StudentViewSchedule(department: dept)));
            }),
            _drawerItem(
                context, Icons.emoji_events, '???????', Colors.greenAccent, () {
              Navigator.pop(context);
              _openResults(context, studentID);
            }),
            _drawerItem(
                context, Icons.menu_book, '???????', Colors.purpleAccent, () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StudentLibraryScreen(
                          department: dept, semester: semester)));
            }),
            _drawerItem(context, Icons.campaign, '?????????', Colors.blueAccent,
                () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const StudentViewAnnouncements()));
            }),
            _drawerItem(context, Icons.forum, '???????', Colors.pinkAccent, () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StudentChatHub(
                          departmentName: dept, semester: semester)));
            }),
            _drawerItem(context, Icons.star_rate, '????? ???????', Colors.yellowAccent, () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const StudentFeedbackScreen()));
            }),
            _drawerItem(context, Icons.auto_awesome, '??????? ?????', Colors.cyanAccent, () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AiChatScreen()));
            }),
            const Divider(color: Colors.white12),
            _drawerItem(
                context, Icons.account_circle, '???? ??????', Colors.tealAccent,
                () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('????? ??????',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                // Use Riverpod provider for sign out
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

  Widget _drawerItem(BuildContext context, IconData icon, String title,
      Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  void _openResults(BuildContext context, String studentID) {
    if (studentID.isEmpty || studentID == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('?? ???? ??? ??????? ??? ??? ????? ??? ???? ???')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentViewResults(studentID: studentID),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
