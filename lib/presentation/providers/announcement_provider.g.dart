// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementRemoteDatasource)
final announcementRemoteDatasourceProvider =
    AnnouncementRemoteDatasourceProvider._();

final class AnnouncementRemoteDatasourceProvider extends $FunctionalProvider<
    AnnouncementRemoteDatasource,
    AnnouncementRemoteDatasource,
    AnnouncementRemoteDatasource> with $Provider<AnnouncementRemoteDatasource> {
  AnnouncementRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'announcementRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AnnouncementRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnnouncementRemoteDatasource create(Ref ref) {
    return announcementRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementRemoteDatasource>(value),
    );
  }
}

String _$announcementRemoteDatasourceHash() =>
    r'8da33e1a80055512d0a15c9fc8decbe9d173364a';

@ProviderFor(announcementLocalDatasource)
final announcementLocalDatasourceProvider =
    AnnouncementLocalDatasourceProvider._();

final class AnnouncementLocalDatasourceProvider extends $FunctionalProvider<
    AnnouncementLocalDatasource,
    AnnouncementLocalDatasource,
    AnnouncementLocalDatasource> with $Provider<AnnouncementLocalDatasource> {
  AnnouncementLocalDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'announcementLocalDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<AnnouncementLocalDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnnouncementLocalDatasource create(Ref ref) {
    return announcementLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementLocalDatasource>(value),
    );
  }
}

String _$announcementLocalDatasourceHash() =>
    r'3498e4b72fae7bbe0aaa02948d3b70c47a81022d';

@ProviderFor(announcementRepository)
final announcementRepositoryProvider = AnnouncementRepositoryProvider._();

final class AnnouncementRepositoryProvider extends $FunctionalProvider<
    AnnouncementRepository,
    AnnouncementRepository,
    AnnouncementRepository> with $Provider<AnnouncementRepository> {
  AnnouncementRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'announcementRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnnouncementRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnnouncementRepository create(Ref ref) {
    return announcementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementRepository>(value),
    );
  }
}

String _$announcementRepositoryHash() =>
    r'dabdddf176d7754368cdc4e10313eae2451bdea3';

@ProviderFor(announcements)
final announcementsProvider = AnnouncementsFamily._();

final class AnnouncementsProvider extends $FunctionalProvider<
        AsyncValue<List<Announcement>>,
        List<Announcement>,
        Stream<List<Announcement>>>
    with
        $FutureModifier<List<Announcement>>,
        $StreamProvider<List<Announcement>> {
  AnnouncementsProvider._(
      {required AnnouncementsFamily super.from,
      required (
        String,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'announcementsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementsHash();

  @override
  String toString() {
    return r'announcementsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Announcement>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Announcement>> create(Ref ref) {
    final argument = this.argument as (
      String,
      int,
    );
    return announcements(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnnouncementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$announcementsHash() => r'6afb7bd34c3f5b16f7b1ea42801b471f0c11293f';

final class AnnouncementsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<Announcement>>,
            (
              String,
              int,
            )> {
  AnnouncementsFamily._()
      : super(
          retry: null,
          name: r'announcementsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AnnouncementsProvider call(
    String department,
    int semester,
  ) =>
      AnnouncementsProvider._(argument: (
        department,
        semester,
      ), from: this);

  @override
  String toString() => r'announcementsProvider';
}

@ProviderFor(addAnnouncementUseCase)
final addAnnouncementUseCaseProvider = AddAnnouncementUseCaseProvider._();

final class AddAnnouncementUseCaseProvider extends $FunctionalProvider<
    AddAnnouncementUseCase,
    AddAnnouncementUseCase,
    AddAnnouncementUseCase> with $Provider<AddAnnouncementUseCase> {
  AddAnnouncementUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addAnnouncementUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addAnnouncementUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddAnnouncementUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddAnnouncementUseCase create(Ref ref) {
    return addAnnouncementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddAnnouncementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddAnnouncementUseCase>(value),
    );
  }
}

String _$addAnnouncementUseCaseHash() =>
    r'a7d8cfffc3cec9f0ead94684da6bf62ad39acb32';
