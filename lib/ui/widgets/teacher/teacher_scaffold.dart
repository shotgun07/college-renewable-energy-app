import 'package:flutter/material.dart';

class TeacherScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool isLoading;

  const TeacherScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.actions,
    this.showBackButton = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
        automaticallyImplyLeading: showBackButton || drawer != null,
        actions: actions,
      ),
      drawer: drawer,
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF0F172A)
                ],
              ),
            ),
          )),

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
}
