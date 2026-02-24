abstract class ScheduleRepository {
  Stream<List<Map<String, dynamic>>> getSchedule(String deptCode, int semester);
  Stream<List<Map<String, dynamic>>> getAllSchedules();
}
