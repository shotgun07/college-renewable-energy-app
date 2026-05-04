import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/manually_verify_user_usecase.dart';
import '../../domain/usecases/auth/verify_code_usecase.dart';
import '../../domain/usecases/auth/generate_verification_code_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/update_profile_usecase.dart';
import '../../domain/entities/user.dart' as domain;

import 'security_provider.dart';

part 'auth_provider.g.dart';

// Type alias for domain User to avoid conflict with firebase_auth.User
typedef AppUser = domain.User;

// ============================================================================
// INFRASTRUCTURE PROVIDERS (Firebase instances)
// ============================================================================

/// Firebase Auth instance provider.
/// Use this to get the FirebaseAuth instance.
@riverpod
firebase_auth.FirebaseAuth firebaseAuth(Ref ref) {
  return firebase_auth.FirebaseAuth.instance;
}

/// Firebase Firestore instance provider.
@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

// ============================================================================
// DATASOURCE LAYER
// ============================================================================

@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) {
  return AuthRemoteDatasource(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

// ============================================================================
// REPOSITORY LAYER
// ============================================================================

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
  );
}

// ============================================================================
// USECASE LAYER
// ============================================================================

@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
ManuallyVerifyUserUseCase manuallyVerifyUserUseCase(Ref ref) {
  return ManuallyVerifyUserUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
VerifyCodeUseCase verifyCodeUseCase(Ref ref) {
  return VerifyCodeUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GenerateVerificationCodeUseCase generateVerificationCodeUseCase(Ref ref) {
  return GenerateVerificationCodeUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
}

// ============================================================================
// STATE MANAGEMENT (UI LAYER)
// ============================================================================

/// Authentication state notifier.
/// 
/// Handles user authentication state, including sign-in, registration,
/// verification, and profile updates. Listens to Firebase auth state changes
/// and automatically updates the state. Also ensures that each user has an
/// RSA key pair for E2EE upon first login.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AppUser?> build() async {
    // Listen to Firebase auth state changes
    final repository = ref.watch(authRepositoryProvider);
    final crypto = ref.watch(encryptionServiceProvider);

    // Subscribe to auth state stream
    final subscription = repository.authStateChanges().listen((user) async {
      if (user != null) {
        // Ensure the user has an RSA key pair for E2EE
        if (!(await crypto.hasKeys())) {
          final pubKey = await crypto.generateAndStoreKeys();
          await repository.updateProfile(user.uid, {'publicKey': pubKey});
        }
      }
      // Update the state with the new user
      state = AsyncValue.data(user);
    });

    // Cancel subscription when this provider is disposed
    ref.onDispose(() {
      subscription.cancel();
    });

    // Return the current user (synchronous part)
    return await repository.getCurrentUser();
  }

  /// Sign in with email and password.
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(signInUseCaseProvider)(email, password);
      // The state will be updated by the stream subscription in build()
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Register a new user.
  Future<void> register(String email, String password, Map<String, dynamic> userData) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(registerUseCaseProvider)(email, password, userData);
      // State will be updated by the stream
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update user profile.
  /// After updating, the state is refreshed with the latest user data.
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    final useCase = ref.read(updateProfileUseCaseProvider);
    await useCase(uid, data);

    // Fetch the updated user directly from the repository
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Update password.
  Future<void> updatePassword(String newPassword) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.updatePassword(newPassword);
  }

  /// Reset password.
  Future<void> resetPassword(String email) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.resetPassword(email);
  }

  /// Send email verification.
  Future<void> sendEmailVerification() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.sendEmailVerification();
  }

  /// Check email verification.
  Future<bool> checkEmailVerification() async {
    final user = state.value;
    if (user == null) return false;
    final repository = ref.read(authRepositoryProvider);
    final isVerified = await repository.isUserVerified(user.uid);
    if (isVerified && !user.isVerified) {
      final updatedUser = await repository.getCurrentUser();
      state = AsyncValue.data(updatedUser);
    }
    return isVerified;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      // Clear local encryption keys
      final crypto = ref.read(encryptionServiceProvider);
      await crypto.clearKeys();

      await ref.read(signOutUseCaseProvider)();
      // The stream will set state to null automatically
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Manually verify a user (admin only).
  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    final useCase = ref.read(manuallyVerifyUserUseCaseProvider);
    await useCase.call(uid, adminUid);

    // Refresh current user state
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Verify a user with a generated code.
  Future<void> verifyWithCode(String uid, String code) async {
    final useCase = ref.read(verifyCodeUseCaseProvider);
    await useCase(uid, code);

    // Refresh current user state
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Generate a verification code for a user (admin only).
  Future<String> generateVerificationCode(String uid) async {
    final useCase = ref.read(generateVerificationCodeUseCaseProvider);
    return await useCase(uid);
  }
}

/// Stream of unverified users for admin use.
@riverpod
Stream<List<AppUser>> unverifiedUsers(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getUnverifiedUsers();
}

/// Convenience provider that returns the current user, or null if not logged in.
@riverpod
AppUser? currentUser(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.value;
}

/// Whether the user is authenticated (logged in).
@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Whether the current user is verified (email or admin verification).
@riverpod
bool isUserVerified(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  return user.isVerified;
}
