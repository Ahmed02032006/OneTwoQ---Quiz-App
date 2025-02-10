import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home.dart';

class Preloader extends StatefulWidget {
  const Preloader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreloaderState createState() => _PreloaderState();
}

class _PreloaderState extends State<Preloader>
    with SingleTickerProviderStateMixin {
  bool isAppActive = false;
  bool hasDataAvailable = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchSettings();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animation
    _controller.forward();

    // Navigate after the animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (isAppActive && hasDataAvailable) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();
      if (doc.exists) {
        var isActive = doc.data()?['isAppOnline'];
        isAppActive = isActive;
        hasDataAvailable = true;
      } else {
        hasDataAvailable = false;
      }
    } catch (e) {
      print("Error fetching settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, -50 * (1 - _controller.value)),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/preloader.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
