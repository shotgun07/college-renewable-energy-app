import '../../repositories/auth_repository.dart';
import '../../../core/errors/auth_exceptions.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  /// Execute update profile operation
  Future<void> call(String uid, Map<String, dynamic> data) async {
    if (uid.isEmpty) {
      throw AuthException('معرف المستخدم غير صالح');
    }
    
    if (data.isEmpty) {
      throw AuthException('لا توجد بيانات للتحديث');
    }

    await _repository.updateProfile(uid, data);
  }
}
