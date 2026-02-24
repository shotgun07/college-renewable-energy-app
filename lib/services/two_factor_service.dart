import 'package:firebase_auth/firebase_auth.dart';

class TwoFactorService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String formatLibyanNumber(String number) {
    String clean = number.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('218')) return '+$clean';
    if (clean.startsWith('0')) clean = clean.substring(1);
    return '+218$clean';
  }

  bool isValidLibyanNumber(String number) {
    String clean = number.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('0')) clean = clean.substring(1);
    final regExp = RegExp(r'^(91|92|93|94)\d{7}$');
    return regExp.hasMatch(clean);
  }

  Future<void> requestOTP({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
  }) async {
    final formatted = formatLibyanNumber(phoneNumber);
    await _auth.verifyPhoneNumber(
      phoneNumber: formatted,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}