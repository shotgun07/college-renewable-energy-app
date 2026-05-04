import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user.dart' as domain; 

class UserModel {
  final String uid;
  final String fullName;
  final String departmentName;
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
  final String? publicKey;
  final String? specialization;
  final String? officeHours;
  final String? bio;
  final List<String> teachingKeys;
  final bool emailVerified;
  final bool customVerified;
  final bool requiresVerification;
  final DateTime? verificationRequestedAt;
  final DateTime? lastVerificationReminderAt;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.departmentName,
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
    this.publicKey,
    this.specialization,
    this.officeHours,
    this.bio,
    this.teachingKeys = const [],
    this.emailVerified = false,
    this.customVerified = false,
    this.requiresVerification = true,
    this.verificationRequestedAt,
    this.lastVerificationReminderAt,
    this.verifiedBy,
    this.verifiedAt,
    this.lastLogin,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      departmentName: data['departmentName'] ?? data['department'] ?? 'عام',
      semester: (data['semester'] as num?)?.toInt() ?? 1,
      role: _roleFromString(data['role']),
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'],
      nationalId: data['nationalId'] ?? '',
      studentID: data['studentID'] ?? '',
      city: data['city'],
      landmark: data['landmark'],
      biometricEnabled: data['biometricEnabled'] ?? false,
      twoFactorEnabled: data['twoFactorEnabled'] ?? false,
      profileImageUrl: data['profileImageUrl'],
      publicKey: data['publicKey'],
      specialization: data['specialization'],
      officeHours: data['officeHours'],
      bio: data['bio'],
      teachingKeys: List<String>.from(data['teachingKeys'] ?? []),
      emailVerified: data['emailVerified'] ?? false,
      customVerified: data['customVerified'] ?? false,
      requiresVerification: data['requiresVerification'] ?? true,
      verificationRequestedAt: (data['verificationRequestedAt'] as Timestamp?)?.toDate(),
      lastVerificationReminderAt: (data['lastVerificationReminderAt'] as Timestamp?)?.toDate(),
      verifiedBy: data['verifiedBy'],
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'departmentName': departmentName,
      'semester': semester,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'email': email,
      'nationalId': nationalId,
      'studentID': studentID,
      'city': city,
      'landmark': landmark,
      'biometricEnabled': biometricEnabled,
      'twoFactorEnabled': twoFactorEnabled,
      'profileImageUrl': profileImageUrl,
      'publicKey': publicKey,
      'specialization': specialization,
      'officeHours': officeHours,
      'bio': bio,
      'teachingKeys': teachingKeys,
      'emailVerified': emailVerified,
      'customVerified': customVerified,
      'requiresVerification': requiresVerification,
      'verificationRequestedAt': verificationRequestedAt != null ? Timestamp.fromDate(verificationRequestedAt!) : null,
      'lastVerificationReminderAt': lastVerificationReminderAt != null ? Timestamp.fromDate(lastVerificationReminderAt!) : null,
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    };
  }

  domain.User toEntity() {
    return domain.User(
      uid: uid,
      fullName: fullName,
      departmentName: departmentName,
      semester: semester,
      role: role,
      phoneNumber: phoneNumber,
      email: email,
      nationalId: nationalId,
      studentID: studentID,
      city: city,
      landmark: landmark,
      biometricEnabled: biometricEnabled,
      twoFactorEnabled: twoFactorEnabled,
      profileImageUrl: profileImageUrl,
      publicKey: publicKey,
      specialization: specialization,
      officeHours: officeHours,
      bio: bio,
      teachingKeys: teachingKeys,
      emailVerified: emailVerified,
      customVerified: customVerified,
      requiresVerification: requiresVerification,
      verificationRequestedAt: verificationRequestedAt,
      lastVerificationReminderAt: lastVerificationReminderAt,
      verifiedBy: verifiedBy,
      verifiedAt: verifiedAt,
      lastLogin: lastLogin,
    );
  }

  static UserRole _roleFromString(dynamic value) {
    final v = (value ?? '').toString().trim().toLowerCase();
    switch (v) {
      case 'admin': return UserRole.admin;
      case 'supervisor': return UserRole.supervisor;
      case 'teacher': return UserRole.teacher;
      default: return UserRole.student;
    }
  }
}