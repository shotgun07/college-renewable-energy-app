import '../entities/user.dart';
import '../../core/errors/auth_exceptions.dart';


abstract class AuthRepository {

  Future<User> signIn(String email, String password);


  Future<void> signOut();

  Future<User?> getCurrentUser();

  Stream<User?> authStateChanges();

  Future<bool> isUserVerified(String uid);

  Future<void> markUserPendingVerification(String uid);

  Future<void> manuallyVerifyUser(String uid, String adminUid);

  Future<void> verifyWithCode(String uid, String code);


  Future<String> generateVerificationCode(String uid);

  Future<bool> isCustomVerified(String uid);

  Future<void> sendEmailVerification();

  Future<User> register(
      String email, String password, Map<String, dynamic> userData);

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> updateProfile(String uid, Map<String, dynamic> data);

  Stream<List<User>> getUnverifiedUsers();
}
