import 'package:flutter/material.dart';

class CustomAssetImage extends StatelessWidget {
  final String assetName;
  const CustomAssetImage({super.key, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetName,
      fit: BoxFit.cover,
    );
  }
}
