// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAuth)
final firebaseAuthProvider = FirebaseAuthProvider._();

final class FirebaseAuthProvider extends $FunctionalProvider<
    firebase_auth.FirebaseAuth,
    firebase_auth.FirebaseAuth,
    firebase_auth.FirebaseAuth> with $Provider<firebase_auth.FirebaseAuth> {
  FirebaseAuthProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseAuthProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<firebase_auth.FirebaseAuth> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  firebase_auth.FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(firebase_auth.FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<firebase_auth.FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'e323ea70909ff25727135fa5deddbce7cd1e9c07';

@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider = FirebaseFirestoreProvider._();

final class FirebaseFirestoreProvider extends $FunctionalProvider<
    FirebaseFirestore,
    FirebaseFirestore,
    FirebaseFirestore> with $Provider<FirebaseFirestore> {
  FirebaseFirestoreProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseFirestoreProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseFirestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firebaseFirestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firebaseFirestoreHash() => r'963402713bf9b7cc1fb259d619d9b0184d4dcec1';

@ProviderFor(authRemoteDatasource)
final authRemoteDatasourceProvider = AuthRemoteDatasourceProvider._();

final class AuthRemoteDatasourceProvider extends $FunctionalProvider<
    AuthRemoteDatasource,
    AuthRemoteDatasource,
    AuthRemoteDatasource> with $Provider<AuthRemoteDatasource> {
  AuthRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRemoteDatasource create(Ref ref) {
    return authRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDatasource>(value),
    );
  }
}

String _$authRemoteDatasourceHash() =>
    r'ec117dd0aecbcbdb927dc8762e1a4ac75c9b14b9';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'760c6ac29ed6fd31096d96269c76109a0116547d';

@ProviderFor(signInUseCase)
final signInUseCaseProvider = SignInUseCaseProvider._();

final class SignInUseCaseProvider
    extends $FunctionalProvider<SignInUseCase, SignInUseCase, SignInUseCase>
    with $Provider<SignInUseCase> {
  SignInUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'signInUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$signInUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignInUseCase create(Ref ref) {
    return signInUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInUseCase>(value),
    );
  }
}

String _$signInUseCaseHash() => r'c6ac204cf3d8d14a9b5a14afd07c9c51c304a5c8';

@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = SignOutUseCaseProvider._();

final class SignOutUseCaseProvider
    extends $FunctionalProvider<SignOutUseCase, SignOutUseCase, SignOutUseCase>
    with $Provider<SignOutUseCase> {
  SignOutUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'signOutUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$signOutUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignOutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignOutUseCase create(Ref ref) {
    return signOutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutUseCase>(value),
    );
  }
}

String _$signOutUseCaseHash() => r'952ce342ca22dc7bb696cc8e5787d2889240ef98';

@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = GetCurrentUserUseCaseProvider._();

final class GetCurrentUserUseCaseProvider extends $FunctionalProvider<
    GetCurrentUserUseCase,
    GetCurrentUserUseCase,
    GetCurrentUserUseCase> with $Provider<GetCurrentUserUseCase> {
  GetCurrentUserUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getCurrentUserUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getCurrentUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentUserUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCurrentUserUseCase create(Ref ref) {
    return getCurrentUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentUserUseCase>(value),
    );
  }
}

String _$getCurrentUserUseCaseHash() =>
    r'4a27d130940e444424e46ed4afad7c5a5c8cf5b2';

@ProviderFor(manuallyVerifyUserUseCase)
final manuallyVerifyUserUseCaseProvider = ManuallyVerifyUserUseCaseProvider._();

final class ManuallyVerifyUserUseCaseProvider extends $FunctionalProvider<
    ManuallyVerifyUserUseCase,
    ManuallyVerifyUserUseCase,
    ManuallyVerifyUserUseCase> with $Provider<ManuallyVerifyUserUseCase> {
  ManuallyVerifyUserUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'manuallyVerifyUserUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$manuallyVerifyUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<ManuallyVerifyUserUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ManuallyVerifyUserUseCase create(Ref ref) {
    return manuallyVerifyUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManuallyVerifyUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManuallyVerifyUserUseCase>(value),
    );
  }
}

String _$manuallyVerifyUserUseCaseHash() =>
    r'c848fee988d27cc03f35460c3cf926a0d5b7dc2e';

@ProviderFor(verifyCodeUseCase)
final verifyCodeUseCaseProvider = VerifyCodeUseCaseProvider._();

