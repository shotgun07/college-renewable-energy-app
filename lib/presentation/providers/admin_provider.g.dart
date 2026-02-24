// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRemoteDatasource)
final adminRemoteDatasourceProvider = AdminRemoteDatasourceProvider._();

final class AdminRemoteDatasourceProvider extends $FunctionalProvider<
    AdminRemoteDatasource,
    AdminRemoteDatasource,
    AdminRemoteDatasource> with $Provider<AdminRemoteDatasource> {
  AdminRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AdminRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminRemoteDatasource create(Ref ref) {
    return adminRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRemoteDatasource>(value),
    );
  }
}

String _$adminRemoteDatasourceHash() =>
    r'677f830aed841ebb51581500b4983b02553a6f34';

@ProviderFor(adminRepository)
final adminRepositoryProvider = AdminRepositoryProvider._();

final class AdminRepositoryProvider extends $FunctionalProvider<AdminRepository,
    AdminRepository, AdminRepository> with $Provider<AdminRepository> {
  AdminRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminRepository create(Ref ref) {
    return adminRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRepository>(value),
    );
  }
}

String _$adminRepositoryHash() => r'5d0a8c1f7ffba845ab22c2d0c009788c39587890';

@ProviderFor(studentsStream)
final studentsStreamProvider = StudentsStreamProvider._();

final class StudentsStreamProvider extends $FunctionalProvider<
        AsyncValue<List<User>>, List<User>, Stream<List<User>>>
    with $FutureModifier<List<User>>, $StreamProvider<List<User>> {
  StudentsStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'studentsStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$studentsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<User>> create(Ref ref) {
    return studentsStream(ref);
  }
}

String _$studentsStreamHash() => r'0bfdf09de09209cc218960c18eb94fc07dedad57';

@ProviderFor(teachersByKey)
final teachersByKeyProvider = TeachersByKeyFamily._();

final class TeachersByKeyProvider extends $FunctionalProvider<
        AsyncValue<List<User>>, List<User>, Stream<List<User>>>
    with $FutureModifier<List<User>>, $StreamProvider<List<User>> {
  TeachersByKeyProvider._(
      {required TeachersByKeyFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'teachersByKeyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$teachersByKeyHash();

  @override
  String toString() {
    return r'teachersByKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<User>> create(Ref ref) {
    final argument = this.argument as String;
    return teachersByKey(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TeachersByKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teachersByKeyHash() => r'2418d38226eda5dce615b50c6afb2f3edbc70af7';

final class TeachersByKeyFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<User>>, String> {
  TeachersByKeyFamily._()
      : super(
          retry: null,
          name: r'teachersByKeyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TeachersByKeyProvider call(
    String key,
  ) =>
      TeachersByKeyProvider._(argument: key, from: this);

  @override
  String toString() => r'teachersByKeyProvider';
}
