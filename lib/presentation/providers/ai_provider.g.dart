// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiService)
final aiServiceProvider = AiServiceProvider._();

final class AiServiceProvider
    extends $FunctionalProvider<AiService, AiService, AiService>
    with $Provider<AiService> {
  AiServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiServiceHash();

  @$internal
  @override
  $ProviderElement<AiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiService create(Ref ref) {
    return aiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiService>(value),
    );
  }
}

String _$aiServiceHash() => r'6a2ba9f7761a3cc3d1eab0c9ea16e7b6550b2270';

@ProviderFor(AiChat)
final aiChatProvider = AiChatProvider._();

final class AiChatProvider extends $NotifierProvider<AiChat, AiChatState> {
  AiChatProvider._()
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
  String debugGetCreateSourceHash() => _$aiChatHash();

  @$internal
  @override
  AiChat create() => AiChat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatState>(value),
    );
  }
}

String _$aiChatHash() => r'3af2d3424acb33872e3ca86beb38e67300ab9f16';

abstract class _$AiChat extends $Notifier<AiChatState> {
  AiChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AiChatState, AiChatState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AiChatState, AiChatState>, AiChatState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
