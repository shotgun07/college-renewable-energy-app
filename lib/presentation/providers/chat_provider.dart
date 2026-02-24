import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/usecases/chat/get_my_threads_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import 'auth_provider.dart';
import 'security_provider.dart';

part 'chat_provider.g.dart';

// Datasource
@riverpod
ChatRemoteDatasource chatRemoteDatasource(Ref ref) {
  return ChatRemoteDatasource(ref.watch(firebaseFirestoreProvider));
}

// Repository
@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDatasourceProvider),
    ref.watch(encryptionServiceProvider),
  );
}

// UseCases
@riverpod
GetMyThreadsUseCase getMyThreadsUseCase(Ref ref) {
  return GetMyThreadsUseCase(ref.watch(chatRepositoryProvider));
}

@riverpod
SendMessageUseCase sendMessageUseCase(Ref ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
}

// Streams
@riverpod
Stream<List<ChatThread>> myThreads(Ref ref, String uid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMyThreads(uid);
}

@riverpod
Stream<List<Message>> threadMessages(Ref ref, String threadId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(threadId, limit: 50);
}

@riverpod
Stream<int> unreadCount(Ref ref, String uid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getUnreadCount(uid);
}
