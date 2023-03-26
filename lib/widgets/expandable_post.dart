import 'package:flutter/material.dart';
import 'package:govimithura/models/post_model.dart';
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
  bool isBookMarked = false;
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
                  onPressed: () {
                    if (isBookMarked) {
                      Utils.showSnackBar(context, "Bookmarked");
                    } else {
                      Utils.showSnackBar(context, "Removed from bookmark");
                    }
                  },
                  icon: isBookMarked
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
