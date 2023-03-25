import 'package:flutter/material.dart';
import 'package:govimithura/widgets/drawer_widget.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
