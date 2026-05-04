enum UserRole { student, teacher, supervisor, admin }

enum Department {
  general,
  ict,
  energy,
  environment;

  String get displayName {
    switch (this) {
      case Department.general:
        return 'القسم العام';
      case Department.ict:
        return 'تكنولوجيا المعلومات';
      case Department.energy:
        return 'الطاقة المتجددة';
      case Department.environment:
        return 'البيئة';
    }
  }

  static Department fromString(String? value) {
    if (value == null) return Department.general;
    final normalized = value.trim();
    if (normalized == 'تكنولوجيا المعلومات') return Department.ict;
    if (normalized == 'الطاقة المتجددة') return Department.energy;
    if (normalized == 'البيئة') return Department.environment;
    return Department.general;
  }
}
