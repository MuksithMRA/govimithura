import 'package:flutter/material.dart';
import 'package:govimithura/screens/home.dart';
import 'package:govimithura/screens/my_post.dart';
import 'package:govimithura/screens/my_profile.dart';

import '../screens/saved_posts.dart';

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
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Home()));
            },
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MyProfile()));
            },
            leading: const Icon(Icons.person_rounded),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MyPosts()));
            },
            leading: const Icon(Icons.post_add_rounded),
            title: const Text('My Posts'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SavedPosts()));
            },
            leading: const Icon(Icons.bookmark_rounded),
            title: const Text('Saved'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.contact_phone_rounded),
            title: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
