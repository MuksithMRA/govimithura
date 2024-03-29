import 'package:flutter/material.dart';
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
