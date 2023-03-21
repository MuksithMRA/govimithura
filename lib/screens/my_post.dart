import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: Column(),
    );
  }
}
