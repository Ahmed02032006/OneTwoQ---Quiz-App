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
