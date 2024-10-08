// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyDTb1t_hD--cA5tAu-XZRyBI3r3IH0OnsI',
    appId: '1:938580869362:web:2dfc4afd0ba0463e43d06b',
    messagingSenderId: '938580869362',
    projectId: 'trekmates-27618',
    authDomain: 'trekmates-27618.firebaseapp.com',
    storageBucket: 'trekmates-27618.appspot.com',
    measurementId: 'G-KLPWFJDBP4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiKsprHWvG6x4RBV_U3VJa-PDTbznCpu8',
    appId: '1:938580869362:android:d361c858de42135d43d06b',
    messagingSenderId: '938580869362',
    projectId: 'trekmates-27618',
    storageBucket: 'trekmates-27618.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvOSDKP5oU1wmJ1f1smtnnLCGfy0S_e1w',
    appId: '1:938580869362:ios:6ccc9819ae5ac91843d06b',
    messagingSenderId: '938580869362',
    projectId: 'trekmates-27618',
    storageBucket: 'trekmates-27618.appspot.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCvOSDKP5oU1wmJ1f1smtnnLCGfy0S_e1w',
    appId: '1:938580869362:ios:6499496152a3832a43d06b',
    messagingSenderId: '938580869362',
    projectId: 'trekmates-27618',
    storageBucket: 'trekmates-27618.appspot.com',
    iosBundleId: 'com.example.myApp.RunnerTests',
  );
}
