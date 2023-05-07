import 'package:flutter/material.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/screens/my_post.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';

class MyPostList extends StatefulWidget {
  const MyPostList({super.key});

  @override
  State<MyPostList> createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
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
        title: const Text('My Pest Control Methods'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Consumer<PostProvider>(
              builder: (context, post, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (post.posts.isEmpty)
                      const Center(
                        child: Text('No Pest Control Methods found'),
                      ),
                    ...List.generate(
                      post.posts.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlidePageRoute(
                                      page: MyPost(
                                          postId: post.posts[index].id)));
                            },
                            title: Text(
                              '${post.posts[index].refModel!.name} - ${post.posts[index].title}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                Utils.getAgoTime(post.posts[index].createdAt!)),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              size: 30,
                            )),
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context).during(pPost.getPostsByUid());
    setState(() {});
  }
}
