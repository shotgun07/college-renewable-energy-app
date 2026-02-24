import '../entities/result.dart';

abstract class ResultRepository {
  /// Get results for a student
  Stream<List<Result>> getStudentResults(String studentID);

  /// Add results (batch import from CSV)
  Future<void> addResults(List<Result> results);

  /// Get results by department and semester (for admin/teacher)
  Stream<List<Result>> getResultsByDepartmentAndSemester(
      String department, int semester);
}
