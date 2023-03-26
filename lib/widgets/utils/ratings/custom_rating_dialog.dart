import 'package:flutter/material.dart';
import '../common_widget.dart';
import 'custom_rating_bar.dart';

class CustomRatingDialog extends StatelessWidget {
  const CustomRatingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rate this post"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          spacingWidget(10, SpaceDirection.vertical),
          CustomRatingBar(
            givenRating: (rating) {
              debugPrint(rating.toString());
            },
            isReadOnly: false,
            itemSize: 30,
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
