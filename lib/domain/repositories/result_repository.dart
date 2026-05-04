import '../entities/result.dart';

abstract class ResultRepository {
  Stream<List<Result>> getStudentResults(String studentID);

  Future<void> addResults(List<Result> results);

  Stream<List<Result>> getResultsByDepartmentAndSemester(
      String department, int semester);
}
