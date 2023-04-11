import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/insect_model.dart';
import 'package:govimithura/services/insect_service.dart';
import 'package:govimithura/utils/utils.dart';

class InsectProvider extends ChangeNotifier {
  InsectModel selectedInsect = InsectModel();

  Future<void> getInsectById(BuildContext context) async {
    await InsectService.getInsectById(selectedInsect.id).then((value) {
      if (value != null) {
        selectedInsect = InsectModel.fromJson(value.data()!);
        notifyListeners();
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      }
    });
  }

  void setSelectedInsect(InsectModel insect) {
    selectedInsect = insect;
    notifyListeners();
  }

  void setSelectedInsectId(int id) {
    selectedInsect.id = id;
    notifyListeners();
  }
}
