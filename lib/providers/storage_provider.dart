import 'dart:io';

import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/services/storage_service.dart';
import 'package:govimithura/utils/utils.dart';

class StorageProvider extends ChangeNotifier {
  final ImageUtilProvider? pImage;

  StorageProvider({this.pImage});

  Future<String?> uploadImage(BuildContext context) async {
    if (pImage!.imagePath != null) {
      return await StorageService.uploadImage(File(pImage!.imagePath!)).then(
        (value) {
          if (value != null) {
            pImage!.setImageUrl(value);
            return value;
          } else {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
          }
          return null;
        },
      );
    }
    return null;
  }
}
