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
    apiKey: 'AIzaSyBrWAHeM3kVdXGQKKEFDW8EFZx8kQH9Ifk',
    appId: '1:958968841023:web:11f42fa16fab35cb91898a',
    messagingSenderId: '958968841023',
    projectId: 'voyager-test-b3675',
    authDomain: 'voyager-test-b3675.firebaseapp.com',
    storageBucket: 'voyager-test-b3675.firebasestorage.app',
    measurementId: 'G-3QDV0DCD3C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVod_eDnq4wyyppK-2WNf0Hf8Hvh4eHM8',
    appId: '1:958968841023:android:d795ea5a8d394ed191898a',
    messagingSenderId: '958968841023',
    projectId: 'voyager-test-b3675',
    storageBucket: 'voyager-test-b3675.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuPXq-2NrFQK5icReNTibQaZ5TJobZGf8',
    appId: '1:958968841023:ios:a6086fca1612dde091898a',
    messagingSenderId: '958968841023',
    projectId: 'voyager-test-b3675',
    storageBucket: 'voyager-test-b3675.firebasestorage.app',
    iosBundleId: 'com.akiraplc.voyager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuPXq-2NrFQK5icReNTibQaZ5TJobZGf8',
    appId: '1:958968841023:ios:a6086fca1612dde091898a',
    messagingSenderId: '958968841023',
    projectId: 'voyager-test-b3675',
    storageBucket: 'voyager-test-b3675.firebasestorage.app',
    iosBundleId: 'com.akiraplc.voyager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBrWAHeM3kVdXGQKKEFDW8EFZx8kQH9Ifk',
    appId: '1:958968841023:web:e0e2dd7c2a6943ea91898a',
    messagingSenderId: '958968841023',
    projectId: 'voyager-test-b3675',
    authDomain: 'voyager-test-b3675.firebaseapp.com',
    storageBucket: 'voyager-test-b3675.firebasestorage.app',
    measurementId: 'G-78JQ1KVKN1',
  );

}