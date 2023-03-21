import 'package:flutter/material.dart';

import '../widgets/drawer_widget.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Saved Posts'),
      ),
      body: const Center(
        child: Text('Saved Posts'),
      ),
    );
  }
}
