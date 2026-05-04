import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../../../core/errors/auth_exceptions.dart';

class AuthRemoteDatasource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDatasource({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;


  Future<UserModel> signIn(String email, String password) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        final user = credential.user;
        if (user == null) throw UserNotFoundException();

        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get()
            .timeout(const Duration(seconds: 10));

        if (!userDoc.exists) {
          throw UserDataNotFoundException(
            'بيانات المستخدم غير موجودة في مجموعة "users". يرجى مراجعة المشرف.',
          );
        }

        return UserModel.fromFirestore(userDoc);
      } on firebase_auth.FirebaseAuthException catch (e) {
        throw _handleFirebaseAuthException(e);
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          if (retries > 1) {
            retries--;
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          throw NetworkException(
            'تعذر الاتصال بقاعدة البيانات (unavailable). يرجى التحقق من الشبكة.',
          );
        }
        throw AuthException('خطأ في قاعدة البيانات: ${e.message}');
      } catch (e) {
        if (e is AuthException) rethrow;
        throw NetworkException('حدث خطأ في الاتصال: ${e.toString()}');
      }
    }
    throw NetworkException('انتهت مهلة الاتصال بالخادم. يرجى المحاولة لاحقاً.');
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('فشل تسجيل الخروج: ${e.toString()}');
    }
  }

  firebase_auth.User? getCurrentFirebaseUser() => _auth.currentUser;


  Future<UserModel?> getUserData(String uid) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final doc = await _firestore
            .collection('users')
            .doc(uid)
            .get()
            .timeout(const Duration(seconds: 10));
        if (!doc.exists) return null;
        return UserModel.fromFirestore(doc);
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          if (retries > 1) {
            retries--;
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          throw NetworkException(
            'تعذر الاتصال بقاعدة البيانات (unavailable). يرجى التحقق من الشبكة.',
          );
        }
        throw AuthException('فشل جلب بيانات المستخدم: ${e.message}');
      } catch (e) {
        throw AuthException('فشل جلب بيانات المستخدم: ${e.toString()}');
      }
    }
    return null;
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .handleError((error) {
          if (kDebugMode) debugPrint('Error in getUserStream: $error');
        })
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  Stream<firebase_auth.User?> authStateChanges() => _auth.authStateChanges();


  Future<bool> isCustomVerified(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['customVerified'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> markPendingVerification(String uid) async {
    try {
      final userDoc = _firestore.collection('users').doc(uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) throw UserDataNotFoundException();

      final data = docSnapshot.data();
      if (data == null) return;

      final isCustomVerified = data['customVerified'] == true;
      if (isCustomVerified) return; // Already verified

      await userDoc.update({
        'emailVerified': _auth.currentUser?.emailVerified ?? false,
        'customVerified': false,
        'requiresVerification': true,
        'lastLogin': FieldValue.serverTimestamp(),
        if (data['verificationRequestedAt'] == null)
          'verificationRequestedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error marking pending verification: $e');
    }
  }

  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'customVerified': true,
        'requiresVerification': false,
        'verifiedBy': adminUid,
        'verifiedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException('فشل التحقق من المستخدم: ${e.toString()}');
    }
  }

  Future<void> verifyWithCode(String uid, String code) async {
    try {
      final doc = await _firestore
          .collection('pending_verifications')
          .doc(uid)
          .get();
      if (!doc.exists) throw AuthException('لم يتم العثور على رمز تحقق لهذا المستخدم');

      final data = doc.data();
      if (data == null) throw AuthException('بيانات غير صالحة');

      final savedCode = data['code'];
      final expiresAt = data['expiresAt'] as Timestamp?;

      if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
        throw AuthException('انتهت صلاحية رمز التحقق');
      }

      if (savedCode != code) throw AuthException('رمز التحقق غير صحيح');

      await _firestore.collection('users').doc(uid).update({
        'customVerified': true,
        'requiresVerification': false,
        'verifiedAt': FieldValue.serverTimestamp(),
        'verificationMethod': 'code',
      });

      await _firestore.collection('pending_verifications').doc(uid).delete();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('فشل التحقق من الرمز: ${e.toString()}');
    }
  }

  Future<String> generateVerificationCode(String uid) async {
    try {
      final rng = Random.secure();
      final code = (100000 + rng.nextInt(900000)).toString();

      await _firestore.collection('pending_verifications').doc(uid).set({
        'uid': uid,
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 1))),
      });

      return code;
    } catch (e) {
      throw AuthException('فشل إنشاء رمز التحقق: ${e.toString()}');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException('لا يوجد مستخدم مسجل');
      await user.sendEmailVerification();
    } catch (e) {
      throw AuthException('فشل إرسال رسالة التحقق: ${e.toString()}');
    }
  }


  Future<UserModel> register(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) throw AuthException('فشل إنشاء الحساب');

      await _firestore.collection('users').doc(user.uid).set({
        ...userData,
        'uid': user.uid,
        'email': email.trim(),
        'emailVerified': false,        
        'customVerified': false,        
        'requiresVerification': true,  
        'verificationRequestedAt': null, 
        'lastLogin': FieldValue.serverTimestamp(),
      });

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirestore(userDoc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw NetworkException('حدث خطأ في الاتصال: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw NetworkException(
        'فشل إرسال رابط إعادة تعيين كلمة المرور: ${e.toString()}',
      );
    }
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw AuthException('فشل تحديث الملف الشخصي: ${e.toString()}');
    }
  }


  Stream<List<UserModel>> getUnverifiedUsers() {
    return _firestore
        .collection('users')
        .where('requiresVerification', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }


  AuthException _handleFirebaseAuthException(
      firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return InvalidCredentialsException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'weak-password':
        return WeakPasswordException();
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'user-disabled':
        return AccountDisabledException();
      case 'requires-recent-login':
        return RequiresRecentLoginException();
      case 'too-many-requests':
        return TooManyRequestsException();
      case 'network-request-failed':
        return NetworkException('فشل الاتصال بالشبكة');
      default:
        return AuthException(
          e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }
}