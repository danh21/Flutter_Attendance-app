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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDVemzAlhRoyuDHbI0iLqU9O9G6_9eVwg0',
    appId: '1:54540388034:android:d586c865c29563183f5d5b',
    messagingSenderId: '54540388034',
    projectId: 'attendance-app-fdd08',
    storageBucket: 'attendance-app-fdd08.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVemzAlhRoyuDHbI0iLqU9O9G6_9eVwg0',
    appId: '1:54540388034:android:d586c865c29563183f5d5b',
    messagingSenderId: '54540388034',
    projectId: 'attendance-app-fdd08',
    storageBucket: 'attendance-app-fdd08.appspot.com',
  );

  static const FirebaseOptions ios = android;
  static const FirebaseOptions macos = android;
  static const FirebaseOptions windows = android;
  static const FirebaseOptions linux = android;
}
