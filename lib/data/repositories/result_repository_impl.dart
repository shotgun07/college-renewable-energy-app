import '../../domain/entities/result.dart';
import '../../domain/repositories/result_repository.dart';
import '../datasources/remote/result_remote_datasource.dart';
import '../models/result_model.dart';

class ResultRepositoryImpl implements ResultRepository {
  final ResultRemoteDatasource _remoteDatasource;

  ResultRepositoryImpl(this._remoteDatasource);

  @override
  Stream<List<Result>> getStudentResults(String studentID) {
    return _remoteDatasource.getStudentResults(studentID);
  }

  @override
  Future<void> addResults(List<Result> results) async {
    final models = results
        .map((r) => ResultModel(
              id: r.id,
              studentID: r.studentID,
              studentName: r.studentName,
              department: r.department,
              semester: r.semester,
              subject: r.subject,
              midterm: r.midterm,
              final_: r.final_,
              practical: r.practical,
              total: r.total,
              createdAt: r.createdAt,
            ))
        .toList();

    await _remoteDatasource.addResults(models);
  }

  @override
  Stream<List<Result>> getResultsByDepartmentAndSemester(
      String department, int semester) {
    return _remoteDatasource.getResultsByDepartmentAndSemester(
        department, semester);
  }
}
