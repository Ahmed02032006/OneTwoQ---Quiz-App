import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home.dart';

class Preloader extends StatefulWidget {
  late bool isAppActive;
  late String creditText;

  Preloader({
    super.key,
    required this.isAppActive,
    required this.creditText,
  });

  @override
  _PreloaderState createState() => _PreloaderState();
}

class _PreloaderState extends State<Preloader>
    with SingleTickerProviderStateMixin {
  bool isAppActive = false;
  String myCreditText = "";

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isAppActive = widget.isAppActive;
    myCreditText = widget.creditText;
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
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.02,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                myCreditText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: const Color.fromARGB(255, 13, 211, 19),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600
                ),
                maxLines: 3,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
