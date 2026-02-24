import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  group('SecureStorageService', () {
    test('Should store and retrieve token', () async {
      // Mock FlutterSecureStorage
      FlutterSecureStorage.setMockInitialValues({});
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: '123_test_token');
      final value = await storage.read(key: 'auth_token');
      expect(value, '123_test_token');
    });
  });
}
