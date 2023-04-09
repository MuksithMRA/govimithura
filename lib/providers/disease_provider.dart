import 'package:flutter/foundation.dart';
import 'package:govimithura/models/entity_model.dart';
import 'package:govimithura/services/disease_service.dart';

class DiseaseProvider extends ChangeNotifier {
  EntityModel entityModel = EntityModel();
  getLeafsById(int id) async {
    var response = await DiseaseService.getLeafsById(id);
    if (response != null) {
      if (response.docs.isNotEmpty) {
        entityModel = EntityModel.fromMap(response.docs.first.data());
      }
    }
    notifyListeners();
  }
}
