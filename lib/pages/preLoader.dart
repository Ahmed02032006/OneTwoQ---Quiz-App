import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home.dart';

class Preloader extends StatefulWidget {
  late bool isAppActive;

  Preloader({
    super.key,
    required this.isAppActive,
  });

  @override
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
        if (isAppActive) {
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           AnimatedBuilder(
  //             animation: _controller,
  //             builder: (context, child) {
  //               return Transform.translate(
  //                 offset: Offset(0.0, -50 * (1 - _controller.value)),
  //                 child: child,
  //               );
  //             },
  //             child: Image.asset(
  //               'assets/images/preloader.png',
  //               width: 150,
  //               height: 150,
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //         ],
  //       ),
  //     ),
  //   );
  // }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
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
          // Positioned(
          //   bottom: MediaQuery.of(context).size.height * 0.02,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Designed & Developed By ",
          //         style: TextStyle(
          //           fontSize: MediaQuery.of(context).size.width * 0.04,
          //           color: Colors.grey[600],
          //           letterSpacing: 1.7,
          //         ),
          //       ),
          //       Text(
          //         "amddevanddesign",
          //         style: TextStyle(
          //           fontSize: MediaQuery.of(context).size.width * 0.04,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.grey[800],
          //           letterSpacing: 1.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
