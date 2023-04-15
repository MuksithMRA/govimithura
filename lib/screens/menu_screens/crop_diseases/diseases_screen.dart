import 'package:flutter/material.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/widgets/utils/buttons/custom_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/img_util_provider.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/utils.dart';
import '../../../widgets/utils/common_widget.dart';
import '../../../widgets/utils/image_util.dart';
import 'disease_details_screen.dart';

class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({super.key});

  @override
  State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  @override
  Widget build(BuildContext context) {
    Size imageSize = Size(ScreenSize.width, ScreenSize.height * 0.45);
    return Consumer<ImageUtilProvider>(
      builder: (context, pImage, child) {
        return Stack(
          children: [
            Container(
              height: ScreenSize.height,
              width: ScreenSize.width,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: const [
                  CustomAssetImage(assetName: "diseases_home.png")
                ],
              ),
            ),
            Positioned(
              top: ScreenSize.height * 0.12,
              height: ScreenSize.height * 0.725,
              width: ScreenSize.width,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width * 0.05,
                  vertical: ScreenSize.height * 0.02,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    ButtonBar(
                      children: [
                        CustomElevatedButton(
                          text: "Predict",
                          onPressed: () async {
                            if (pImage.imagePath == null) {
                              Utils.showSnackBar(
                                  context, "Please select an image");
                              return;
                            }
                            MLProvider pML =
                                Provider.of<MLProvider>(context, listen: false);
                            LoadingOverlay overlay = LoadingOverlay.of(context);
                            int leafId =
                                await overlay.during(pML.predictLeaf(context));
                            if (mounted) {
                              int diseaseId = await overlay
                                  .during(pML.predictDisease(context));
                              if (mounted && leafId >= 0 && diseaseId >= 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseaseDetailsScreen(
                                      leafId: leafId,
                                      diseaseId: diseaseId,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    spacingWidget(10, SpaceDirection.vertical),
                    Container(
                      height: imageSize.height,
                      width: imageSize.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: pImage.image ??
                                const AssetImage(
                                    "assets/images/diseases_home.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: [
                        FloatingActionButton(
                          heroTag: 'gallery',
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
                          heroTag: 'camera',
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
                          heroTag: 'crop',
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
      },
    );
  }
}
