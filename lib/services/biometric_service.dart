import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticate({String reason = 'تسجيل الدخول'}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  Future<bool> enableBiometric() async {
    if (!await canCheckBiometrics()) {
      return false;
    }

    final authenticated = await authenticate(
      reason: 'قم بالمصادقة لتفعيل البصمة',
    );

    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, true);
      return true;
    }

    return false;
  }

  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, false);
  }

  String getBiometricTypeName(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'التعرف على الوجه';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'بصمة الإصبع';
    } else if (types.contains(BiometricType.iris)) {
      return 'بصمة القزحية';
    }
    return 'المصادقة البيومترية';
  }
}