final class VerifyCodeUseCaseProvider extends $FunctionalProvider<
    VerifyCodeUseCase,
    VerifyCodeUseCase,
    VerifyCodeUseCase> with $Provider<VerifyCodeUseCase> {
  VerifyCodeUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'verifyCodeUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$verifyCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifyCodeUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifyCodeUseCase create(Ref ref) {
    return verifyCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifyCodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifyCodeUseCase>(value),
    );
  }
}

String _$verifyCodeUseCaseHash() => r'4535ae2be5e93e81932b80816c9af37356f5d2cd';

@ProviderFor(generateVerificationCodeUseCase)
final generateVerificationCodeUseCaseProvider =
    GenerateVerificationCodeUseCaseProvider._();

final class GenerateVerificationCodeUseCaseProvider extends $FunctionalProvider<
        GenerateVerificationCodeUseCase,
        GenerateVerificationCodeUseCase,
        GenerateVerificationCodeUseCase>
    with $Provider<GenerateVerificationCodeUseCase> {
  GenerateVerificationCodeUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generateVerificationCodeUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generateVerificationCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<GenerateVerificationCodeUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenerateVerificationCodeUseCase create(Ref ref) {
    return generateVerificationCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerateVerificationCodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<GenerateVerificationCodeUseCase>(value),
    );
  }
}

String _$generateVerificationCodeUseCaseHash() =>
    r'e3b61242f58a665f822355cbc9043960e9837399';

@ProviderFor(registerUseCase)
final registerUseCaseProvider = RegisterUseCaseProvider._();

final class RegisterUseCaseProvider extends $FunctionalProvider<RegisterUseCase,
    RegisterUseCase, RegisterUseCase> with $Provider<RegisterUseCase> {
  RegisterUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegisterUseCase create(Ref ref) {
    return registerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUseCase>(value),
    );
  }
}

String _$registerUseCaseHash() => r'0f1f842bd5399c007cd5e8089bff9c56ec0c7618';

@ProviderFor(updateProfileUseCase)
final updateProfileUseCaseProvider = UpdateProfileUseCaseProvider._();

final class UpdateProfileUseCaseProvider extends $FunctionalProvider<
    UpdateProfileUseCase,
    UpdateProfileUseCase,
    UpdateProfileUseCase> with $Provider<UpdateProfileUseCase> {
  UpdateProfileUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateProfileUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProfileUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateProfileUseCase create(Ref ref) {
    return updateProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfileUseCase>(value),
    );
  }
}

String _$updateProfileUseCaseHash() =>
    r'924ba9735cc7d1efbeb4e7b50b2cbad7fadfe7ab';

/// Authentication state notifier

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Authentication state notifier
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, AppUser?> {
  /// Authentication state notifier
  AuthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'39390df4cf6420d0e8145f96505c599267c18a7a';

/// Authentication state notifier

abstract class _$AuthNotifier extends $AsyncNotifier<AppUser?> {
  FutureOr<AppUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
        AsyncValue<AppUser?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Stream of unverified users (admin)

@ProviderFor(unverifiedUsers)
final unverifiedUsersProvider = UnverifiedUsersProvider._();

/// Stream of unverified users (admin)

final class UnverifiedUsersProvider extends $FunctionalProvider<
        AsyncValue<List<AppUser>>, List<AppUser>, Stream<List<AppUser>>>
    with $FutureModifier<List<AppUser>>, $StreamProvider<List<AppUser>> {
  /// Stream of unverified users (admin)
  UnverifiedUsersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unverifiedUsersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unverifiedUsersHash();

  @$internal
  @override
  $StreamProviderElement<List<AppUser>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<AppUser>> create(Ref ref) {
    return unverifiedUsers(ref);
  }
}

String _$unverifiedUsersHash() => r'b7ddea8066cdb3a5a6ba9e524e4a6fefa613c85c';

/// Current user provider (convenience)

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Current user provider (convenience)

final class CurrentUserProvider
    extends $FunctionalProvider<AppUser?, AppUser?, AppUser?>
    with $Provider<AppUser?> {
  /// Current user provider (convenience)
  CurrentUserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentUserProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppUser? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUser?>(value),
    );
  }
}

String _$currentUserHash() => r'066f03b83942d663e7abac349aa53fd6b76bb18e';

/// Is user authenticated provider

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Is user authenticated provider

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Is user authenticated provider
  IsAuthenticatedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isAuthenticatedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'ec341d95b490bda54e8278477e26f7b345844931';

/// Is user verified provider

@ProviderFor(isUserVerified)
final isUserVerifiedProvider = IsUserVerifiedProvider._();

/// Is user verified provider

final class IsUserVerifiedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Is user verified provider
  IsUserVerifiedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isUserVerifiedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isUserVerifiedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isUserVerified(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isUserVerifiedHash() => r'7104f9cbb7d39f308d63f75d211c9581b328346d';
