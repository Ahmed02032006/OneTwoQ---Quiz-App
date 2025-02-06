import 'package:flutter/material.dart';
import 'package:quiz_app/admin/dashboard.dart';
import 'package:quiz_app/admin/screens/category.dart';
import 'package:quiz_app/admin/screens/questions.dart';
import 'package:quiz_app/admin/screens/subcategory.dart'; // Import the category.dart file

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

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
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ), // Navigate to Category screen
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_rounded),
            title: const Text('Category'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Category(),
                ), // Navigate to Category screen
              );
            },
          ),
        ],
      ),
    );
  }
}
