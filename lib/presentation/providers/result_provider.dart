import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/result_remote_datasource.dart';
import '../../data/repositories/result_repository_impl.dart';
import '../../domain/repositories/result_repository.dart';

part 'result_provider.g.dart';

@riverpod
ResultRemoteDatasource resultRemoteDatasource(Ref ref) {
  return ResultRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
ResultRepository resultRepository(Ref ref) {
  return ResultRepositoryImpl(ref.watch(resultRemoteDatasourceProvider));
}

@riverpod
Stream<List<Map<String, dynamic>>> resultsStream(
    Ref ref, String studentID) {
  return ref.watch(resultRepositoryProvider).getStudentResults(studentID).map(
      (results) => results.map((r) => {
            'studentID': r.studentID,
            'subject': r.subject,
            'grade': r.total,
            'semester': r.semester,
            'uploadedAt': r.createdAt,
          }).toList());
}
