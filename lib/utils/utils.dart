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
    try {
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
    } on Exception catch (e) {
      Utils.showSnackBar(context, "Error: $e");
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

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static String toSnakeCase(String text) {
    return text.split(' ').map((e) => e.toLowerCase()).toList().join('_');
  }

  static String getAgoTime(DateTime dateTime) {
    Duration duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 365) {
      return '${(duration.inDays / 365).floor()} years ago';
    } else if (duration.inDays > 30) {
      return '${(duration.inDays / 30).floor()} months ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  //formatted date time considering with zero
  static String getFormattedDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
