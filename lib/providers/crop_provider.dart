import 'package:flutter/material.dart';
import 'package:govimithura/models/entity_model.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/services/crop_service.dart';
import 'package:govimithura/utils/utils.dart';

class CropProvider extends ChangeNotifier {
  EntityModel cropEntity = EntityModel();
  Future<void> getCropById(BuildContext context) async {
    await CropService.getCropById(cropEntity.id).then((value) {
      if (value != null) {
        cropEntity = EntityModel.fromMap(value.docs.first.data());
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      }
    });
  }

  setCropId(int id) {
    cropEntity.id = id;
    notifyListeners();
  }
}
