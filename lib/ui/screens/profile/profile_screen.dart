import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth; 
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../../services/profile_image_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isUploading = false;

  Future<void> _pickAndUploadImage(String uid) async {
    final service = ProfileImageService();
    final pickedFile = await service.pickImage();
    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final url = await service.uploadProfileImage(uid, File(pickedFile.path));
      if (url != null && mounted) {
        // Automatically refresh provider when image is uploaded
        await ref.read(authProvider.notifier).updateProfile(uid, {'profileImageUrl': url});
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("?? ????? ?????? ??????? ?????")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("??? ?? ????? ??????: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
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
              if (controller.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("???? ?????? ??? ?? ???? 6 ???? ??? ?????")));
                return;
              }
              try {
                // Keep FirebaseAuth for now since updatePassword is not in repo yet
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

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF64B5F6)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF64B5F6),
        secondary: const Icon(Icons.security, color: Color(0xFF64B5F6)),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF64B5F6)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white24, size: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => const StudentScaffold(
        title: "???? ??????",
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (e, st) => StudentScaffold(
        title: "???? ??????",
        body: Center(
            child: Text("???? ??? ????????: \$e",
                style: const TextStyle(color: Colors.white))),
      ),
      data: (user) {
        if (user == null) {
          return const StudentScaffold(
            title: "???? ??????",
            body: Center(
                child: Text("??? ????? ?????? ?????",
                    style: TextStyle(color: Colors.white))),
          );
        }

        final fullName = user.fullName;
        final email = user.email ?? '??? ?????';
        final phone = user.phoneNumber;
        final studentID = user.studentID;
        final dept = user.departmentName;
        final twoFactorEnabled = user.twoFactorEnabled;

        final bool hasRealEmail = email.isNotEmpty &&
            email != '??? ?????' &&
            !email.contains(phone) &&
            !email.endsWith('@college.edu.ly');

        return StudentScaffold(
          title: "???? ??????",
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _pickAndUploadImage(user.uid),
                  child: Stack(
                    alignment: Alignment.center,
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
                        child: _isUploading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : CircleAvatar(
                                radius: 55,
                                backgroundColor: const Color(0xFF1976D2),
                                backgroundImage: user.profileImageUrl != null
                                    ? NetworkImage(user.profileImageUrl!)
                                    : null,
                                child: user.profileImageUrl == null
                                    ? const Icon(Icons.person,
                                        size: 60, color: Colors.white)
                                    : null,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileItem(
                    "????? ??????",
                    fullName.isEmpty ? "??? ????" : fullName,
                    Icons.person_outline),
                if (hasRealEmail)
                  _buildProfileItem(
                      "?????? ??????????", email, Icons.email_outlined),
                _buildProfileItem(
                    "??? ??????",
                    phone.isEmpty ? "??? ????" : phone,
                    Icons.phone_android_outlined),
                _buildProfileItem("????? ???????", dept, Icons.school_outlined),
                _buildProfileItem(
                    "??? ?????",
                    studentID.isEmpty ? "??????? ???????..." : studentID,
                    Icons.assignment_ind_outlined),
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
                  "????? ?????? ??? ??? ?????? (SMS)",
                  twoFactorEnabled,
                  (val) async {
                    await ref
                        .read(authProvider.notifier)
                        .updateProfile(user.uid, {'twoFactorEnabled': val});
                  },
                ),
                _buildActionTile(
                  "????? ???? ??????",
                  Icons.lock_outline,
                  () => _showChangePasswordDialog(context),
                ),
                const SizedBox(height: 30),
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
}

