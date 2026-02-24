import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/encryption_service.dart';

/// Global provider for the EncryptionService (singleton per session).
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService();
});
