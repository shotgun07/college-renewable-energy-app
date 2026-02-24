import 'package:flutter_test/flutter_test.dart';
import 'package:college_admin_dashboard/main.dart';

void main() {
  testWidgets('Admin Dashboard app creates successfully',
      (WidgetTester tester) async {
    // Verify AdminDashboardApp class exists and can be instantiated
    const app = AdminDashboardApp();
    expect(app, isNotNull);
    expect(app, isA<AdminDashboardApp>());
  });
}
