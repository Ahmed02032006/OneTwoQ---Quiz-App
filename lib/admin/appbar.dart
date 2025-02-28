// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quiz_app/admin/dashboard.dart';
// import 'package:quiz_app/admin/screens/category.dart';

// class NavDrawer extends StatefulWidget {
//   const NavDrawer({super.key});

//   @override
//   State<NavDrawer> createState() => _NavDrawerState();
// }

// class _NavDrawerState extends State<NavDrawer> {
//   bool isCategoriesDisplayed = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchSettings();
//   }

//   Future<void> fetchSettings() async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
//           .instance
//           .collection('Settings')
//           .doc('2fbG1GP9nX7XJrgGaA6H')
//           .get();
//       if (doc.exists) {
//         var isCategoriesDisplay = doc.data()?['isCategoriesDisplayed'];
//         setState(() {
//           isCategoriesDisplayed = isCategoriesDisplay;
//         });
//       } else {
//         debugPrint("Document does not exist");
//       }
//     } catch (e) {
//       debugPrint("Error fetching settings: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Image.asset('assets/images/preloader.png'),
//           ),
//           ListTile(
//             leading: const Icon(Icons.input),
//             title: const Text('Welcome'),
//             onTap: () {
//               Navigator.of(context).pop(); // Close the drawer
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const Dashboard(),
//                 ), // Navigate to Category screen
//               );
//             },
//           ),
//           if (isCategoriesDisplayed)
//             ListTile(
//               leading: const Icon(Icons.category_rounded),
//               title: const Text('Category'),
//               onTap: () {
//                 Navigator.of(context).pop(); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Category(),
//                   ), // Navigate to Category screen
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quiz_app/admin/dashboard.dart';
import 'package:quiz_app/admin/screens/category.dart';

class NavDrawer extends StatelessWidget {
  final bool isCategoriesDisplayed;

  const NavDrawer({
    super.key,
    this.isCategoriesDisplayed = true,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset('assets/images/preloader.png'),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            },
          ),
          if (isCategoriesDisplayed)
            ListTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('Category'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Category(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
