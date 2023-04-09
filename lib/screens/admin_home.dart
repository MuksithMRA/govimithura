import 'package:flutter/material.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/providers/authentication_provider.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../utils/loading_overlay.dart';
import '../utils/utils.dart';
import '../widgets/utils/common_widget.dart';
import 'login.dart';
import 'my_post.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late AuthenticationProvider pAuthentication;
  late PostProvider pPost;
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    pAuthentication =
        Provider.of<AuthenticationProvider>(context, listen: false);
    pPost = Provider.of<PostProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Admin Home"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => confirmationDialog(
                  context,
                  title: "Logout from Govi Mithura",
                  yesFunction: () async {
                    await pAuthentication.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Post Approval",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () async {
                        await initialize();
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
              spacingWidget(15, SpaceDirection.vertical),
              ...List.generate(
                posts.length,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              SlidePageRoute(
                                  page: MyPost(
                                postId: posts[index].id,
                                isAdmin: true,
                              )));
                        },
                        title: Text(
                          posts[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text(Utils.getAgoTime(posts[index].createdAt!)),
                            spacingWidget(10, SpaceDirection.horizontal),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 30,
                        ),
                      ),
                      Row(
                        children: [
                          postStatus(posts[index].status),
                          if (posts[index].status == PostStatus.pending)
                            Flexible(
                              child: ButtonBar(
                                children: [
                                  FloatingActionButton.small(
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      heroTag: 'reject$index',
                                      onPressed: () async {
                                        PostModel post = posts[index];
                                        post.status = PostStatus.rejected;
                                        await LoadingOverlay.of(context).during(
                                            pPost.changePostStatus(post));
                                        await initialize();
                                      },
                                      child: const Icon(Icons.close)),
                                  FloatingActionButton.small(
                                    elevation: 0,
                                    backgroundColor: Colors.green,
                                    heroTag: 'approve$index',
                                    onPressed: () async {
                                      PostModel post = posts[index];
                                      post.status = PostStatus.approved;
                                      await LoadingOverlay.of(context)
                                          .during(pPost.changePostStatus(post));
                                      await initialize();
                                    },
                                    child: const Icon(Icons.done),
                                  ),
                                ],
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    posts = await LoadingOverlay.of(context).during(pPost.getAllPost());
    setState(() {});
  }
}
