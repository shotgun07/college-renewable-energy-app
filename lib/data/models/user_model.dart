import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../core/security/app_encryption_helper.dart';

/// Data model for User - maps to/from Firestore
/// Extends domain entity and adds serialization logic
class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.fullName,
    required super.departmentName,
    required super.semester,
    required super.role,
    required super.phoneNumber,
    super.email,
    required super.nationalId,
    required super.studentID,
    super.city,
    super.landmark,
    super.biometricEnabled,
    super.twoFactorEnabled,
    super.profileImageUrl,
    super.publicKey,
    super.specialization,
    super.officeHours,
    super.bio,
    super.teachingKeys,
    super.emailVerified,
    super.customVerified,
    super.requiresVerification,
    super.verificationRequestedAt,
    super.lastVerificationReminderAt,
    super.verifiedBy,
    super.verifiedAt,
    super.lastLogin,
  });

  /// Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('User document is empty');
    }

    return UserModel(
      uid: doc.id,
      fullName: (data['fullName'] ?? '').toString(),
      phoneNumber: AppEncryptionHelper.decrypt((data['phoneNumber'] ?? '').toString()),
      email: data['email']?.toString(),
      nationalId: AppEncryptionHelper.decrypt((data['nationalId'] ?? '').toString().trim()),
      studentID: AppEncryptionHelper.decrypt((data['studentID'] ?? '').toString().trim()),
      departmentName:
          (data['departmentName'] ?? data['department'] ?? 'عام').toString(),
      semester: _parseInt(data['semester'], fallback: 1),
      role: _roleFrom(data['role']),
      city: data['city']?.toString(),
      landmark: data['landmark']?.toString(),
      biometricEnabled: data['biometricEnabled'] == true,
      twoFactorEnabled: data['twoFactorEnabled'] == true,
      profileImageUrl: data['profileImageUrl']?.toString(),
      publicKey: data['publicKey']?.toString(),
      specialization: data['specialization']?.toString(),
      officeHours: data['officeHours']?.toString(),
      bio: data['bio']?.toString(),
      teachingKeys: List<String>.from(data['teachingKeys'] ?? []),
      emailVerified: data['emailVerified'] == true,
      customVerified: data['customVerified'] == true,
      requiresVerification: data['requiresVerification'] ?? true,
      verificationRequestedAt: _parseTimestamp(data['verificationRequestedAt']),
      lastVerificationReminderAt:
          _parseTimestamp(data['lastVerificationReminderAt']),
      verifiedBy: data['verifiedBy']?.toString(),
      verifiedAt: _parseTimestamp(data['verifiedAt']),
      lastLogin: _parseTimestamp(data['lastLogin']),
    );
  }

  /// Create UserModel from Map (for JSON/Cache)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      fullName: data['fullName'] ?? '',
      phoneNumber: AppEncryptionHelper.decrypt(data['phoneNumber'] ?? ''),
      email: data['email'],
      nationalId: AppEncryptionHelper.decrypt(data['nationalId'] ?? ''),
      studentID: AppEncryptionHelper.decrypt(data['studentID'] ?? ''),
      departmentName: data['departmentName'] ?? 'عام',
      semester: data['semester'] ?? 1,
      role: _roleFrom(data['role']),
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
      verificationRequestedAt: data['verificationRequestedAt'] != null
          ? DateTime.parse(data['verificationRequestedAt'])
          : null,
      lastVerificationReminderAt: data['lastVerificationReminderAt'] != null
          ? DateTime.parse(data['lastVerificationReminderAt'])
          : null,
      verifiedBy: data['verifiedBy'],
      verifiedAt: data['verifiedAt'] != null
          ? DateTime.parse(data['verifiedAt'])
          : null,
      lastLogin:
          data['lastLogin'] != null ? DateTime.parse(data['lastLogin']) : null,
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': AppEncryptionHelper.encrypt(phoneNumber),
      'email': email,
      'nationalId': AppEncryptionHelper.encrypt(nationalId),
      'studentID': AppEncryptionHelper.encrypt(studentID),
      'departmentName': departmentName,
      'semester': semester,
      'role': role.name,
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
      if (verificationRequestedAt != null)
        'verificationRequestedAt': Timestamp.fromDate(verificationRequestedAt!),
      if (lastVerificationReminderAt != null)
        'lastVerificationReminderAt':
            Timestamp.fromDate(lastVerificationReminderAt!),
      'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': Timestamp.fromDate(verifiedAt!),
      if (lastLogin != null) 'lastLogin': Timestamp.fromDate(lastLogin!),
    };
  }

  /// Convert to Map for caching/JSON
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': AppEncryptionHelper.encrypt(phoneNumber),
      'email': email,
      'nationalId': AppEncryptionHelper.encrypt(nationalId),
      'studentID': AppEncryptionHelper.encrypt(studentID),
      'departmentName': departmentName,
      'semester': semester,
      'role': role.name,
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
      'verificationRequestedAt': verificationRequestedAt?.toIso8601String(),
      'lastVerificationReminderAt':
          lastVerificationReminderAt?.toIso8601String(),
      'verifiedBy': verifiedBy,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Create User entity from domain entity (for conversions)
  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      fullName: user.fullName,
      departmentName: user.departmentName,
      semester: user.semester,
      role: user.role,
      phoneNumber: user.phoneNumber,
      email: user.email,
      nationalId: user.nationalId,
      studentID: user.studentID,
      city: user.city,
      landmark: user.landmark,
      biometricEnabled: user.biometricEnabled,
      twoFactorEnabled: user.twoFactorEnabled,
      profileImageUrl: user.profileImageUrl,
      publicKey: user.publicKey,
      specialization: user.specialization,
      officeHours: user.officeHours,
      bio: user.bio,
      teachingKeys: user.teachingKeys,
      emailVerified: user.emailVerified,
      customVerified: user.customVerified,
      requiresVerification: user.requiresVerification,
      verificationRequestedAt: user.verificationRequestedAt,
      lastVerificationReminderAt: user.lastVerificationReminderAt,
      verifiedBy: user.verifiedBy,
      verifiedAt: user.verifiedAt,
      lastLogin: user.lastLogin,
    );
  }

  // Helper methods
  static UserRole _roleFrom(dynamic value) {
    final v = (value ?? '').toString().trim().toLowerCase();
    if (v == 'admin') return UserRole.admin;
    if (v == 'supervisor') return UserRole.supervisor;
    if (v == 'teacher') return UserRole.teacher;
    return UserRole.student;
  }

  static int _parseInt(dynamic v, {int fallback = 1}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
