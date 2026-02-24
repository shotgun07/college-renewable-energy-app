import '../entities/user.dart';
import '../../core/errors/auth_exceptions.dart';

/// Repository interface for authentication operations
/// This is implemented in the data layer
abstract class AuthRepository {
  /// Sign in with email and password
  /// Throws [AuthException] on failure
  Future<User> signIn(String email, String password);

  /// Sign out current user
  Future<void> signOut();

  /// Get current authenticated user
  /// Returns null if not authenticated
  Future<User?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<User?> authStateChanges();

  /// Check if user is verified (email or custom)
  Future<bool> isUserVerified(String uid);

  /// Mark user as pending verification in Firestore
  Future<void> markUserPendingVerification(String uid);

  /// Manually verify user (admin only)
  Future<void> manuallyVerifyUser(String uid, String adminUid);

  /// Verify user with 6-digit code
  Future<void> verifyWithCode(String uid, String code);

  /// Generate verification code for user (admin/system)
  /// Returns the generated code
  Future<String> generateVerificationCode(String uid);

  /// Check custom verification status from Firestore
  Future<bool> isCustomVerified(String uid);

  /// Send email verification (may not work on free tier)
  Future<void> sendEmailVerification();

  /// Register new user
  Future<User> register(
      String email, String password, Map<String, dynamic> userData);

  /// Reset password
  Future<void> resetPassword(String email);

  /// Update user profile
  Future<void> updateProfile(String uid, Map<String, dynamic> data);

  /// Get list of unverified users (admin)
  Stream<List<User>> getUnverifiedUsers();
}
