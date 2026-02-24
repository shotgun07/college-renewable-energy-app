import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/admin/manage_students_screen.dart';
import '../../screens/admin/admin_courses_screen.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool isLoading;
  final Widget? drawer;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.isLoading = false,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: actions,
      ),
      drawer: drawer ?? _buildDefaultDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF1A1A1A),
                    Color(0xFF0D0D0D)
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            accountName: Text('الإدارة العامة'),
            accountEmail: Text('admin@college.edu'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings, color: Colors.black),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline, color: Colors.white),
            title: const Text('إدارة الطلاب',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManageStudentsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined, color: Colors.white),
            title: const Text('إدارة المواد',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminCoursesScreen()));
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('تسجيل الخروج',
                style: TextStyle(color: Colors.white)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
