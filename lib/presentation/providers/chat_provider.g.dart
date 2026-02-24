// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRemoteDatasource)
final chatRemoteDatasourceProvider = ChatRemoteDatasourceProvider._();

final class ChatRemoteDatasourceProvider extends $FunctionalProvider<
    ChatRemoteDatasource,
    ChatRemoteDatasource,
    ChatRemoteDatasource> with $Provider<ChatRemoteDatasource> {
  ChatRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRemoteDatasource create(Ref ref) {
    return chatRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRemoteDatasource>(value),
    );
  }
}

String _$chatRemoteDatasourceHash() =>
    r'29eeebaa5b5536b1e8c1544de3bcf35c810b78d0';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'51a6b3a253142276f1f70406f03fe5e9e26da052';

@ProviderFor(getMyThreadsUseCase)
final getMyThreadsUseCaseProvider = GetMyThreadsUseCaseProvider._();

final class GetMyThreadsUseCaseProvider extends $FunctionalProvider<
    GetMyThreadsUseCase,
    GetMyThreadsUseCase,
    GetMyThreadsUseCase> with $Provider<GetMyThreadsUseCase> {
  GetMyThreadsUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getMyThreadsUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getMyThreadsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMyThreadsUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetMyThreadsUseCase create(Ref ref) {
    return getMyThreadsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMyThreadsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMyThreadsUseCase>(value),
    );
  }
}

String _$getMyThreadsUseCaseHash() =>
    r'996b4db73b897d7113d741f15a8cf1051ea880b9';

@ProviderFor(sendMessageUseCase)
final sendMessageUseCaseProvider = SendMessageUseCaseProvider._();

final class SendMessageUseCaseProvider extends $FunctionalProvider<
    SendMessageUseCase,
    SendMessageUseCase,
    SendMessageUseCase> with $Provider<SendMessageUseCase> {
  SendMessageUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sendMessageUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sendMessageUseCaseHash();

  @$internal
  @override
  $ProviderElement<SendMessageUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendMessageUseCase create(Ref ref) {
    return sendMessageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendMessageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendMessageUseCase>(value),
    );
  }
}

String _$sendMessageUseCaseHash() =>
    r'dda92eb2e903ee948d8c3f7f3ebaef1817d9b6fa';

@ProviderFor(myThreads)
final myThreadsProvider = MyThreadsFamily._();

final class MyThreadsProvider extends $FunctionalProvider<
        AsyncValue<List<ChatThread>>,
        List<ChatThread>,
        Stream<List<ChatThread>>>
    with $FutureModifier<List<ChatThread>>, $StreamProvider<List<ChatThread>> {
  MyThreadsProvider._(
      {required MyThreadsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'myThreadsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myThreadsHash();

  @override
  String toString() {
    return r'myThreadsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatThread>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ChatThread>> create(Ref ref) {
    final argument = this.argument as String;
    return myThreads(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MyThreadsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myThreadsHash() => r'159efc4a260d5b7e1f0af624140c452b5ea3215d';

final class MyThreadsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatThread>>, String> {
  MyThreadsFamily._()
      : super(
          retry: null,
          name: r'myThreadsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MyThreadsProvider call(
    String uid,
  ) =>
      MyThreadsProvider._(argument: uid, from: this);

  @override
  String toString() => r'myThreadsProvider';
}

@ProviderFor(threadMessages)
final threadMessagesProvider = ThreadMessagesFamily._();

final class ThreadMessagesProvider extends $FunctionalProvider<
        AsyncValue<List<Message>>, List<Message>, Stream<List<Message>>>
    with $FutureModifier<List<Message>>, $StreamProvider<List<Message>> {
  ThreadMessagesProvider._(
      {required ThreadMessagesFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'threadMessagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$threadMessagesHash();

  @override
  String toString() {
    return r'threadMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Message>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Message>> create(Ref ref) {
    final argument = this.argument as String;
    return threadMessages(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$threadMessagesHash() => r'3bc77d8958827a592c2495d3ba2066ae77b67c0e';

final class ThreadMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Message>>, String> {
  ThreadMessagesFamily._()
      : super(
          retry: null,
          name: r'threadMessagesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ThreadMessagesProvider call(
    String threadId,
  ) =>
      ThreadMessagesProvider._(argument: threadId, from: this);

  @override
  String toString() => r'threadMessagesProvider';
}

@ProviderFor(unreadCount)
final unreadCountProvider = UnreadCountFamily._();

final class UnreadCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  UnreadCountProvider._(
      {required UnreadCountFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'unreadCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @override
  String toString() {
    return r'unreadCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return unreadCount(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnreadCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unreadCountHash() => r'8d397268053a2011f45250f16f4f70dc6a886a03';

final class UnreadCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  UnreadCountFamily._()
      : super(
          retry: null,
          name: r'unreadCountProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UnreadCountProvider call(
    String uid,
  ) =>
      UnreadCountProvider._(argument: uid, from: this);

  @override
  String toString() => r'unreadCountProvider';
}
