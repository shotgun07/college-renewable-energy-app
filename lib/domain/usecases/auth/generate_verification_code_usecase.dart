import '../../repositories/auth_repository.dart';

class GenerateVerificationCodeUseCase {
  final AuthRepository _repository;

  GenerateVerificationCodeUseCase(this._repository);

  Future<String> call(String uid) async {
    return await _repository.generateVerificationCode(uid);
  }
}
