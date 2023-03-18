import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/img_util_provider.dart';

class Utils {
  static Future<ImageProvider<Object>> xFileToImage(XFile xFile) async {
    final Uint8List bytes = await xFile.readAsBytes();
    return Image.memory(bytes).image;
  }

  static Future<ImageProvider<Object>> croppedFileToImage(
      CroppedFile croppedFile) async {
    final Uint8List bytes = await croppedFile.readAsBytes();
    return Image.memory(bytes).image;
  }

  static Future pickImage(
      ImageSource source, Size size, BuildContext context) async {
    ImageUtilProvider imageUtilProvider = context.read<ImageUtilProvider>();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxHeight: size.height,
      maxWidth: size.width,
    );

    if (pickedFile != null) {
      await Utils.xFileToImage(pickedFile).then(
        (value) => {
          imageUtilProvider.image = value,
          imageUtilProvider.imagePath = pickedFile.path,
        },
      );
    }
  }

  static Future cropImage(BuildContext context, Size size) async {
    ImageUtilProvider imageUtilProvider = context.read<ImageUtilProvider>();
    if (imageUtilProvider.imagePath != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        maxHeight: size.height.toInt(),
        maxWidth: size.width.toInt(),
        sourcePath: imageUtilProvider.imagePath!,
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
              activeControlsWidgetColor: Theme.of(context).primaryColor,
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
        await Utils.croppedFileToImage(croppedFile).then((value) {
          imageUtilProvider.image = value;
          imageUtilProvider.imagePath = croppedFile.path;
        });
      }
    }
  }
}
