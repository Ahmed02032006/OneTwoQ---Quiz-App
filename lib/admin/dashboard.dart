// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:quiz_app/admin/appbar.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Title of the screen
//         title: const Text('Dashboard'),
//       ),
//       drawer: NavDrawer(), // Using the custom drawer
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 2),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(20),
//         height: MediaQuery.of(context).size.height * 0.2, // Set height to 30% of the screen height
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Welcome text
//             const Text(
//               'Welcome to OneTwoQ Dashboard!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center, // Center the text
//             ),
//             const SizedBox(height: 10),

//             // Current time text
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Text(
//                   'Current time: ',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//                 StreamBuilder(
//                   stream: Stream.periodic(const Duration(seconds: 1)),
//                   builder: (context, snapshot) {
//                     return Text(
//                       '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/admin/appbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isCategoriesDisplayed = false;

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('Settings')
          .doc('2fbG1GP9nX7XJrgGaA6H')
          .get();
      if (doc.exists) {
        var isCategoriesDisplay = doc.data()?['isCategoriesDisplayed'];
        setState(() {
          isCategoriesDisplayed = isCategoriesDisplay;
        });
      } else {
        debugPrint("Document does not exist");
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: NavDrawer(isCategoriesDisplayed: isCategoriesDisplayed), // Pass the value
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
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to OneTwoQ Dashboard!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
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
