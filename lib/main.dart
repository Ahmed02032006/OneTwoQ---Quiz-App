// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:quiz_app/firebase_options.dart';
// import 'package:quiz_app/pages/home.dart';
// import 'package:quiz_app/pages/preLoader.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     debugPrint('Firebase initialized successfully');
//     runApp(DevicePreview(
//       enabled: false,
//       builder: (context) => const MyApp(),
//     ));
//   } catch (e) {
//     debugPrint('Error initializing Firebase: $e');
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(
//         fontFamily: "Urbanist",
//       ),
//       home: Preloader(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/admin/dashboard.dart';
import 'package:quiz_app/firebase_options.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();

      if (doc.exists) {
        var isActive = doc.data()?['isAppOnline'];
        debugPrint("Fetched isAppActive: $isActive");
        return isActive ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: fetchSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        return MaterialApp(
          title: 'Quiz App',
          theme: ThemeData(
            fontFamily: "Urbanist",
          ),
          home: Preloader(isAppActive: snapshot.data ?? false),
        );
      },
    );
  }
}
