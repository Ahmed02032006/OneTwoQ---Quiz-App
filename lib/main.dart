import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/pages/stuck_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    runApp(DevicePreview(
      enabled: false,
      builder:(context) => const MyApp(),
    )); // Ensure the app is run after Firebase initialization
  } catch (e) {
    print('Error initializing Firebase: $e');
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
      home: const StuckScreen(),
      // home: const Preloader(),
    );
  }
}

// class Preloader extends StatefulWidget {
//   const Preloader({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PreloaderState createState() => _PreloaderState();
// }

// class _PreloaderState extends State<Preloader>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     // Start animation
//     _controller.forward();

//     // Navigate after the animation is complete
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => const Home(),
//             // builder: (context) => const Options(),
//             // builder: (context) => const Dashboard(),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0.0, -50 * (1 - _controller.value)),
//                   child: child,
//                 );
//               },
//               child: Image.asset(
//                 'assets/images/preloader.png',
//                 width: 150,
//                 height: 150,
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
