// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statsRemoteDatasource)
final statsRemoteDatasourceProvider = StatsRemoteDatasourceProvider._();

final class StatsRemoteDatasourceProvider extends $FunctionalProvider<
    StatsRemoteDatasource,
    StatsRemoteDatasource,
    StatsRemoteDatasource> with $Provider<StatsRemoteDatasource> {
  StatsRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statsRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statsRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<StatsRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsRemoteDatasource create(Ref ref) {
    return statsRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsRemoteDatasource>(value),
    );
  }
}

String _$statsRemoteDatasourceHash() =>
    r'0abb2011a9018d87243bbcaa90538514006c0a30';

@ProviderFor(statsRepository)
final statsRepositoryProvider = StatsRepositoryProvider._();

final class StatsRepositoryProvider extends $FunctionalProvider<StatsRepository,
    StatsRepository, StatsRepository> with $Provider<StatsRepository> {
  StatsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StatsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsRepository create(Ref ref) {
    return statsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsRepository>(value),
    );
  }
}

String _$statsRepositoryHash() => r'7e024cbf2375b8528e48754ebba10cdc9a406fbc';

@ProviderFor(getTeacherStatsUseCase)
final getTeacherStatsUseCaseProvider = GetTeacherStatsUseCaseProvider._();

final class GetTeacherStatsUseCaseProvider extends $FunctionalProvider<
    GetTeacherStatsUseCase,
    GetTeacherStatsUseCase,
    GetTeacherStatsUseCase> with $Provider<GetTeacherStatsUseCase> {
  GetTeacherStatsUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getTeacherStatsUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getTeacherStatsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTeacherStatsUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetTeacherStatsUseCase create(Ref ref) {
    return getTeacherStatsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTeacherStatsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTeacherStatsUseCase>(value),
    );
  }
}

String _$getTeacherStatsUseCaseHash() =>
    r'340a9ac0368e192c49da94a8c9db48c1d27138f7';

@ProviderFor(teacherStats)
final teacherStatsProvider = TeacherStatsProvider._();

final class TeacherStatsProvider
    extends $FunctionalProvider<AsyncValue<Stats>, Stats, FutureOr<Stats>>
    with $FutureModifier<Stats>, $FutureProvider<Stats> {
  TeacherStatsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'teacherStatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$teacherStatsHash();

  @$internal
  @override
  $FutureProviderElement<Stats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Stats> create(Ref ref) {
    return teacherStats(ref);
  }
}

String _$teacherStatsHash() => r'1c94da4561bce5443986d81900f62daa043dd74d';
