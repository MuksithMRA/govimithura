import 'package:flutter/material.dart';
import 'package:govimithura/constants/post_types.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/providers/insect_provider.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/screens/menu_screens/insects_prediction/insect_control_method_post.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/widgets/expandable_post.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:provider/provider.dart';

import '../../../constants/images.dart';
import '../../../providers/authentication_provider.dart';
import '../../../utils/utils.dart';

class InsectsControlMethodsScreen extends StatefulWidget {
  const InsectsControlMethodsScreen({super.key});

  @override
  State<InsectsControlMethodsScreen> createState() =>
      _InsectsControlMethodsScreenState();
}

class _InsectsControlMethodsScreenState
    extends State<InsectsControlMethodsScreen> {
  bool isBookMarked = false;
  late PostProvider pPost;
  late InsectProvider pInsect;
  String noPostMessage = '';

  @override
  void initState() {
    super.initState();
    pPost = Provider.of<PostProvider>(context, listen: false);
    pInsect = Provider.of<InsectProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Pest Control Methods'),
      ),
      body: Consumer<PostProvider>(
        builder: (context, pConsumer, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await initialize();
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        onBackgroundImageError: (exception, stackTrace) =>
                            Utils.showSnackBar(context, 'Error loading image'),
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 20,
                        backgroundImage: NetworkImage(context
                                .read<AuthenticationProvider>()
                                .getCurrentUser()
                                ?.photoURL ??
                            Images.defaultAvatar),
                      ),
                      spacingWidget(10, SpaceDirection.horizontal),
                      Flexible(
                          child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(
                                page: InsectControlMethodPost(
                              postRef: pInsect.selectedInsect.id,
                            )),
                          );
                        },
                        decoration: const InputDecoration(
                          hintText: 'Write a Method...',
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                if (pConsumer.posts.isEmpty) Center(child: Text(noPostMessage)),
                ...List.generate(
                  pConsumer.posts.length,
                  (index) => ExpandablePost(
                    index: index,
                    post: pConsumer.posts[index],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> initialize() async {
    PostModel postFilter = PostModel();
    postFilter.postType = PostType.pestControlMethod;
    postFilter.ref = pInsect.selectedInsect.id;
    pPost.setFilterPostModel(postFilter);
    pPost.setCurrentScreen('posts');
    List<PostModel> posts =
        await LoadingOverlay.of(context).during(pPost.getAllPostByType());
    if (posts.isEmpty) {
      noPostMessage = 'No posts available';
    }
    setState(() {});
  }
}
