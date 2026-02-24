import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys for secure storage
  static const _userVerificationKey = 'user_verification_status';
  static const _authTokenKey = 'auth_token';
  static const _biometricEnabledKey = 'biometric_enabled';

  // User verification status
  Future<void> saveUserVerificationStatus(bool isVerified) async {
    await _storage.write(
      key: _userVerificationKey,
      value: isVerified.toString(),
    );
  }

  Future<bool?> getUserVerificationStatus() async {
    final value = await _storage.read(key: _userVerificationKey);
    return value == null ? null : value == 'true';
  }

  // Auth token (if needed for custom auth)
  Future<void> saveAuthToken(String token) async {
    await _storage.write(
      key: _authTokenKey,
      value: token,
    );
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  // Biometric settings
  Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  // Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}