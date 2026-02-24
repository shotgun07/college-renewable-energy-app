import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/security/app_encryption_helper.dart';

void main() {
  group('Encryption Operations', () {
    test('AppEncryptionHelper encrypts and decrypts correctly', () {
      final plainText = 'Hello World 123! This is a secure message. 🔒';
      
      final cipherText = AppEncryptionHelper.encrypt(plainText);
      expect(cipherText, isNot(plainText));
      expect(cipherText.contains(':'), isTrue); // IV and cipher split
      
      final decryptedText = AppEncryptionHelper.decrypt(cipherText);
      expect(decryptedText, equals(plainText));
    });

    test('AppEncryptionHelper handles empty strings', () {
      expect(AppEncryptionHelper.encrypt(''), equals(''));
      expect(AppEncryptionHelper.decrypt(''), equals(''));
    });

    test('AppEncryptionHelper gracefully degrades on invalid ciphertext format', () {
      final invalidCipher = 'not_a_valid_base64_string_without_colon';
      expect(AppEncryptionHelper.decrypt(invalidCipher), equals(invalidCipher));
      
      final invalidParts = 'invalid:parts';
      expect(AppEncryptionHelper.decrypt(invalidParts), equals(invalidParts));
    });
  });
}
