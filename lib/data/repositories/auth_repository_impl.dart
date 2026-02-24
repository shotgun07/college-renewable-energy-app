import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

/// Implementation of AuthRepository using Firebase
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<User> signIn(String email, String password) async {
    final userModel = await _remoteDatasource.signIn(email, password);
    return userModel; // UserModel extends User
  }

  @override
  Future<void> signOut() async {
    await _remoteDatasource.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _remoteDatasource.getCurrentFirebaseUser();
    if (firebaseUser == null) return null;

    final userModel = await _remoteDatasource.getUserData(firebaseUser.uid);
    return userModel;
  }

  @override
  Stream<User?> authStateChanges() {
    return _remoteDatasource.authStateChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }

      // Return stream of user data from Firestore
      return _remoteDatasource.getUserStream(firebaseUser.uid);
    });
  }

  @override
  Future<bool> isUserVerified(String uid) async {
    final firebaseUser = _remoteDatasource.getCurrentFirebaseUser();
    if (firebaseUser == null) return false;

    // Reload to get latest email verification status
    await firebaseUser.reload();
    final refreshedUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (refreshedUser?.emailVerified == true) {
      return true;
    }

    // Check custom verification
    return await _remoteDatasource.isCustomVerified(uid);
  }

  @override
  Future<void> markUserPendingVerification(String uid) async {
    await _remoteDatasource.markPendingVerification(uid);
  }

  @override
  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    await _remoteDatasource.manuallyVerifyUser(uid, adminUid);
  }

  @override
  Future<void> verifyWithCode(String uid, String code) async {
    await _remoteDatasource.verifyWithCode(uid, code);
  }

  @override
  Future<String> generateVerificationCode(String uid) async {
    return await _remoteDatasource.generateVerificationCode(uid);
  }

  @override
  Future<bool> isCustomVerified(String uid) async {
    return await _remoteDatasource.isCustomVerified(uid);
  }

  @override
  Future<void> sendEmailVerification() async {
    await _remoteDatasource.sendEmailVerification();
  }

  @override
  Future<User> register(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    final userModel =
        await _remoteDatasource.register(email, password, userData);
    return userModel;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _remoteDatasource.resetPassword(email);
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _remoteDatasource.updateProfile(uid, data);
  }

  @override
  Stream<List<User>> getUnverifiedUsers() {
    return _remoteDatasource.getUnverifiedUsers();
  }
}
