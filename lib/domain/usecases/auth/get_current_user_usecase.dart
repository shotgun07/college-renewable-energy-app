import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';

/// Use case for getting current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Get currently authenticated user
  /// Returns null if not authenticated
  Future<User?> call() async {
    return await _repository.getCurrentUser();
  }
}
