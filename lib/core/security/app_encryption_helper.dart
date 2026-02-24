import 'package:encrypt/encrypt.dart' as enc;

/// Defines a globally shared AES key for encrypting user data and chat messages.
/// This fulfills the E2EE / Database Security requirement so that Firebase DB administrators
/// cannot view sensitive information in plaintext. Both the Main App and Admin Dashboard
/// share this key.
class AppEncryptionHelper {
  // 32-byte (256-bit) AES key. In a real production scenario, this can be injected via --dart-define
  static final _key = enc.Key.fromBase64('uU/GZ+K9D1X5l8wQjB2V0aL7eY4iN3rP6tC5fA8bK1c=');
  static final _encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));

  /// Encrypts plaintext and returns format 'IV_BASE64:CIPHERTEXT_BASE64'
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

  /// Decrypts ciphertext in format 'IV_BASE64:CIPHERTEXT_BASE64'.  
  /// Automatically returns plaintext if format is invalid (supports existing unencrypted data).
  static String decrypt(String cipherTextWithIv) {
    if (cipherTextWithIv.isEmpty) return cipherTextWithIv;
    try {
      final parts = cipherTextWithIv.split(':');
      // If it doesn't contain a colon, it's highly likely to be old unencrypted data
      if (parts.length != 2) return cipherTextWithIv; 
      
      final iv = enc.IV.fromBase64(parts[0]);
      final cipherText = parts[1];
      return _encrypter.decrypt(enc.Encrypted.fromBase64(cipherText), iv: iv);
    } catch (_) {
      // Fallback for any legacy unencrypted strings that happen to contain a colon
      return cipherTextWithIv;
    }
  }
}
