// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiRepository)
final aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $FunctionalProvider<AiRepository, AiRepository, AiRepository>
    with $Provider<AiRepository> {
  AiRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiRepository create(Ref ref) {
    return aiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'b9277a8a9166ebf8a20afc8e6312fe3f963378f8';

@ProviderFor(AiChatNotifier)
final aiChatProvider = AiChatNotifierProvider._();

final class AiChatNotifierProvider
    extends $NotifierProvider<AiChatNotifier, List<AiMessage>> {
  AiChatNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiChatProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiChatNotifierHash();

  @$internal
  @override
  AiChatNotifier create() => AiChatNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AiMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AiMessage>>(value),
    );
  }
}

String _$aiChatNotifierHash() => r'c2be00072bb9d57647a89c44100b6e4e44f8c1dc';

abstract class _$AiChatNotifier extends $Notifier<List<AiMessage>> {
  List<AiMessage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<AiMessage>, List<AiMessage>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<AiMessage>, List<AiMessage>>,
        List<AiMessage>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
