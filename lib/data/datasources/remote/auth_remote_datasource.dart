import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../../../core/errors/auth_exceptions.dart';

/// Remote datasource for authentication using Firebase
class AuthRemoteDatasource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDatasource({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw UserNotFoundException();
      }

      // Fetch user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw UserDataNotFoundException();
      }

      // Mark as pending verification if not verified (DISABLED temporarily)
      /*
      if (!user.emailVerified) {
        await _markPendingVerification(user.uid, userDoc.data());
      }
      */

      return UserModel.fromFirestore(userDoc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw NetworkException('حدث خطأ في الاتصال: ${e.toString()}');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('فشل تسجيل الخروج: ${e.toString()}');
    }
  }

  /// Get current Firebase user
  firebase_auth.User? getCurrentFirebaseUser() {
    return _auth.currentUser;
  }

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw AuthException('فشل جلب بيانات المستخدم: ${e.toString()}');
    }
  }

  /// Stream of user data from Firestore
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Stream of unverified users
  Stream<List<UserModel>> getUnverifiedUsers() {
    return _firestore
        .collection('users')
        .where('requiresVerification', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  /// Stream of auth state changes

  /// Stream of auth state changes
  Stream<firebase_auth.User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Check custom verification from Firestore
  Future<bool> isCustomVerified(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      return data?['customVerified'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Mark user as pending verification
  Future<void> markPendingVerification(String uid) async {
    try {
      final userDoc = _firestore.collection('users').doc(uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        throw UserDataNotFoundException();
      }

      await _markPendingVerification(uid, docSnapshot.data());
    } catch (e) {
      // Log but don't fail
      if (kDebugMode) print('Error marking pending verification: $e');
    }
  }

  /// Private helper to mark pending verification
  Future<void> _markPendingVerification(
      String uid, Map<String, dynamic>? data) async {
    if (data == null) return;

    final isCustomVerified = data['customVerified'] == true;
    if (isCustomVerified) return; // Already verified

    await _firestore.collection('users').doc(uid).update({
      'emailVerified': _auth.currentUser?.emailVerified ?? false,
      'customVerified': false,
      'requiresVerification': true,
      'lastLogin': FieldValue.serverTimestamp(),
      if (data['verificationRequestedAt'] == null)
        'verificationRequestedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Manually verify user (admin only)
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

  /// Verify user with 6-digit code
  Future<void> verifyWithCode(String uid, String code) async {
    try {
      final doc =
          await _firestore.collection('pending_verifications').doc(uid).get();
      if (!doc.exists) {
        throw AuthException('لم يتم العثور على رمز تحقق لهذا المستخدم');
      }

      final data = doc.data();
      if (data == null) throw AuthException('بيانات غير صالحة');

      final savedCode = data['code'];
      // timestamps are good to check for expiration if needed

      if (savedCode != code) {
        throw AuthException('رمز التحقق غير صحيح');
      }

      // Verify User
      await _firestore.collection('users').doc(uid).update({
        'customVerified': true,
        'requiresVerification': false,
        'verifiedAt': FieldValue.serverTimestamp(),
        'verificationMethod': 'code',
      });

      // Delete pending verification
      await _firestore.collection('pending_verifications').doc(uid).delete();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('فشل التحقق من الرمز: ${e.toString()}');
    }
  }

  /// Generate verification code
  Future<String> generateVerificationCode(String uid) async {
    try {
      // Generate 6 digit random code
      final code =
          (100000 + DateTime.now().microsecondsSinceEpoch % 899999).toString();

      await _firestore.collection('pending_verifications').doc(uid).set({
        'uid': uid,
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return code;
    } catch (e) {
      throw AuthException('فشل إنشاء رمز التحقق: ${e.toString()}');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException('لا يوجد مستخدم مسجل');
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw AuthException('فشل إرسال رسالة التحقق: ${e.toString()}');
    }
  }

  /// Register new user
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
      if (user == null) {
        throw AuthException('فشل إنشاء الحساب');
      }

      // Create user document
      await _firestore.collection('users').doc(user.uid).set({
        ...userData,
        'uid': user.uid,
        'email': email.trim(),
        'emailVerified': true, // Changed from false
        'customVerified': true, // Changed from false
        'requiresVerification': false, // Changed from true
        'verificationRequestedAt': FieldValue.serverTimestamp(),
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

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw NetworkException(
          'فشل إرسال رابط إعادة تعيين كلمة المرور: ${e.toString()}');
    }
  }

  /// Update user profile in Firestore
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw AuthException('فشل تحديث الملف الشخصي: ${e.toString()}');
    }
  }

  /// Handle Firebase Auth exceptions
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
