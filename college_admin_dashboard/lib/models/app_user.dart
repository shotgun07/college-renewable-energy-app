import '../security/app_encryption_helper.dart';
import '../constants/app_enums.dart';

class AppUser {
  final String uid;
  final String fullName;
  final Department department;
  final int semester;
  final UserRole role;

  final String phoneNumber;
  final String? email;
  final String nationalId;
  final String studentID;

  final String? city;
  final String? landmark;

  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final String? profileImageUrl;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.department,
    required this.semester,
    required this.role,
    required this.phoneNumber,
    this.email,
    required this.nationalId,
    required this.studentID,
    this.city,
    this.landmark,
    this.biometricEnabled = false,
    this.twoFactorEnabled = false,
    this.profileImageUrl,
  });

  static UserRole roleFrom(dynamic value) {
    final v = (value ?? '').toString().trim().toLowerCase();
    if (v == 'admin') return UserRole.admin;
    if (v == 'supervisor') return UserRole.supervisor;
    if (v == 'teacher') return UserRole.teacher;
    return UserRole.student;
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic>? data) {
    final d = data ?? {};
    return AppUser(
      uid: uid,
      fullName: (d['fullName'] ?? '').toString(),
      phoneNumber: AppEncryptionHelper.decrypt((d['phoneNumber'] ?? '').toString()),
      email: d['email']?.toString(),
      nationalId: AppEncryptionHelper.decrypt((d['nationalId'] ?? '').toString().trim()),
      studentID: AppEncryptionHelper.decrypt((d['studentID'] ?? '').toString().trim()),
      department: Department.fromString(d['departmentName'] ?? d['department']),
      semester: _parseInt(d['semester'], fallback: 1),
      role: roleFrom(d['role']),
      city: d['city']?.toString(),
      landmark: d['landmark']?.toString(),
      biometricEnabled: d['biometricEnabled'] == true,
      twoFactorEnabled: d['twoFactorEnabled'] == true,
      profileImageUrl: d['profileImageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': AppEncryptionHelper.encrypt(phoneNumber),
      'email': email,
      'nationalId': AppEncryptionHelper.encrypt(nationalId),
      'studentID': AppEncryptionHelper.encrypt(studentID),
      'departmentName': department.displayName,
      'semester': semester,
      'role': role.name,
      'city': city,
      'landmark': landmark,
      'biometricEnabled': biometricEnabled,
      'twoFactorEnabled': twoFactorEnabled,
      'profileImageUrl': profileImageUrl,
    };
  }

  static int _parseInt(dynamic v, {int fallback = 1}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }
}
