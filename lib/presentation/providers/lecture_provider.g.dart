// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lectureRemoteDatasource)
final lectureRemoteDatasourceProvider = LectureRemoteDatasourceProvider._();

final class LectureRemoteDatasourceProvider extends $FunctionalProvider<
    LectureRemoteDatasource,
    LectureRemoteDatasource,
    LectureRemoteDatasource> with $Provider<LectureRemoteDatasource> {
  LectureRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lectureRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lectureRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<LectureRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LectureRemoteDatasource create(Ref ref) {
    return lectureRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LectureRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LectureRemoteDatasource>(value),
    );
  }
}

String _$lectureRemoteDatasourceHash() =>
    r'83a9d4595a7d962bf2dfa3d882a39de5e6152fa5';

@ProviderFor(lectureRepository)
final lectureRepositoryProvider = LectureRepositoryProvider._();

final class LectureRepositoryProvider extends $FunctionalProvider<
    LectureRepository,
    LectureRepository,
    LectureRepository> with $Provider<LectureRepository> {
  LectureRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lectureRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lectureRepositoryHash();

  @$internal
  @override
  $ProviderElement<LectureRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LectureRepository create(Ref ref) {
    return lectureRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LectureRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LectureRepository>(value),
    );
  }
}

String _$lectureRepositoryHash() => r'740307afdfc5670077ade6e09e7ec6e08fdd497e';

@ProviderFor(addLectureUseCase)
final addLectureUseCaseProvider = AddLectureUseCaseProvider._();

final class AddLectureUseCaseProvider extends $FunctionalProvider<
    AddLectureUseCase,
    AddLectureUseCase,
    AddLectureUseCase> with $Provider<AddLectureUseCase> {
  AddLectureUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addLectureUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addLectureUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddLectureUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddLectureUseCase create(Ref ref) {
    return addLectureUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddLectureUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddLectureUseCase>(value),
    );
  }
}

String _$addLectureUseCaseHash() => r'2c8ba43bbd945095677ac8623de024c9e92c7380';

@ProviderFor(getLecturesForStudentUseCase)
final getLecturesForStudentUseCaseProvider =
    GetLecturesForStudentUseCaseProvider._();

final class GetLecturesForStudentUseCaseProvider extends $FunctionalProvider<
    GetLecturesForStudentUseCase,
    GetLecturesForStudentUseCase,
    GetLecturesForStudentUseCase> with $Provider<GetLecturesForStudentUseCase> {
  GetLecturesForStudentUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getLecturesForStudentUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getLecturesForStudentUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLecturesForStudentUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetLecturesForStudentUseCase create(Ref ref) {
    return getLecturesForStudentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLecturesForStudentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetLecturesForStudentUseCase>(value),
    );
  }
}

String _$getLecturesForStudentUseCaseHash() =>
    r'131543fa030681cdfc4766930c64206e33adc4b4';

@ProviderFor(lecturesForStudent)
final lecturesForStudentProvider = LecturesForStudentFamily._();

final class LecturesForStudentProvider extends $FunctionalProvider<
        AsyncValue<List<Lecture>>, List<Lecture>, Stream<List<Lecture>>>
    with $FutureModifier<List<Lecture>>, $StreamProvider<List<Lecture>> {
  LecturesForStudentProvider._(
      {required LecturesForStudentFamily super.from,
      required (
        String,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'lecturesForStudentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lecturesForStudentHash();

  @override
  String toString() {
    return r'lecturesForStudentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Lecture>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Lecture>> create(Ref ref) {
    final argument = this.argument as (
      String,
      int,
    );
    return lecturesForStudent(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LecturesForStudentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lecturesForStudentHash() =>
    r'71248890c1cae867766558a8b8d2bb4c517b8825';

final class LecturesForStudentFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<Lecture>>,
            (
              String,
              int,
            )> {
  LecturesForStudentFamily._()
      : super(
          retry: null,
          name: r'lecturesForStudentProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LecturesForStudentProvider call(
    String department,
    int semester,
  ) =>
      LecturesForStudentProvider._(argument: (
        department,
        semester,
      ), from: this);

  @override
  String toString() => r'lecturesForStudentProvider';
}

@ProviderFor(lecturesByTeacher)
final lecturesByTeacherProvider = LecturesByTeacherFamily._();

final class LecturesByTeacherProvider extends $FunctionalProvider<
        AsyncValue<List<Lecture>>, List<Lecture>, Stream<List<Lecture>>>
    with $FutureModifier<List<Lecture>>, $StreamProvider<List<Lecture>> {
  LecturesByTeacherProvider._(
      {required LecturesByTeacherFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'lecturesByTeacherProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lecturesByTeacherHash();

  @override
  String toString() {
    return r'lecturesByTeacherProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Lecture>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Lecture>> create(Ref ref) {
    final argument = this.argument as String;
    return lecturesByTeacher(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LecturesByTeacherProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lecturesByTeacherHash() => r'08169b40f6bb494bd953a78aac5a8e71ff962012';

final class LecturesByTeacherFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Lecture>>, String> {
  LecturesByTeacherFamily._()
      : super(
          retry: null,
          name: r'lecturesByTeacherProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LecturesByTeacherProvider call(
    String teacherId,
  ) =>
      LecturesByTeacherProvider._(argument: teacherId, from: this);

  @override
  String toString() => r'lecturesByTeacherProvider';
}
