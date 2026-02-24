import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/repositories/admin_repository.dart';
import 'package:app/data/repositories/admin_repository_impl.dart';
import 'package:app/data/datasources/remote/admin_remote_datasource.dart';
import 'package:app/data/models/user_model.dart';

@GenerateNiceMocks([MockSpec<AdminRemoteDatasource>()])
import 'admin_repository_test.mocks.dart';

void main() {
  late AdminRepository repository;
  late MockAdminRemoteDatasource mockDataSource;

  setUp(() {
    mockDataSource = MockAdminRemoteDatasource();
    repository = AdminRepositoryImpl(remoteDatasource: mockDataSource);
  });

  group('AdminRepositoryImpl', () {
    test('watchStudents should return a stream of users', () {
      final userModels = [
        UserModel(
          uid: '1',
          fullName: 'Student 1',
          email: 'student1@test.com',
          role: UserRole.student,
          departmentName: 'General',
          semester: 1,
          phoneNumber: '12345678',
          nationalId: 'NAT-1',
          studentID: 'STU-1',
        ),
      ];

      when(mockDataSource.watchStudents()).thenAnswer((_) => Stream.value(userModels));

      expect(repository.watchStudents(), emits(isA<List<User>>()));
    });

    test('updateStudentID should call remote datasource', () async {
      when(mockDataSource.updateStudentID(any, any, any, any))
          .thenAnswer((_) async => {});

      await repository.updateStudentID('uid', 'name', 'newId', 'adminUid');

      verify(mockDataSource.updateStudentID('uid', 'name', 'newId', 'adminUid')).called(1);
    });

    test('getUserName should return the user full name', () async {
      when(mockDataSource.getUserName('uid123')).thenAnswer((_) async => 'John Doe');

      final name = await repository.getUserName('uid123');

      expect(name, 'John Doe');
      verify(mockDataSource.getUserName('uid123')).called(1);
    });

    test('getStudentsByDeptSemester should return a list of students', () async {
      final userModels = [
        UserModel(
          uid: '1',
          fullName: 'Student 1',
          email: 'student1@test.com',
          role: UserRole.student,
          departmentName: 'ICT',
          semester: 3,
          phoneNumber: '12345678',
          nationalId: 'NAT-1',
          studentID: 'STU-1',
        ),
      ];

      when(mockDataSource.getStudentsByDeptSemester('ICT', 3))
          .thenAnswer((_) async => userModels);

      final result = await repository.getStudentsByDeptSemester('ICT', 3);

      expect(result.length, 1);
      expect(result.first.fullName, 'Student 1');
      verify(mockDataSource.getStudentsByDeptSemester('ICT', 3)).called(1);
    });
  });
}
