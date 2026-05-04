import '../constants/app_enums.dart';

class DepartmentService {
  /// Returns the valid semesters for a given department.
  /// General: 1, 2
  /// Specialized (ICT, Energy, Environment): 3, 4, 5, 6, 7, 8
  static List<int> getSemestersForDepartment(Department department) {
    if (department == Department.general) {
      return [1, 2];
    } else {
      return [3, 4, 5, 6, 7, 8];
    }
  }

  /// Validates if a student's assigned semester is valid for their department.
  static bool validateStudentDepartmentAndSemester(
      Department department, int semester) {
    final validSemesters = getSemestersForDepartment(department);
    return validSemesters.contains(semester);
  }
}
