// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FeedbackNotifier)
final feedbackProvider = FeedbackNotifierProvider._();

final class FeedbackNotifierProvider
    extends $NotifierProvider<FeedbackNotifier, AsyncValue<void>> {
  FeedbackNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedbackProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedbackNotifierHash();

  @$internal
  @override
  FeedbackNotifier create() => FeedbackNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$feedbackNotifierHash() => r'2b88ea86647b22cd01828bede3bdeaa66edbb53c';

abstract class _$FeedbackNotifier extends $Notifier<AsyncValue<void>> {
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
