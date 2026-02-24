import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDiV8B8OB_WHSuUfMEJ4T05TSIOnBH4b3Q',
    appId: '1:167535432638:web:4b33b52950fd874b939fef',
    messagingSenderId: '167535432638',
    projectId: 'renewable-energy-college-app',
    authDomain: 'renewable-energy-college-app.firebaseapp.com',
    storageBucket: 'renewable-energy-college-app.firebasestorage.app',
    measurementId: 'G-Q4KYD946Z6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0b3WLAaWX4DMWdAQBuPkrJwZG89eU-zE',
    appId: '1:167535432638:android:93d7031d29dd5783939fef',
    messagingSenderId: '167535432638',
    projectId: 'renewable-energy-college-app',
    storageBucket: 'renewable-energy-college-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPrwSYRr9CiZuWCL7urPRP6y9Be0J9pz0',
    appId: '1:167535432638:ios:b0fcd9ace182d550939fef',
    messagingSenderId: '167535432638',
    projectId: 'renewable-energy-college-app',
    storageBucket: 'renewable-energy-college-app.firebasestorage.app',
    androidClientId: '167535432638-mtsvst5rrtnqtimks3md8f82ucp72ijg.apps.googleusercontent.com',
    iosClientId: '167535432638-0qnqmpeoo89i977dmsrie27e8cnm29r6.apps.googleusercontent.com',
    iosBundleId: 'com.collegeRenewableEnergy.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPrwSYRr9CiZuWCL7urPRP6y9Be0J9pz0',
    appId: '1:167535432638:ios:b0fcd9ace182d550939fef',
    messagingSenderId: '167535432638',
    projectId: 'renewable-energy-college-app',
    storageBucket: 'renewable-energy-college-app.firebasestorage.app',
    androidClientId: '167535432638-mtsvst5rrtnqtimks3md8f82ucp72ijg.apps.googleusercontent.com',
    iosClientId: '167535432638-0qnqmpeoo89i977dmsrie27e8cnm29r6.apps.googleusercontent.com',
    iosBundleId: 'com.collegeRenewableEnergy.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDiV8B8OB_WHSuUfMEJ4T05TSIOnBH4b3Q',
    appId: '1:167535432638:web:1ed5207f4c9a9bee939fef',
    messagingSenderId: '167535432638',
    projectId: 'renewable-energy-college-app',
    authDomain: 'renewable-energy-college-app.firebaseapp.com',
    storageBucket: 'renewable-energy-college-app.firebasestorage.app',
    measurementId: 'G-M455LJ6K8Z',
  );

}