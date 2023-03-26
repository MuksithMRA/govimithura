import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/utils/screen_size.dart';
import '../../constants/images.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        image: DecorationImage(
          image: AssetImage(Images.logo),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              image: DecorationImage(
                image: AssetImage(Images.logo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          spacingWidget(10, SpaceDirection.horizontal),
          Text(
            "Govi Mithura",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }
}

enum SpaceDirection { horizontal, vertical }

Widget spacingWidget(double size, SpaceDirection direction) {
  return direction == SpaceDirection.horizontal
      ? SizedBox(width: size)
      : SizedBox(height: size);
}

Widget confirmationDialog(BuildContext context,
    {required String title,
    void Function()? yesFunction,
    String additionalText = ""}) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (additionalText.isNotEmpty)
          Text(
            additionalText,
            style: const TextStyle(fontSize: 18),
          ),
        const Text(
          "Are you sure ",
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: yesFunction,
        child: const Text("Yes"),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("No"),
      ),
    ],
  );
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class CustomRatingBar extends StatelessWidget {
  final double rating;
  final double itemSize;
  final bool isReadOnly;
  const CustomRatingBar(
      {super.key,
      required this.rating,
      this.itemSize = 15,
      this.isReadOnly = true});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: isReadOnly,
      onRatingUpdate: (value) {},
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

Widget postStatus(String status) {
  Color color = Colors.green;
  if (status == PostStatus.pending) {
    color = Colors.orange;
  }
  if (status == PostStatus.rejected) {
    color = Colors.red;
  }
  return Row(
    children: [
      const Text(
        "Status: ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          status,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
