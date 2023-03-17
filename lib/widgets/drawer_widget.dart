import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Theme.of(context).drawerTheme.endShape,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: const Text(
              'John Doe',
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: const Text('john@doe.com'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.person),
            title: const Text('About'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
