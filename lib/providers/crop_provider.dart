import 'package:flutter/material.dart';
import 'package:govimithura/models/entity_model.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/services/crop_service.dart';
import 'package:govimithura/utils/utils.dart';

class CropProvider extends ChangeNotifier {
  EntityModel cropEntity = EntityModel();
  Future<void> getCropByName(BuildContext context) async {
    return await CropService.getCropByName(cropEntity.description)
        .then((value) {
      if (value != null) {
        cropEntity = EntityModel.fromMap(value.docs.first.data());
        notifyListeners();
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
        return null;
      }
    });
  }

  setCrop(String cropName) async {
    cropEntity.description = cropName;
    notifyListeners();
  }
}
