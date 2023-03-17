import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:govimithura/widgets/utils/common_widget.dart';
import 'package:govimithura/widgets/utils/image_util.dart';
import 'package:govimithura/widgets/utils/text_fields/primary_textfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/screen_size.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  final ImagePicker _picker = ImagePicker();
  ImageProvider? _image;
  XFile? pickedFile;
  @override
  Widget build(BuildContext context) {
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
                const PrimaryTextField(
                    prefixIcon: Icon(Icons.location_on),
                    label: "Where do you live?"),
                spacingWidget(20, SpaceDirection.vertical),
                Container(
                  height: ScreenSize.height * 0.45,
                  width: ScreenSize.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _image ??
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
                        pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: ScreenSize.height * 0.45,
                          maxWidth: ScreenSize.width,
                        );
                        if (pickedFile != null) {
                          await xFileToImage(pickedFile!).then((value) {
                            setState(() {
                              _image = value;
                            });
                          });
                        }
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
                        pickedFile = await _picker.pickImage(
                          source: ImageSource.camera,
                          maxHeight: ScreenSize.height * 0.45,
                          maxWidth: ScreenSize.width,
                        );
                        if (pickedFile != null) {
                          await xFileToImage(pickedFile!).then((value) {
                            setState(() {
                              _image = value;
                            });
                          });
                        }
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
                        if (pickedFile == null) {
                          return;
                        }
                        CroppedFile? croppedFile =
                            await ImageCropper().cropImage(
                          sourcePath: pickedFile!.path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Cropper Your Image',
                                toolbarColor: Theme.of(context).primaryColor,
                                toolbarWidgetColor: Colors.white,
                                activeControlsWidgetColor:
                                    Theme.of(context).primaryColor,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'Cropper Your Image',
                            ),
                            WebUiSettings(
                              context: context,
                            ),
                          ],
                        );

                        if (croppedFile != null) {
                          await croppedFileToImage(croppedFile).then((value) {
                            setState(() {
                              _image = value;
                            });
                          });
                        }
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

Future<ImageProvider<Object>> xFileToImage(XFile xFile) async {
  final Uint8List bytes = await xFile.readAsBytes();
  return Image.memory(bytes).image;
}

Future<ImageProvider<Object>> croppedFileToImage(
    CroppedFile croppedFile) async {
  final Uint8List bytes = await croppedFile.readAsBytes();
  return Image.memory(bytes).image;
}
