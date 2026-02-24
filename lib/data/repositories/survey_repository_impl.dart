import '../../domain/entities/survey.dart';
import '../../domain/repositories/survey_repository.dart';
import '../datasources/remote/survey_remote_datasource.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyRemoteDatasource _remoteDatasource;

  SurveyRepositoryImpl({required SurveyRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<void> submitSurvey(Survey survey) {
    return _remoteDatasource.submitSurvey(survey);
  }

  @override
  Stream<List<Survey>> getSurveysByCourse(String courseId) {
    return _remoteDatasource.getSurveysByCourse(courseId);
  }

  @override
  Stream<List<Survey>> getSurveysByStudent(String studentId) {
    return _remoteDatasource.getSurveysByStudent(studentId);
  }
}
