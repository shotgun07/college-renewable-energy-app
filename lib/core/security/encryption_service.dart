import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class EncryptionService {
  final _secureStorage = const FlutterSecureStorage();
  
  static const String _privateKeyKey = 'e2ee_private_key';
  static const String _publicKeyKey = 'e2ee_public_key';

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

  Future<String?> getLocalPublicKey() =>
      _secureStorage.read(key: _publicKeyKey);

  Future<bool> hasKeys() async {
    final pk = await _secureStorage.read(key: _privateKeyKey);
    return pk != null && pk.isNotEmpty;
  }

  Map<String, String> encryptMessage(
      String plaintext, String receiverPublicKeyPem) {
    if (plaintext.isEmpty) return {'content': '', 'key': ''};

    final aesKey = enc.Key.fromSecureRandom(32);
    final iv = enc.IV.fromSecureRandom(16);
    final aesEncrypter = enc.Encrypter(enc.AES(aesKey));
    final encryptedContent = aesEncrypter.encrypt(plaintext, iv: iv);

    final symmetricKeyData = '${aesKey.base64}:${iv.base64}';

    final rsaPublicKey = enc.RSAKeyParser().parse(receiverPublicKeyPem) as RSAPublicKey;
    final rsaEncrypter = enc.Encrypter(enc.RSA(publicKey: rsaPublicKey));
    final encryptedKey = rsaEncrypter.encrypt(symmetricKeyData);

    return {
      'content': encryptedContent.base64,
      'key': encryptedKey.base64,
    };
  }

  Future<String> decryptMessage(
      String encryptedContentBase64, String encryptedKeyBase64) async {
    if (encryptedContentBase64.isEmpty || encryptedKeyBase64.isEmpty) return '';

    try {
      final privateKeyPem =
          await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyPem == null) throw Exception('No private key found');

      final rsaPrivateKey = enc.RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;

      final rsaEncrypter = enc.Encrypter(enc.RSA(privateKey: rsaPrivateKey));
      final symmetricKeyData = rsaEncrypter.decrypt(
          enc.Encrypted.fromBase64(encryptedKeyBase64));

      final parts = symmetricKeyData.split(':');
      if (parts.length != 2) throw Exception('Invalid symmetric key format');

      final aesKey = enc.Key.fromBase64(parts[0]);
      final iv = enc.IV.fromBase64(parts[1]);

      final aesEncrypter = enc.Encrypter(enc.AES(aesKey));
      return aesEncrypter.decrypt(
          enc.Encrypted.fromBase64(encryptedContentBase64), iv: iv);
    } catch (e) {
      debugPrint('Decryption error: $e');
      return '[فك التشفير فشل]';
    }
  }

  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _privateKeyKey);
    await _secureStorage.delete(key: _publicKeyKey);
  }
}
