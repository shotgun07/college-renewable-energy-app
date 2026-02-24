// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scheduleRemoteDatasource)
final scheduleRemoteDatasourceProvider = ScheduleRemoteDatasourceProvider._();

final class ScheduleRemoteDatasourceProvider extends $FunctionalProvider<
    ScheduleRemoteDatasource,
    ScheduleRemoteDatasource,
    ScheduleRemoteDatasource> with $Provider<ScheduleRemoteDatasource> {
  ScheduleRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scheduleRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scheduleRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ScheduleRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScheduleRemoteDatasource create(Ref ref) {
    return scheduleRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleRemoteDatasource>(value),
    );
  }
}

String _$scheduleRemoteDatasourceHash() =>
    r'34416de069b5e6a7a99696574f4b8856a5e99194';

@ProviderFor(scheduleLocalDatasource)
final scheduleLocalDatasourceProvider = ScheduleLocalDatasourceProvider._();

final class ScheduleLocalDatasourceProvider extends $FunctionalProvider<
    ScheduleLocalDatasource,
    ScheduleLocalDatasource,
    ScheduleLocalDatasource> with $Provider<ScheduleLocalDatasource> {
  ScheduleLocalDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scheduleLocalDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scheduleLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<ScheduleLocalDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScheduleLocalDatasource create(Ref ref) {
    return scheduleLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleLocalDatasource>(value),
    );
  }
}

String _$scheduleLocalDatasourceHash() =>
    r'fc81d92917184ebb853c53b204c54e4dbeae0716';

@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider = ScheduleRepositoryProvider._();

final class ScheduleRepositoryProvider extends $FunctionalProvider<
    ScheduleRepository,
    ScheduleRepository,
    ScheduleRepository> with $Provider<ScheduleRepository> {
  ScheduleRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scheduleRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScheduleRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScheduleRepository create(Ref ref) {
    return scheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleRepository>(value),
    );
  }
}

String _$scheduleRepositoryHash() =>
    r'5c16010c01d199df77deef452041521b2d072d2d';

@ProviderFor(scheduleStream)
final scheduleStreamProvider = ScheduleStreamFamily._();

final class ScheduleStreamProvider extends $FunctionalProvider<
        AsyncValue<List<Map<String, dynamic>>>,
        List<Map<String, dynamic>>,
        Stream<List<Map<String, dynamic>>>>
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  ScheduleStreamProvider._(
      {required ScheduleStreamFamily super.from,
      required (
        String,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'scheduleStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scheduleStreamHash();

  @override
  String toString() {
    return r'scheduleStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as (
      String,
      int,
    );
    return scheduleStream(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scheduleStreamHash() => r'696285fb560ff111ab2aaf12b3b93a4d1e56d621';

final class ScheduleStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<Map<String, dynamic>>>,
            (
              String,
              int,
            )> {
  ScheduleStreamFamily._()
      : super(
          retry: null,
          name: r'scheduleStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ScheduleStreamProvider call(
    String deptCode,
    int semester,
  ) =>
      ScheduleStreamProvider._(argument: (
        deptCode,
        semester,
      ), from: this);

  @override
  String toString() => r'scheduleStreamProvider';
}

@ProviderFor(allSchedules)
final allSchedulesProvider = AllSchedulesProvider._();

final class AllSchedulesProvider extends $FunctionalProvider<
        AsyncValue<List<Map<String, dynamic>>>,
        List<Map<String, dynamic>>,
        Stream<List<Map<String, dynamic>>>>
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  AllSchedulesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allSchedulesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allSchedulesHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return allSchedules(ref);
  }
}

String _$allSchedulesHash() => r'4811f5f0e302b5d1880b62fc3edd1cb31ccfaf87';
