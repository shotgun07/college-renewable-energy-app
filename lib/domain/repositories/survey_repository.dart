import '../entities/survey.dart';

abstract class SurveyRepository {
  Future<void> submitSurvey(Survey survey);
  Stream<List<Survey>> getSurveysByCourse(String courseId);
  Stream<List<Survey>> getSurveysByStudent(String studentId);
}
