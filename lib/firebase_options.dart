// Firebase client settings are supplied from an ignored local JSON file.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Firebase is configured for web only. Configure this platform '
      'before running it.',
    );
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: _required(
          const String.fromEnvironment('FIREBASE_API_KEY'),
          'FIREBASE_API_KEY',
        ),
        appId: _required(
          const String.fromEnvironment('FIREBASE_APP_ID'),
          'FIREBASE_APP_ID',
        ),
        messagingSenderId: _required(
          const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _required(
          const String.fromEnvironment('FIREBASE_PROJECT_ID'),
          'FIREBASE_PROJECT_ID',
        ),
        authDomain: _required(
          const String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
          'FIREBASE_AUTH_DOMAIN',
        ),
        storageBucket: _required(
          const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
          'FIREBASE_STORAGE_BUCKET',
        ),
        measurementId: _required(
          const String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
          'FIREBASE_MEASUREMENT_ID',
        ),
      );

  static String _required(String value, String name) {
    if (value.isEmpty) {
      throw StateError(
        'Firebase is not configured. Copy firebase.local.json.example to '
        'firebase.local.json, fill in your app settings, and run Flutter with '
        '--dart-define-from-file=firebase.local.json.',
      );
    }
    return value;
  }
}
