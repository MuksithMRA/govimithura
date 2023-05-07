import 'package:flutter/material.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/screens/admin_home.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/utils/utils.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/utils/ratings/custom_rating_bar.dart';

class MyPost extends StatefulWidget {
  final String postId;
  final bool isAdmin;
  const MyPost({super.key, required this.postId, this.isAdmin = false});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late PostProvider pPost;
  PostModel post = PostModel();

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
        appBar: AppBar(
          title: const Text('My Pest Control Methods'),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) => confirmationDialog(
                    context,
                    title: "Delete Pest Control Method",
                    yesFunction: () async {
                      bool isSuccess = await LoadingOverlay.of(context)
                          .during(pPost.deletePost(widget.postId));
                      if (mounted && isSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminHome(),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                spacingWidget(10, SpaceDirection.vertical),
                if (post.status != PostStatus.pending)
                  Row(
                    children: [
                      CustomRatingBar(
                        rating: post.rating,
                        itemSize: 20,
                      ),
                      spacingWidget(5, SpaceDirection.horizontal),
                      Text(
                        '(${post.rateCount})',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                spacingWidget(10, SpaceDirection.vertical),
                Text(
                  'Posted on ${post.formattedDateTime}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                spacingWidget(10, SpaceDirection.vertical),
                postStatus(post.status),
                if (widget.isAdmin && post.status == PostStatus.pending)
                  Column(
                    children: [
                      spacingWidget(10, SpaceDirection.vertical),
                      Row(
                        children: [
                          const Text(
                            "Post Approval",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: ButtonBar(
                              children: [
                                FloatingActionButton.small(
                                    elevation: 0,
                                    backgroundColor: Colors.red,
                                    heroTag: 'reject',
                                    onPressed: () async {
                                      post.status = PostStatus.rejected;
                                      await LoadingOverlay.of(context)
                                          .during(pPost.changePostStatus(post));
                                      await initialize();
                                    },
                                    child: const Icon(Icons.close)),
                                FloatingActionButton.small(
                                  elevation: 0,
                                  backgroundColor: Colors.green,
                                  heroTag: 'approve',
                                  onPressed: () async {
                                    post.status = PostStatus.approved;
                                    await LoadingOverlay.of(context)
                                        .during(pPost.changePostStatus(post));
                                    await initialize();
                                  },
                                  child: const Icon(Icons.done),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                spacingWidget(50, SpaceDirection.vertical),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> initialize() async {
    post = await LoadingOverlay.of(context)
        .during(pPost.getPostsById(widget.postId));
    post.formattedDateTime = Utils.getFormattedDateTime(post.createdAt!);
    setState(() {});
  }
}
