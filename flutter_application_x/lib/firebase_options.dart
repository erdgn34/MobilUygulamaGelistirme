
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] 

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC1OX6mHQJSAgLbsQsrCffS_sWJJWfJZZ4',
    appId: '1:623937893641:web:e3ee3a90213d3dd4934fd8',
    messagingSenderId: '623937893641',
    projectId: 'librarymanagement-d99f0',
    authDomain: 'librarymanagement-d99f0.firebaseapp.com',
    storageBucket: 'librarymanagement-d99f0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaP-EVczJUUdHYz8wgYH7DLaR2bnfmjXk',
    appId: '1:623937893641:android:104319535939c1fb934fd8',
    messagingSenderId: '623937893641',
    projectId: 'librarymanagement-d99f0',
    storageBucket: 'librarymanagement-d99f0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQpH_kSUI1YPuenmZBs4cMjAK8TZ9N3xw',
    appId: '1:623937893641:ios:ad88f0dc42a19d96934fd8',
    messagingSenderId: '623937893641',
    projectId: 'librarymanagement-d99f0',
    storageBucket: 'librarymanagement-d99f0.appspot.com',
    iosBundleId: 'com.example.flutterApplicationx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQpH_kSUI1YPuenmZBs4cMjAK8TZ9N3xw',
    appId: '1:623937893641:ios:be06766f7debbcb0934fd8',
    messagingSenderId: '623937893641',
    projectId: 'librarymanagement-d99f0',
    storageBucket: 'librarymanagement-d99f0.appspot.com',
    iosBundleId: 'com.example.flutterApplicationx.RunnerTests',
  );
}
