import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/feedback_model.dart';
import '../../data/repositories/feedback_repository_impl.dart';

part 'feedback_provider.g.dart';

@riverpod
class FeedbackNotifier extends _$FeedbackNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submitFeedback(FeedbackModel feedback) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(feedbackRepositoryProvider).submitFeedback(feedback);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
