class FirestoreCollections {
  static const users = 'users';
  static const announcements = 'announcements';
  static const results = 'results';
  static const schedules = 'schedules';
}

class UserFields {
  static const fullName = 'fullName';
  static const email = 'email';
  static const departmentCode = 'departmentCode';
  static const departmentName = 'departmentName';
  static const semester = 'semester';
  static const role = 'role';
  static const createdAt = 'createdAt';
  static const studentID = 'studentID';
}

class AnnouncementFields {
  static const title = 'title';
  static const body = 'body';
  static const department = 'department';
  static const semester = 'semester';
  static const createdAt = 'createdAt';
}

class ResultFields {
  static const studentID = 'studentID';
  static const studentName = 'studentName';
  static const subject = 'subject';
  static const grade = 'grade';
  static const uploadedAt = 'uploadedAt';
}

class ScheduleFields {
  static const departmentCode = 'departmentCode';
  static const semester = 'semester';
  static const title = 'title';
  static const items = 'items';
  static const createdAt = 'createdAt';
}
