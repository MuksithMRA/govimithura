import 'package:flutter/material.dart';
import 'package:govimithura/models/entity_model.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/services/disease_service.dart';
import 'package:govimithura/utils/utils.dart';

class DiseaseProvider extends ChangeNotifier {
  EntityModel leafEntity = EntityModel();
  EntityModel diseaseEntity = EntityModel();
  Future<void> getLeafsById(int id, int diseaseId, BuildContext context) async {
    await DiseaseService.getLeafsById(id).then((value) {
      if (value != null) {
        if (value.docs.isNotEmpty) {
          leafEntity = EntityModel.fromMap(value.docs.first.data());
          getDiseaseById(value.docs.first.id, diseaseId, context);
        }
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      }
    });
    notifyListeners();
  }

  Future<void> getDiseaseById(
      String leafRef, int id, BuildContext context) async {
    await DiseaseService.getDiseaseById(leafRef, id).then((value) {
      if (value != null) {
        if (value.docs.isNotEmpty) {
          diseaseEntity = EntityModel.fromMap(value.docs.first.data());
        }
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      }
    });
    notifyListeners();
  }
}
