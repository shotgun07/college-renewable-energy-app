import 'dart:io';
import 'package:flutter/foundation.dart';


class AppHttpOverrides extends HttpOverrides {
  final SecurityContext customSecurityContext;

  AppHttpOverrides({SecurityContext? context}) 
      : customSecurityContext = context ?? SecurityContext.defaultContext;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context ?? customSecurityContext);


    if (kDebugMode) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        final isGoogleHost = host.contains('googleapis.com') || host.contains('firebaseio.com');
        if (isGoogleHost) {
          if (cert.issuer.contains('Google Trust Services') || cert.issuer.contains('GlobalSign')) {
            return true;
          }
        }
        return false;
      };
    }

    return client;
  }
}
