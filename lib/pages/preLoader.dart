import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home.dart';

// ignore: must_be_immutable
class Preloader extends StatefulWidget {
  late bool isAppActive;

  Preloader({
    super.key,
    required this.isAppActive,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PreloaderState createState() => _PreloaderState();
}

class _PreloaderState extends State<Preloader>
    with SingleTickerProviderStateMixin {
  bool isAppActive = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isAppActive = widget.isAppActive;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Start animation
    _controller.forward();

    // Navigate after the animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("in preloader");
        print(isAppActive);
        if (isAppActive) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        }
        // Navigator.push(
        //   context,
        //   FadePageRoute(page: const Home()),
        // );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
