import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_user.dart';
import '../../main.dart' show themeProvider;
import '../dashboard/dashboard_home.dart';
import 'users_management_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'results/bulk_upload_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  final AppUser user;

  const MainScreen({super.key, required this.user});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardHome(user: widget.user),
      UsersManagementScreen(user: widget.user),
      ReportsScreen(user: widget.user),
      NotificationsScreen(user: widget.user),
      const BulkUploadScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('لوحة إدارة الكلية', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => theme.toggleTheme(),
            tooltip: 'تبديل المظهر',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.isDarkMode
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(child: _screens[_selectedIndex]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'لوحة التحكم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'إدارة المستخدمين',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'التقارير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_file),
              label: 'رفع النتائج',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: theme.isDarkMode ? const Color(0xFF64B5F6) : Colors.blue,
          unselectedItemColor: theme.isDarkMode ? Colors.white60 : Colors.black54,
          backgroundColor: theme.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          onTap: _onItemTapped,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}