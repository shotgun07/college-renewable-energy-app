import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/theme_toggle_button.dart';

class SupervisorScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool isLoading;
  final Widget? drawer;

  const SupervisorScaffold({
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
                    Color(0xFF2C3E50), 
                    Color(0xFF4CA1AF),
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
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          ),
        ),
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              accountName: Text('مشرف القسم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text('supervisor@college.edu',
                  style: TextStyle(color: Colors.white70)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.supervisor_account,
                    color: Color(0xFF2C3E50), size: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ThemeToggleButton(),
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
      ),
    );
  }
}
