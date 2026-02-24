// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(surveyRemoteDatasource)
final surveyRemoteDatasourceProvider = SurveyRemoteDatasourceProvider._();

final class SurveyRemoteDatasourceProvider extends $FunctionalProvider<
    SurveyRemoteDatasource,
    SurveyRemoteDatasource,
    SurveyRemoteDatasource> with $Provider<SurveyRemoteDatasource> {
  SurveyRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'surveyRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surveyRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<SurveyRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SurveyRemoteDatasource create(Ref ref) {
    return surveyRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SurveyRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SurveyRemoteDatasource>(value),
    );
  }
}

String _$surveyRemoteDatasourceHash() =>
    r'821ba281c1c7dc700e66398925986ddcd6d98200';

@ProviderFor(surveyRepository)
final surveyRepositoryProvider = SurveyRepositoryProvider._();

final class SurveyRepositoryProvider extends $FunctionalProvider<
    SurveyRepository,
    SurveyRepository,
    SurveyRepository> with $Provider<SurveyRepository> {
  SurveyRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'surveyRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surveyRepositoryHash();

  @$internal
  @override
  $ProviderElement<SurveyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SurveyRepository create(Ref ref) {
    return surveyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SurveyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SurveyRepository>(value),
    );
  }
}

String _$surveyRepositoryHash() => r'0b3a7f9fe748d2b9f9f2a45624afc5a242120cc3';

@ProviderFor(SurveyNotifier)
final surveyProvider = SurveyNotifierProvider._();

final class SurveyNotifierProvider
    extends $NotifierProvider<SurveyNotifier, AsyncValue<void>> {
  SurveyNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'surveyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surveyNotifierHash();

  @$internal
  @override
  SurveyNotifier create() => SurveyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$surveyNotifierHash() => r'c17dede1f9d8af1578fc1f3ecca489be79b1f449';

abstract class _$SurveyNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
