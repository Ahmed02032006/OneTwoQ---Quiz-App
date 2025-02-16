import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/pages/controls.dart';
import 'package:quiz_app/pages/preLoader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
    runApp(DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ));
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        fontFamily: "Urbanist",
      ),
      home: const Preloader(),
      // home: const Controls(),
      // home: const Questions(),
      // home: const TrueRandomQuestions(),
      // home: const Options(),
      // home: const Categories(),
    );
  }
}
