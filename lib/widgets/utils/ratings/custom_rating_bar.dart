import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  final double rating;
  final double itemSize;
  final bool isReadOnly;
  final GivenRating? givenRating;
  const CustomRatingBar(
      {super.key,
      this.rating = 0,
      this.itemSize = 15,
      this.isReadOnly = true,
      this.givenRating});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: isReadOnly,
      onRatingUpdate: (value) {
        if (givenRating != null) {
          givenRating!(value);
        }
      },
      initialRating: rating,
      minRating: 0,
      itemSize: itemSize,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}

typedef GivenRating = void Function(double rating);
