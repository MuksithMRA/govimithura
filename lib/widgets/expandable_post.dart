import 'package:flutter/material.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import 'utils/common_widget.dart';
import 'utils/ratings/custom_rating_bar.dart';
import 'utils/ratings/custom_rating_dialog.dart';

class ExpandablePost extends StatefulWidget {
  final int index;
  final PostModel post;
  const ExpandablePost({
    super.key,
    required this.index,
    required this.post,
  });

  @override
  State<ExpandablePost> createState() => _ExpandablePostState();
}

class _ExpandablePostState extends State<ExpandablePost> {
  late PostProvider pPost;

  @override
  void initState() {
    super.initState();
    pPost = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.index == 0,
      title: Text(
        widget.post.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
                title: Row(
                  children: [
                    const Text("Written By"),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => CustomRatingDialog(
                              postId: widget.post.id,
                              initialRating: widget.post.rating,
                            ),
                          );
                        },
                        child: CustomRatingBar(
                          rating: widget.post.rating,
                        ),
                      ),
                    ),
                    Text(
                      "(${widget.post.rateCount})",
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
                subtitle: const Text("john doe"),
                trailing: IconButton(
                  onPressed: () async {
                    LoadingOverlay overlay = LoadingOverlay.of(context);
                    if (widget.post.isSaved) {
                      bool isUnsaved = await overlay
                          .during(pPost.unSavePost(widget.post.id));
                      if (isUnsaved) {
                        if (mounted) {
                          Utils.showSnackBar(context, "Removed from bookmark");
                        }
                      }
                    } else {
                      bool isSaved =
                          await overlay.during(pPost.savePost(widget.post.id));
                      if (isSaved) {
                        if (mounted) {
                          Utils.showSnackBar(context, "Bookmarked");
                        }
                      }
                    }
                  },
                  icon: widget.post.isSaved
                      ? Icon(Icons.bookmark_rounded,
                          color: Theme.of(context).primaryColor)
                      : const Icon(Icons.bookmark_add_rounded),
                ),
              ),
              spacingWidget(10, SpaceDirection.vertical),
              Text(widget.post.content),
              spacingWidget(10, SpaceDirection.vertical),
            ],
          ),
        )
      ],
    );
  }
}
