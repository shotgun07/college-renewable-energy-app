import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/survey.dart';
import '../../data/datasources/remote/survey_remote_datasource.dart';
import '../../data/repositories/survey_repository_impl.dart';
import '../../domain/repositories/survey_repository.dart';
import 'auth_provider.dart';

part 'survey_provider.g.dart';

@riverpod
SurveyRemoteDatasource surveyRemoteDatasource(Ref ref) {
  return SurveyRemoteDatasource();
}

@riverpod
SurveyRepository surveyRepository(Ref ref) {
  return SurveyRepositoryImpl(
    remoteDatasource: ref.watch(surveyRemoteDatasourceProvider),
  );
}

@riverpod
class SurveyNotifier extends _$SurveyNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submitSurvey({
    required String courseId,
    required String courseName,
    required int rating,
    required String comments,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('يجب تسجيل الدخول لإرسال تقييم');

      final survey = Survey(
        id: const Uuid().v4(),
        studentId: user.uid,
        courseId: courseId,
        courseName: courseName,
        rating: rating,
        comments: comments,
        submittedAt: DateTime.now(),
      );

      await ref.read(surveyRepositoryProvider).submitSurvey(survey);
    });
  }
}
