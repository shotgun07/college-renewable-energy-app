import '../../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  /// Execute sign-out operation
  Future<void> call() async {
    return await _repository.signOut();
  }
}
