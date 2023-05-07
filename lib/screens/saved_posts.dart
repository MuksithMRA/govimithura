import 'package:flutter/material.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../utils/loading_overlay.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/expandable_post.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  late PostProvider pPost;

  @override
  void initState() {
    super.initState();
    pPost = Provider.of<PostProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Saved Pest Control Methods'),
      ),
      body: SingleChildScrollView(child: Consumer<PostProvider>(
        builder: (context, post, child) {
          return Column(
            children: List.generate(
              post.posts.length,
              (index) {
                return ExpandablePost(index: index, post: post.posts[index]);
              },
            ),
          );
        },
      )),
    );
  }

  Future<void> initialize() async {
    pPost.setCurrentScreen('saved_posts');
    await LoadingOverlay.of(context).during(pPost.getAllSavedPost());
    setState(() {});
  }
}
