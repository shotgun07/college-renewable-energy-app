import '../../repositories/auth_repository.dart';

/// Use case for manually verifying a user (admin only)
class ManuallyVerifyUserUseCase {
  final AuthRepository _repository;

  ManuallyVerifyUserUseCase(this._repository);

  /// Manually verify user
  ///
  /// [uid] - User ID to verify
  /// [adminUid] - Admin user ID performing verification
  Future<void> call(String uid, String adminUid) async {
    if (uid.trim().isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (adminUid.trim().isEmpty) {
      throw ArgumentError('Admin ID cannot be empty');
    }

    await _repository.manuallyVerifyUser(uid, adminUid);
  }
}
