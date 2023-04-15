import 'package:flutter/material.dart';
import 'package:govimithura/constants/images.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/screens/home.dart';
import 'package:govimithura/screens/my_post_list.dart';
import 'package:govimithura/screens/my_profile.dart';
import 'package:provider/provider.dart';

import '../screens/saved_posts.dart';
import '../utils/utils.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late AuthenticationProvider pAuthentication;

  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Theme.of(context).drawerTheme.endShape,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              onBackgroundImageError: (exception, stackTrace) =>
                  Utils.showSnackBar(context, 'Error loading image'),
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: NetworkImage(
                  pAuthentication.getCurrentUser()?.photoURL ??
                      Images.defaultAvatar),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              pAuthentication.getCurrentUser()!.displayName.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            accountEmail:
                Text(pAuthentication.getCurrentUser()!.email.toString()),
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MyPostList()));
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
