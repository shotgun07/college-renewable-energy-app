// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(resultRemoteDatasource)
final resultRemoteDatasourceProvider = ResultRemoteDatasourceProvider._();

final class ResultRemoteDatasourceProvider extends $FunctionalProvider<
    ResultRemoteDatasource,
    ResultRemoteDatasource,
    ResultRemoteDatasource> with $Provider<ResultRemoteDatasource> {
  ResultRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resultRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resultRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ResultRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResultRemoteDatasource create(Ref ref) {
    return resultRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResultRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResultRemoteDatasource>(value),
    );
  }
}

String _$resultRemoteDatasourceHash() =>
    r'96d863d9eecacc1a3697070aeac2e51b768e4b0d';

@ProviderFor(resultRepository)
final resultRepositoryProvider = ResultRepositoryProvider._();

final class ResultRepositoryProvider extends $FunctionalProvider<
    ResultRepository,
    ResultRepository,
    ResultRepository> with $Provider<ResultRepository> {
  ResultRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resultRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resultRepositoryHash();

  @$internal
  @override
  $ProviderElement<ResultRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResultRepository create(Ref ref) {
    return resultRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResultRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResultRepository>(value),
    );
  }
}

String _$resultRepositoryHash() => r'e681c3517c1b263fe6fa5a0e9c335ac7abc1dfa9';

@ProviderFor(resultsStream)
final resultsStreamProvider = ResultsStreamFamily._();

final class ResultsStreamProvider extends $FunctionalProvider<
        AsyncValue<List<Map<String, dynamic>>>,
        List<Map<String, dynamic>>,
        Stream<List<Map<String, dynamic>>>>
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  ResultsStreamProvider._(
      {required ResultsStreamFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'resultsStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resultsStreamHash();

  @override
  String toString() {
    return r'resultsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return resultsStream(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ResultsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resultsStreamHash() => r'506f178d57c55018863cef612bb0d471c43c988c';

final class ResultsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Map<String, dynamic>>>, String> {
  ResultsStreamFamily._()
      : super(
          retry: null,
          name: r'resultsStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ResultsStreamProvider call(
    String studentID,
  ) =>
      ResultsStreamProvider._(argument: studentID, from: this);

  @override
  String toString() => r'resultsStreamProvider';
}
