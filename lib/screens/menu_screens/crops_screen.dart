import 'package:flutter/material.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/image_util.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/screen_size.dart';
import '../../utils/utils.dart';
import '../../widgets/utils/buttons/custom_elevated_button.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  @override
  Widget build(BuildContext context) {
    Size imageSize = Size(ScreenSize.width, ScreenSize.height * 0.45);
    return Stack(
      children: [
        Container(
          height: ScreenSize.height,
          width: ScreenSize.width,
          color: Theme.of(context).primaryColor,
          child: Column(
            children: const [CustomAssetImage(assetName: "crops_home.png")],
          ),
        ),
        Positioned(
          top: ScreenSize.height * 0.12,
          height: ScreenSize.height * 0.715,
          width: ScreenSize.width,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.width * 0.05,
              vertical: ScreenSize.height * 0.02,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: PrimaryTextField(
                          prefixIcon: Icon(Icons.location_on),
                          label: "Where do you live?"),
                    ),
                    spacingWidget(10, SpaceDirection.horizontal),
                    CustomElevatedButton(text: "Predict", onPressed: () {}),
                  ],
                ),
                spacingWidget(20, SpaceDirection.vertical),
                Container(
                  height: imageSize.height,
                  width: imageSize.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Provider.of<ImageUtilProvider>(context).image ??
                            const AssetImage("assets/images/crops_home.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      onPressed: () async {
                        await Utils.pickImage(
                            ImageSource.gallery, imageSize, context);
                      },
                      child: const Icon(
                        Icons.image_rounded,
                      ),
                    ),
                    FloatingActionButton.large(
                      backgroundColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      onPressed: () async {
                        await Utils.pickImage(
                            ImageSource.camera, imageSize, context);
                      },
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        size: 50,
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      onPressed: () async {
                        await Utils.cropImage(context, imageSize);
                      },
                      child: const Icon(
                        Icons.crop,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
