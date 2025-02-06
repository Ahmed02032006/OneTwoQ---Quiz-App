import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/admin/appbar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title of the screen
        title: const Text('Dashboard'),
      ),
      drawer: const NavDrawer(), // Using the custom drawer
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.2, // Set height to 30% of the screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome text
            const Text(
              'Welcome to OneTwoQ Dashboard!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center the text
            ),
            const SizedBox(height: 10),

            // Current time text
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Current time: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
