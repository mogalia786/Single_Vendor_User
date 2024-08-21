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
    apiKey: 'AIzaSyAa0XIfrbDLRA0G_c85B3nl0g6BTgIPX4U',
    appId: '1:685831727373:web:6b94b93e227fa24d83a844',
    messagingSenderId: '685831727373',
    projectId: 'ecommercesite-532ef',
    authDomain: 'ecommercesite-532ef.firebaseapp.com',
    storageBucket: 'ecommercesite-532ef.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzEtNbwUWKlb724mmfg8z73tJ_wnTmYTI',
    appId: '1:685831727373:android:a984e2b08c533cb883a844',
    messagingSenderId: '685831727373',
    projectId: 'ecommercesite-532ef',
    storageBucket: 'ecommercesite-532ef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0Zy9udMR25mBkqpiZpxiVNULMGQpX4q0',
    appId: '1:685831727373:ios:47112406844b53ec83a844',
    messagingSenderId: '685831727373',
    projectId: 'ecommercesite-532ef',
    storageBucket: 'ecommercesite-532ef.appspot.com',
    iosClientId: '685831727373-k7dqg2i6hdo15tge9tf6qm1br8in4smu.apps.googleusercontent.com',
    iosBundleId: 'com.example.userApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0Zy9udMR25mBkqpiZpxiVNULMGQpX4q0',
    appId: '1:685831727373:ios:47112406844b53ec83a844',
    messagingSenderId: '685831727373',
    projectId: 'ecommercesite-532ef',
    storageBucket: 'ecommercesite-532ef.appspot.com',
    iosClientId: '685831727373-k7dqg2i6hdo15tge9tf6qm1br8in4smu.apps.googleusercontent.com',
    iosBundleId: 'com.example.userApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAa0XIfrbDLRA0G_c85B3nl0g6BTgIPX4U',
    appId: '1:685831727373:web:6f66a69b075d283683a844',
    messagingSenderId: '685831727373',
    projectId: 'ecommercesite-532ef',
    authDomain: 'ecommercesite-532ef.firebaseapp.com',
    storageBucket: 'ecommercesite-532ef.appspot.com',
  );

}