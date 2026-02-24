import '../../repositories/auth_repository.dart';

class VerifyCodeUseCase {
  final AuthRepository _repository;

  VerifyCodeUseCase(this._repository);

  Future<void> call(String uid, String code) async {
    return await _repository.verifyWithCode(uid, code);
  }
}
