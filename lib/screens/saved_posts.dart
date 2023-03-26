import 'package:flutter/material.dart';
import 'package:govimithura/models/post_model.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/expandable_post.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Saved Posts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            10,
            (index) {
              return ExpandablePost(index: index, post: PostModel());
            },
          ),
        ),
      ),
    );
  }
}
