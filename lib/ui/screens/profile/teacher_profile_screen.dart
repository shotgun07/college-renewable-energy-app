import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';
import 'package:app/services/profile_image_service.dart';
import 'package:app/domain/entities/user.dart';
import 'dart:io';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
  bool _isUploading = false;

  Future<void> _pickAndUploadImage(String uid) async {
    final service = ProfileImageService();
    final pickedFile = await service.pickImage();
    if (pickedFile == null) return;

    setState(() => _isUploading = true);
    final url = await service.uploadProfileImage(uid, File(pickedFile.path));
    setState(() => _isUploading = false);

    if (url != null && mounted) {
      await ref.read(authProvider.notifier).updateProfile(uid, {'profileImageUrl': url});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("?? ????? ?????? ??????? ?????")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => const TeacherScaffold(
        title: "???? ??????",
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (e, st) => TeacherScaffold(
        title: "???? ??????",
        body: Center(
            child: Text("???? ??? ????????: \$e",
                style: const TextStyle(color: Colors.white))),
      ),
      data: (user) {
        if (user == null) {
          return const TeacherScaffold(
            title: "???? ??????",
            body: Center(
                child: Text("??? ????? ?????? ?????",
                    style: TextStyle(color: Colors.white))),
          );
        }

        final fullName = user.fullName;
        final email = user.email ?? '??? ?????';
        final phone = user.phoneNumber;
        final dept = user.departmentName;
        final role = user.role.name;
        final twoFactorEnabled = user.twoFactorEnabled;
        final profileImageUrl = user.profileImageUrl;

        // Check for real email
        final bool hasRealEmail = email.isNotEmpty &&
            email != '??? ?????' &&
            !email.endsWith('@college.edu.ly');

        return TeacherScaffold(
          title: "???? ??????",
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _pickAndUploadImage(user.uid),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF1976D2)
                                    .withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: const Color(0xFF1976D2),
                          backgroundImage: profileImageUrl != null
                              ? CachedNetworkImageProvider(profileImageUrl)
                              : null,
                          child: profileImageUrl == null
                              ? (_isUploading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Icon(Icons.person,
                                      size: 70, color: Colors.white))
                              : (_isUploading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : null),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1976D2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  fullName,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  _translateRole(role),
                  style: TextStyle(
                      fontSize: 14, color: Colors.white.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 30),
                if (hasRealEmail)
                  _buildProfileItem(
                      "?????? ??????????", email, Icons.email_outlined),
                _buildProfileItem(
                    "??? ??????",
                    phone.isEmpty ? "??? ????" : phone,
                    Icons.phone_android_outlined),
                _buildProfileItem("????? ??????", dept, Icons.school_outlined),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("??????? ??????",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                _buildSecurityToggle(
                  "???????? ???????? (2FA)",
                  "????? ?????? ??????? ??? ??????",
                  twoFactorEnabled,
                  (val) async {
                    await ref
                        .read(authProvider.notifier)
                        .updateProfile(user.uid, {'twoFactorEnabled': val});
                  },
                ),
                const SizedBox(height: 30),
                _buildActionTile(
                  "????? ???????? ???????",
                  Icons.edit_note_outlined,
                  () => _showEditInfoDialog(context, user),
                ),
                _buildActionTile(
                  "????? ???? ??????",
                  Icons.lock_outline,
                  () => _showChangePasswordDialog(context),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                        colors: [Colors.red, Color.fromARGB(255, 255, 82, 82)]),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("????? ??????",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _translateRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return '????';
      case 'teacher':
        return '???? / ??? ???? ?????';
      case 'admin':
        return '???? ???';
      case 'supervisor':
        return '???? ???';
      default:
        return role;
    }
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64B5F6), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5))),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityToggle(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        subtitle: Text(subtitle,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF64B5F6),
        secondary:
            const Icon(Icons.security, color: Color(0xFF64B5F6), size: 22),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF64B5F6), size: 22),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white24, size: 14),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("????? ???? ??????",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "???? ?????? ???????",
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("?????")),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser
                    ?.updatePassword(controller.text);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("?? ??????? ?????")));
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("???: $e")));
                }
              }
            },
            child: const Text("???"),
          ),
        ],
      ),
    );
  }

  void _showEditInfoDialog(BuildContext context, User user) {
    final specController =
        TextEditingController(text: user.specialization ?? '');
    final hoursController =
        TextEditingController(text: user.officeHours ?? '');
    final bioController = TextEditingController(text: user.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("????? ????????? ???????",
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField(specController, "??????"),
              _buildEditField(hoursController, "??????? ????????"),
              _buildEditField(bioController, "?????? ???????", maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("?????")),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authProvider.notifier).updateProfile(user.uid, {
                  'specialization': specController.text,
                  'officeHours': hoursController.text,
                  'bio': bioController.text,
                });

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("?? ??????? ?????")));
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("???: $e")));
                }
              }
            },
            child: const Text("???"),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24)),
        ),
      ),
    );
  }
}
