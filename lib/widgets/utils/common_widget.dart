import 'package:flutter/material.dart';
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
