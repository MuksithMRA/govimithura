import 'package:flutter/material.dart';
import 'package:govimithura/providers/post_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../common_widget.dart';
import 'custom_rating_bar.dart';

class CustomRatingDialog extends StatefulWidget {
  final String postId;
  final double initialRating;
  const CustomRatingDialog(
      {super.key, required this.initialRating, required this.postId});

  @override
  State<CustomRatingDialog> createState() => _CustomRatingDialogState();
}

class _CustomRatingDialogState extends State<CustomRatingDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, pPost, child) {
        return AlertDialog(
          title: const Text("Rate this post"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              spacingWidget(10, SpaceDirection.vertical),
              CustomRatingBar(
                rating: widget.initialRating,
                givenRating: (rating) {
                  pPost.setGivenRating(rating);
                },
                isReadOnly: false,
                itemSize: 40,
                key: const Key("rating"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                bool success = await LoadingOverlay.of(context)
                    .during(pPost.addRating(widget.postId));
                if (success) {
                  pPost.setGivenRating(0);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> initialize() async {}
}
