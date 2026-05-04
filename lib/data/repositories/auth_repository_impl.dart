import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;


  @override
  Future<User> signIn(String email, String password) async {
    try {
      final userModel = await _remoteDatasource.signIn(email, password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDatasource.signOut();
    } catch (e) {
      throw Exception('فشل تسجيل الخروج: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _remoteDatasource.getCurrentFirebaseUser();
      if (firebaseUser == null) return null;

      final userModel = await _remoteDatasource.getUserData(firebaseUser.uid);
      return userModel?.toEntity();
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException && e.code == 'user-not-found') {
        return null;
      }
      throw Exception('فشل جلب بيانات المستخدم: ${e.toString()}');
    }
  }

  @override
  Stream<User?> authStateChanges() {
        return _remoteDatasource.authStateChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }
      return _remoteDatasource.getUserStream(firebaseUser.uid).map((userModel) {
        return userModel?.toEntity();
      });
    });
  }


  @override
  Future<bool> isUserVerified(String uid) async {
    try {
      final firebaseUser = _remoteDatasource.getCurrentFirebaseUser();
      if (firebaseUser != null && firebaseUser.emailVerified) {
        return true;
      }

      if (firebaseUser != null) {
        await firebaseUser.reload();
        final refreshedUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (refreshedUser?.emailVerified == true) {
          return true;
        }
      }

      return await _remoteDatasource.isCustomVerified(uid);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> markUserPendingVerification(String uid) async {
    try {
      await _remoteDatasource.markPendingVerification(uid);
    } catch (e) {
      throw Exception('فشل تسجيل طلب التحقق: ${e.toString()}');
    }
  }

  @override
  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    try {
      await _remoteDatasource.manuallyVerifyUser(uid, adminUid);
    } catch (e) {
      throw Exception('فشل التحقق اليدوي: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyWithCode(String uid, String code) async {
    try {
      await _remoteDatasource.verifyWithCode(uid, code);
    } catch (e) {
      throw Exception('رمز التحقق غير صحيح: ${e.toString()}');
    }
  }

  @override
  Future<String> generateVerificationCode(String uid) async {
    try {
      return await _remoteDatasource.generateVerificationCode(uid);
    } catch (e) {
      throw Exception('فشل توليد رمز التحقق: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCustomVerified(String uid) async {
    try {
      return await _remoteDatasource.isCustomVerified(uid);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _remoteDatasource.sendEmailVerification();
    } catch (e) {
      throw Exception('فشل إرسال بريد التحقق: ${e.toString()}');
    }
  }


  @override
  Future<User> register(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    try {
      final userModel = await _remoteDatasource.register(email, password, userData);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _remoteDatasource.resetPassword(email);
    } catch (e) {
      throw Exception('فشل إرسال رابط استعادة كلمة المرور: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw Exception('لا يوجد مستخدم مسجل الدخول');
      }
    } catch (e) {
      throw Exception('فشل تحديث كلمة المرور: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _remoteDatasource.updateProfile(uid, data);
    } catch (e) {
      throw Exception('فشل تحديث الملف الشخصي: ${e.toString()}');
    }
  }


  @override
  Stream<List<User>> getUnverifiedUsers() {
    return _remoteDatasource.getUnverifiedUsers().map((userModels) {
      return userModels.map((model) => model.toEntity()).toList();
    });
  }
}