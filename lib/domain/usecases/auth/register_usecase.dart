import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';
import '../../../core/errors/auth_exceptions.dart';

/// Use case for user registration
/// Encapsulates business logic for creating a new user account
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Execute registration operation
  ///
  /// Validates inputs and delegates to repository
  /// Throws [InvalidCredentialsException] if email or password is empty
  /// Throws [AuthException] for other auth failures
  Future<User> call(String email, String password, Map<String, dynamic> userData) async {
    // Business logic validation
    if (email.trim().isEmpty) {
      throw InvalidCredentialsException('البريد الإلكتروني مطلوب');
    }

    if (password.trim().isEmpty) {
      throw InvalidCredentialsException('كلمة المرور مطلوبة');
    }

    if (password.length < 8) {
      throw WeakPasswordException();
    }

    // Delegate to repository
    return await _repository.register(email, password, userData);
  }
}
