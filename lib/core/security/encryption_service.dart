import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

/// Service to handle E2EE using Hybrid RSA + AES encryption.
class EncryptionService {
  final _secureStorage = const FlutterSecureStorage();
  
  static const String _privateKeyKey = 'e2ee_private_key';
  static const String _publicKeyKey = 'e2ee_public_key';

  /// Generates an RSA 2048-bit key pair, saves private key locally,
  /// and returns the PEM-encoded public key string to save in Firestore.
  Future<String> generateAndStoreKeys() async {
    final helper = RsaKeyHelper();
    final keyPair = await helper.computeRSAKeyPair(helper.getSecureRandom());
    
    final privateKeyPem =
        helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey);
    final publicKeyPem =
        helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey);

    await _secureStorage.write(key: _privateKeyKey, value: privateKeyPem);
    await _secureStorage.write(key: _publicKeyKey, value: publicKeyPem);

    return publicKeyPem;
  }

  /// Retrieves the locally stored public key PEM string.
  Future<String?> getLocalPublicKey() =>
      _secureStorage.read(key: _publicKeyKey);

  /// Returns true if the private key is stored locally.
  Future<bool> hasKeys() async {
    final pk = await _secureStorage.read(key: _privateKeyKey);
    return pk != null && pk.isNotEmpty;
  }

  /// Encrypts [plaintext] using a random AES key, then RSA-encrypts that key
  /// using the receiver's PEM public key. Returns a map with:
  ///   'content' → Base64 AES-encrypted message
  ///   'key'     → Base64 RSA-encrypted AES key+IV
  Map<String, String> encryptMessage(
      String plaintext, String receiverPublicKeyPem) {
    if (plaintext.isEmpty) return {'content': '', 'key': ''};

    // 1. AES encryption
    final aesKey = enc.Key.fromSecureRandom(32);
    final iv = enc.IV.fromSecureRandom(16);
    final aesEncrypter = enc.Encrypter(enc.AES(aesKey));
    final encryptedContent = aesEncrypter.encrypt(plaintext, iv: iv);

    // Combine key+iv into a single string
    final symmetricKeyData = '${aesKey.base64}:${iv.base64}';

    // 2. RSA-encrypt the AES key data
    final rsaPublicKey = enc.RSAKeyParser().parse(receiverPublicKeyPem) as RSAPublicKey;
    final rsaEncrypter = enc.Encrypter(enc.RSA(publicKey: rsaPublicKey));
    final encryptedKey = rsaEncrypter.encrypt(symmetricKeyData);

    return {
      'content': encryptedContent.base64,
      'key': encryptedKey.base64,
    };
  }

  /// Decrypts a received hybrid message using the locally stored private key.
  Future<String> decryptMessage(
      String encryptedContentBase64, String encryptedKeyBase64) async {
    if (encryptedContentBase64.isEmpty || encryptedKeyBase64.isEmpty) return '';

    try {
      final privateKeyPem =
          await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyPem == null) throw Exception('No private key found');

      final rsaPrivateKey = enc.RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;

      // 1. Decrypt AES key data with RSA
      final rsaEncrypter = enc.Encrypter(enc.RSA(privateKey: rsaPrivateKey));
      final symmetricKeyData = rsaEncrypter.decrypt(
          enc.Encrypted.fromBase64(encryptedKeyBase64));

      // 2. Parse AES key and IV
      final parts = symmetricKeyData.split(':');
      if (parts.length != 2) throw Exception('Invalid symmetric key format');

      final aesKey = enc.Key.fromBase64(parts[0]);
      final iv = enc.IV.fromBase64(parts[1]);

      // 3. Decrypt message content
      final aesEncrypter = enc.Encrypter(enc.AES(aesKey));
      return aesEncrypter.decrypt(
          enc.Encrypted.fromBase64(encryptedContentBase64), iv: iv);
    } catch (_) {
      // Graceful fallback: return ciphertext as-is (e.g. old plaintext message)
      return encryptedContentBase64;
    }
  }

  /// Clears keys from secure storage (call on logout).
  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _privateKeyKey);
    await _secureStorage.delete(key: _publicKeyKey);
  }
}
