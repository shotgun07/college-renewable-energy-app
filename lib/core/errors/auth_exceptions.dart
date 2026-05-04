class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (code: $code)' : ''}';
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException(
      [super.message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة'])
      : super(code: 'invalid-credentials');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException([super.message = 'المستخدم غير موجود'])
      : super(code: 'user-not-found');
}


class AccountDisabledException extends AuthException {
  AccountDisabledException([super.message = 'تم تعطيل هذا الحساب'])
      : super(code: 'account-disabled');
}

class UnverifiedUserException extends AuthException {
  UnverifiedUserException([super.message = 'البريد الإلكتروني غير موثق'])
      : super(code: 'unverified-email');
}

class NetworkException extends AuthException {
  NetworkException([super.message = 'حدث خطأ في الاتصال بالشبكة'])
      : super(code: 'network-error');
}

class UserDataNotFoundException extends AuthException {
  UserDataNotFoundException(
      [super.message = 'بيانات المستخدم غير موجودة في قاعدة البيانات'])
      : super(code: 'user-data-not-found');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException([super.message = 'البريد الإلكتروني غير صالح'])
      : super(code: 'invalid-email');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException([super.message = 'كلمة المرور ضعيفة جداً'])
      : super(code: 'weak-password');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException(
      [super.message = 'البريد الإلكتروني مستخدم بالفعل'])
      : super(code: 'email-already-in-use');
}

class RequiresRecentLoginException extends AuthException {
  RequiresRecentLoginException(
      [super.message = 'هذه العملية تتطلب تسجيل دخول حديث'])
      : super(code: 'requires-recent-login');
}

class TooManyRequestsException extends AuthException {
  TooManyRequestsException(
      [super.message = 'محاولات كثيرة جداً. يرجى المحاولة لاحقاً'])
      : super(code: 'too-many-requests');
}
