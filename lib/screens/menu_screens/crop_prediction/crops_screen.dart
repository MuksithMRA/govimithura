import 'package:flutter/material.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/providers/location_provider.dart';
import 'package:govimithura/providers/ml_provider.dart';
import 'package:govimithura/screens/menu_screens/crop_prediction/crops_details_screen.dart';
import 'package:govimithura/utils/loading_overlay.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/image_util.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/utils.dart';
import '../../../widgets/utils/buttons/custom_elevated_button.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  late LocationProvider pLocation;
  late MLProvider pML;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pLocation = Provider.of<LocationProvider>(context, listen: false);
    pML = Provider.of<MLProvider>(context, listen: false);
    Future.delayed(Duration.zero, () => initialize());
  }

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
              child: Consumer<LocationProvider>(
                builder: (context, location, child) {
                  return Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: PrimaryTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nears District Required !';
                                } else {
                                  return null;
                                }
                              },
                              prefixIcon:
                                  const Icon(Icons.location_city_rounded),
                              onChanged: (value) {
                                location.setDistrict(value);
                              },
                              label: "Nearest District",
                              initialValue: location.locationModel.district,
                            )),
                            spacingWidget(10, SpaceDirection.horizontal),
                            Consumer<ImageUtilProvider>(
                              builder: (context, pImage, child) {
                                return CustomElevatedButton(
                                  text: "Predict",
                                  onPressed: () async {
                                    await onClickPredict(location, pImage);
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      spacingWidget(20, SpaceDirection.vertical),
                      Expanded(
                        child: Container(
                          //height: imageSize.height,
                          width: imageSize.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Provider.of<ImageUtilProvider>(context)
                                      .image ??
                                  const AssetImage("assets/images/soil.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton(
                            heroTag: "gallery",
                            backgroundColor: Theme.of(context)
                                .floatingActionButtonTheme
                                .backgroundColor,
                            onPressed: () async {
                              await Utils.pickImage(
                                ImageSource.gallery,
                                imageSize,
                                context,
                              );
                            },
                            child: const Icon(
                              Icons.image_rounded,
                            ),
                          ),
                          FloatingActionButton.large(
                            heroTag: "camera",
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
                            heroTag: "cropImage",
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
                  );
                },
              )),
        ),
      ],
    );
  }

  onClickPredict(LocationProvider location, ImageUtilProvider pImage) async {
    LoadingOverlay overlay = LoadingOverlay.of(context);
    if (pImage.imagePath != null && _formKey.currentState!.validate()) {
      pML.setNearestDistrict(location.locationModel.district);
      if (mounted) {
        await overlay.during(pML.getForecast(context));
      }
      if (mounted && pML.climateParameters.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CropDetailsScreen(
              pML: pML,
            ),
          ),
        );
      }
    } else {
      Utils.showSnackBar(context, "Please choose an image");
    }
  }

  Future<void> initialize() async {
    await LoadingOverlay.of(context)
        .during(pLocation.getCurrentPosition(context));
  }
}
