enum UserRole { student, teacher, supervisor, admin }

class User {
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

  const User({
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

  bool get isVerified => emailVerified || customVerified;

  User copyWith({
    String? uid,
    String? fullName,
    String? departmentName,
    int? semester,
    UserRole? role,
    String? phoneNumber,
    String? email,
    String? nationalId,
    String? studentID,
    String? city,
    String? landmark,
    bool? biometricEnabled,
    bool? twoFactorEnabled,
    String? profileImageUrl,
    String? publicKey,
    String? specialization,
    String? officeHours,
    String? bio,
    List<String>? teachingKeys,
    bool? emailVerified,
    bool? customVerified,
    bool? requiresVerification,
    DateTime? verificationRequestedAt,
    DateTime? lastVerificationReminderAt,
    String? verifiedBy,
    DateTime? verifiedAt,
    DateTime? lastLogin,
  }) {
    return User(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      departmentName: departmentName ?? this.departmentName,
      semester: semester ?? this.semester,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      studentID: studentID ?? this.studentID,
      city: city ?? this.city,
      landmark: landmark ?? this.landmark,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      publicKey: publicKey ?? this.publicKey,
      specialization: specialization ?? this.specialization,
      officeHours: officeHours ?? this.officeHours,
      bio: bio ?? this.bio,
      teachingKeys: teachingKeys ?? List.from(this.teachingKeys),
      emailVerified: emailVerified ?? this.emailVerified,
      customVerified: customVerified ?? this.customVerified,
      requiresVerification: requiresVerification ?? this.requiresVerification,
      verificationRequestedAt:
          verificationRequestedAt ?? this.verificationRequestedAt,
      lastVerificationReminderAt:
          lastVerificationReminderAt ?? this.lastVerificationReminderAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() => 'User(uid: $uid, fullName: $fullName, role: $role)';
}
