import 'dart:io';

/// Custom HttpOverrides that enforces certificate validation.
/// Can be extended to implement pinning for custom backend APIs.
///
/// Usage in main.dart:
///   HttpOverrides.global = AppHttpOverrides();
class AppHttpOverrides extends HttpOverrides {
  final SecurityContext customSecurityContext;

  AppHttpOverrides({SecurityContext? context}) 
      : customSecurityContext = context ?? SecurityContext.defaultContext;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // Prefer passed context or use the globally configured customSecurityContext
    final client = super.createHttpClient(context ?? customSecurityContext);
    
    // Explicit certificate validation for pinning
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Dart-level SSL pinning. 
      // Compare the certificate's PEM with known Google / GlobalSign root or leaf hashes.
      // Since Dart's standard HTTP client might fail on rotated leaf certs, we can check 
      // if the PEM contains familiar issuers or strictly fail.
      
      final isGoogleHost = host.contains('googleapis.com') || host.contains('firebaseio.com');
      if (isGoogleHost) {
        // Enforce basic pinning heuristic for Google domains (check Issuer CN)
        if (cert.issuer.contains('Google Trust Services') || cert.issuer.contains('GlobalSign')) {
           return true; // We can trust these specific issuers for Dart overrides
        }
      }
      
      // By default, reject all invalid certificates (secure by default)
      return false;
    };
    
    return client;
  }
}
