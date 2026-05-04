import 'package:encrypt/encrypt.dart' as enc;


class AppEncryptionHelper {
  static final _key = enc.Key.fromBase64('uU/GZ+K9D1X5l8wQjB2V0aL7eY4iN3rP6tC5fA8bK1c=');
  static final _encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));

  static String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;
    try {
      final iv = enc.IV.fromSecureRandom(16);
      final encrypted = _encrypter.encrypt(plainText, iv: iv);
      return '${iv.base64}:${encrypted.base64}';
    } catch (_) {
      return plainText;
    }
  }

  static String decrypt(String cipherTextWithIv) {
    if (cipherTextWithIv.isEmpty) return cipherTextWithIv;
    try {
      final parts = cipherTextWithIv.split(':');
      if (parts.length != 2) return cipherTextWithIv; 
      
      final iv = enc.IV.fromBase64(parts[0]);
      final cipherText = parts[1];
      return _encrypter.decrypt(enc.Encrypted.fromBase64(cipherText), iv: iv);
    } catch (_) {
      return cipherTextWithIv;
    }
  }
}
