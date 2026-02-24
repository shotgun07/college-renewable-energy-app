import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';
import '../../../core/errors/auth_exceptions.dart';

/// Use case for user sign-in
/// Encapsulates business logic for authentication
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  /// Execute sign-in operation
  ///
  /// Validates inputs and delegates to repository
  /// Throws [InvalidCredentialsException] if email or password is empty
  /// Throws [AuthException] for other auth failures
  Future<User> call(String email, String password) async {
    // Business logic validation
    if (email.trim().isEmpty) {
      throw InvalidCredentialsException('البريد الإلكتروني مطلوب');
    }

    if (password.trim().isEmpty) {
      throw InvalidCredentialsException('كلمة المرور مطلوبة');
    }

    if (password.length < 6) {
      throw InvalidCredentialsException(
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    // Delegate to repository
    return await _repository.signIn(email, password);
  }
}
