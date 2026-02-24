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

typedef AppUser = domain.User;

// ============================================================================
// INFRASTRUCTURE PROVIDERS (Firebase instances)
// ============================================================================

@riverpod
firebase_auth.FirebaseAuth firebaseAuth(Ref ref) {
  return firebase_auth.FirebaseAuth.instance;
}

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

/// Authentication state notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AppUser?> build() async {
    // Listen to auth state changes
    final repository = ref.watch(authRepositoryProvider);
    final crypto = ref.watch(encryptionServiceProvider);

    // Subscribe to auth state stream
    final subscription = repository.authStateChanges().listen((user) async {
      if (user != null) {
        if (!(await crypto.hasKeys())) {
          final pubKey = await crypto.generateAndStoreKeys();
          await repository.updateProfile(user.uid, {'publicKey': pubKey});
        }
      }
      state = AsyncValue.data(user);
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      subscription.cancel();
    });

    // Return current user
    return await repository.getCurrentUser();
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(signInUseCaseProvider);
      return await useCase(email, password);
    });
  }

  /// Register new user
  Future<void> register(String email, String password, Map<String, dynamic> userData) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(registerUseCaseProvider);
      return await useCase(email, password, userData);
    });
  }

  /// Update user profile
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    final useCase = ref.read(updateProfileUseCaseProvider);
    await useCase(uid, data);
    
    // Refresh current user state from repository
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final crypto = ref.read(encryptionServiceProvider);
      await crypto.clearKeys();
      
      final useCase = ref.read(signOutUseCaseProvider);
      await useCase();
      return null;
    });
  }

  /// Manually verify user (admin only)
  Future<void> manuallyVerifyUser(String uid, String adminUid) async {
    final useCase = ref.read(manuallyVerifyUserUseCaseProvider);
    await useCase.call(uid, adminUid);

    // Refresh current user state
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Verify user with code
  Future<void> verifyWithCode(String uid, String code) async {
    final useCase = ref.read(verifyCodeUseCaseProvider);
    await useCase(uid, code);

    // Refresh current user state
    final repository = ref.read(authRepositoryProvider);
    final updatedUser = await repository.getCurrentUser();
    state = AsyncValue.data(updatedUser);
  }

  /// Generate verification code (admin only)
  Future<String> generateVerificationCode(String uid) async {
    final useCase = ref.read(generateVerificationCodeUseCaseProvider);
    return await useCase(uid);
  }
}

/// Stream of unverified users (admin)
@riverpod
Stream<List<AppUser>> unverifiedUsers(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getUnverifiedUsers();
}

/// Current user provider (convenience)
@riverpod
AppUser? currentUser(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.value;
}

/// Is user authenticated provider
@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Is user verified provider
@riverpod
bool isUserVerified(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  return user.isVerified;
}
