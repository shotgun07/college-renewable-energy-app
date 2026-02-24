import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/errors/auth_exceptions.dart';

/// Enhanced authentication service with verification bypass and comprehensive error handling
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sign in with email and password (with verification bypass)
  /// This allows unverified users to login and marks them for verification reminders
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Mark user as pending verification if not verified (DISABLED temporarily)
      /*
      if (!credential.user!.emailVerified) {
        await markUserPendingVerification(credential.user!);
      }
      */

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw NetworkException('حدث خطأ في الاتصال: ${e.toString()}');
    }
  }

  /// Mark user as pending verification in Firestore
  /// This sets flags to show verification reminders
  Future<void> markUserPendingVerification(User user) async {
    try {
      final userDoc = _db.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        throw UserDataNotFoundException();
      }

      final data = docSnapshot.data()!;
      final isCustomVerified = data['customVerified'] == true;

      // Only update if not already custom verified
      if (!isCustomVerified) {
        await userDoc.update({
          'emailVerified': user.emailVerified,
          'customVerified': false,
          'requiresVerification': true,
          'lastLogin': FieldValue.serverTimestamp(),
          if (data['verificationRequestedAt'] == null)
            'verificationRequestedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Log error but don't prevent login
      if (kDebugMode) print('Error marking user pending verification: $e');
    }
  }

  /// Admin can manually verify a user
  /// This sets the customVerified flag and records who verified them
  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    try {
      await _db.collection('users').doc(uid).update({
        'customVerified': true,
        'requiresVerification': false,
        'verifiedBy': adminUid,
        'verifiedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException('فشل في التحقق من المستخدم: ${e.toString()}');
    }
  }

  /// Check if user is custom verified (in Firestore)
  Future<bool> isCustomVerified(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) {
        return false;
      }
      return doc.data()?['customVerified'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is verified (either Firebase or custom)
  Future<bool> isVerified(String uid) async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }

    // Check Firebase email verification
    await user.reload();
    if (_auth.currentUser!.emailVerified) {
      return true;
    }

    // Check custom verification
    return await isCustomVerified(uid);
  }

  /// Get user data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return _db.collection('users').doc(uid).get();
  }

  /// Sign out current user
  Future<void> signOut() => _auth.signOut();

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw NetworkException();
    }
  }

  /// Update email and send verification (Optional feature - requires Blaze plan)
  /// Kept for future use when upgrading to paid plan
  Future<void> updateAndSendEmailVerification(String email) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException('لا يوجد مستخدم مسجل دخول');
    }

    try {
      await user.verifyBeforeUpdateEmail(email.trim());
      await _db
          .collection('users')
          .doc(user.uid)
          .update({'email': email.trim()});
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Send email verification (Optional - requires Blaze plan)
  /// Kept for future use when upgrading to paid plan
  Future<void> sendEmailVerificationOnly() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        // Fail silently - verification is optional with our bypass
        if (kDebugMode) {
          print('Email verification send failed (may require Blaze plan): $e');
        }
      }
    }
  }

  /// Check Firebase email verified status
  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return _auth.currentUser!.emailVerified;
    }
    return false;
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Handle Firebase Auth exceptions and convert to custom exceptions
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return InvalidCredentialsException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'user-disabled':
        return AccountDisabledException();
      case 'weak-password':
        return WeakPasswordException();
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'requires-recent-login':
        return RequiresRecentLoginException();
      case 'too-many-requests':
        return TooManyRequestsException();
      case 'network-request-failed':
        return NetworkException();
      default:
        return AuthException(
          e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }
}
