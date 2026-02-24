// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseRemoteDatasource)
final courseRemoteDatasourceProvider = CourseRemoteDatasourceProvider._();

final class CourseRemoteDatasourceProvider extends $FunctionalProvider<
    CourseRemoteDatasource,
    CourseRemoteDatasource,
    CourseRemoteDatasource> with $Provider<CourseRemoteDatasource> {
  CourseRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'courseRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$courseRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<CourseRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseRemoteDatasource create(Ref ref) {
    return courseRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseRemoteDatasource>(value),
    );
  }
}

String _$courseRemoteDatasourceHash() =>
    r'4fb7470c75da236de0de9d6715ebd76ed2c04f15';

@ProviderFor(courseRepository)
final courseRepositoryProvider = CourseRepositoryProvider._();

final class CourseRepositoryProvider extends $FunctionalProvider<
    CourseRepository,
    CourseRepository,
    CourseRepository> with $Provider<CourseRepository> {
  CourseRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'courseRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$courseRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseRepository create(Ref ref) {
    return courseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseRepository>(value),
    );
  }
}

String _$courseRepositoryHash() => r'6794dfcd2145a0b8dc34a85c824b264dccb36f78';

@ProviderFor(coursesStream)
final coursesStreamProvider = CoursesStreamProvider._();

final class CoursesStreamProvider extends $FunctionalProvider<
        AsyncValue<List<Course>>, List<Course>, Stream<List<Course>>>
    with $FutureModifier<List<Course>>, $StreamProvider<List<Course>> {
  CoursesStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'coursesStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coursesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Course>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Course>> create(Ref ref) {
    return coursesStream(ref);
  }
}

String _$coursesStreamHash() => r'd4389d50a36e7c9b2e7add7f084908c97ebc95be';

@ProviderFor(coursesByDeptSemester)
final coursesByDeptSemesterProvider = CoursesByDeptSemesterFamily._();

final class CoursesByDeptSemesterProvider extends $FunctionalProvider<
        AsyncValue<List<Course>>, List<Course>, Stream<List<Course>>>
    with $FutureModifier<List<Course>>, $StreamProvider<List<Course>> {
  CoursesByDeptSemesterProvider._(
      {required CoursesByDeptSemesterFamily super.from,
      required (
        String,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'coursesByDeptSemesterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coursesByDeptSemesterHash();

  @override
  String toString() {
    return r'coursesByDeptSemesterProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Course>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Course>> create(Ref ref) {
    final argument = this.argument as (
      String,
      int,
    );
    return coursesByDeptSemester(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoursesByDeptSemesterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coursesByDeptSemesterHash() =>
    r'cbaec2aa1d121c424aa9587d375bba388e1dc9ae';

final class CoursesByDeptSemesterFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<Course>>,
            (
              String,
              int,
            )> {
  CoursesByDeptSemesterFamily._()
      : super(
          retry: null,
          name: r'coursesByDeptSemesterProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CoursesByDeptSemesterProvider call(
    String department,
    int semester,
  ) =>
      CoursesByDeptSemesterProvider._(argument: (
        department,
        semester,
      ), from: this);

  @override
  String toString() => r'coursesByDeptSemesterProvider';
}

@ProviderFor(courseResources)
final courseResourcesProvider = CourseResourcesFamily._();

final class CourseResourcesProvider extends $FunctionalProvider<
        AsyncValue<List<CourseResource>>,
        List<CourseResource>,
        Stream<List<CourseResource>>>
    with
        $FutureModifier<List<CourseResource>>,
        $StreamProvider<List<CourseResource>> {
  CourseResourcesProvider._(
      {required CourseResourcesFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'courseResourcesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$courseResourcesHash();

  @override
  String toString() {
    return r'courseResourcesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CourseResource>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<CourseResource>> create(Ref ref) {
    final argument = this.argument as String;
    return courseResources(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CourseResourcesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseResourcesHash() => r'680332cec08dd876e1dfeda00652e62d9969e077';

final class CourseResourcesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CourseResource>>, String> {
  CourseResourcesFamily._()
      : super(
          retry: null,
          name: r'courseResourcesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CourseResourcesProvider call(
    String courseId,
  ) =>
      CourseResourcesProvider._(argument: courseId, from: this);

  @override
  String toString() => r'courseResourcesProvider';
}
