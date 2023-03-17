import 'package:flutter/material.dart';

class CustomAssetImage extends StatelessWidget {
  final String assetName;
  final BoxFit fit;
  const CustomAssetImage(
      {super.key, required this.assetName, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/$assetName",
      fit: fit,
    );
  }
}
