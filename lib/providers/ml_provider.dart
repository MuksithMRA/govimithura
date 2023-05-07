import 'package:flutter/material.dart';
import 'package:govimithura/models/chat_response.dart';
import 'package:govimithura/models/climate_parameter.dart';
import 'package:govimithura/models/crop_request_model.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/services/ml_service.dart';
import 'package:govimithura/utils/utils.dart';
import '../models/entity_model.dart';

class MLProvider extends ChangeNotifier {
  ImageUtilProvider? pImage;
  List<ChatResponse> chatResponses = [];
  String messageText = "";
  String nearestDistrict = '';
  double ph = 0;
  String soilType = '';
  List<ClimateParameter> climateParameters = [];
  String bestCrop = '';

  MLProvider({this.pImage});

  Future<int> predictLeaf(BuildContext context) async {
    if (pImage?.imagePath != null) {
      int? response = await MLService.predictLeaf(pImage?.imagePath ?? '').then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
          } else {
            return value;
          }
          return null;
        },
      );
      debugPrint(response.toString());
      return response ?? 0;
    }
    return 0;
  }

  Future<int> predictDisease(BuildContext context, int leafId) async {
    if (pImage?.imagePath != null) {
      int? response =
          await MLService.predictDisease(pImage?.imagePath ?? '', leafId).then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
          } else {
            return value;
          }
          return null;
        },
      );
      return response ?? 0;
    }
    return 0;
  }

  Future<String> predictSoil(BuildContext context) async {
    if (pImage?.imagePath != null) {
      String? response =
          await MLService.predictSoil(pImage?.imagePath ?? '').then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
            return null;
          } else {
            List<EntityModel> soilTypes = [
              EntityModel(id: 0, description: "dry"),
              EntityModel(id: 1, description: "intermediate"),
              EntityModel(id: 2, description: "highWater"),
            ];
            soilType = soilTypes
                .firstWhere((element) => element.id == value)
                .description;
            return soilType;
          }
        },
      );
      soilType = response ?? '';
      return soilType;
    } else {
      ErrorModel.errorMessage = "Please choose an image";
      Utils.showSnackBar(context, "Please choose an image");
      return '';
    }
  }

  Future<String> predictCrop(BuildContext context) async {
    String response = '';

    CropRequestModel cropRequestModel = CropRequestModel();
    cropRequestModel.soilType = soilType;
    cropRequestModel.district = nearestDistrict;
    cropRequestModel.ph = ph;
    if (climateParameters.isNotEmpty) {
      cropRequestModel.eveporation = climateParameters[0].y;
      cropRequestModel.humidity = climateParameters[1].y;
      cropRequestModel.rainfall = climateParameters[2].y;
      cropRequestModel.temperature = climateParameters[3].y;
      response = await MLService.predictCrop(cropRequestModel).then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
            return '';
          } else {
            return value;
          }
        },
      );
    }

    setBestCrop(response);
    return response;
  }

  Future<List<ClimateParameter>> getForecast(BuildContext context) async {
    List<ClimateParameter> response = [];
    if (nearestDistrict.isNotEmpty) {
      return await MLService.getForecast(nearestDistrict).then((forecast) {
        if (forecast != null) {
          climateParameters = forecast;
          return climateParameters;
        } else {
          // ignore: use_build_context_synchronously
          Utils.showSnackBar(context, ErrorModel.errorMessage);
          return [];
        }
      });
    } else {
      return response;
    }
  }

  Future<int> predictInsect(BuildContext context) async {
    if (pImage?.imagePath != null) {
      int? response =
          await MLService.predictInsect(pImage?.imagePath ?? '').then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
          } else {
            return value;
          }
          return null;
        },
      );
      return response ?? 0;
    } else {
      ErrorModel.errorMessage = "Please choose an image";
      Utils.showSnackBar(context, ErrorModel.errorMessage);
    }
    return 0;
  }

  Future replyChat() async {
    ChatResponse request = ChatResponse(isResponse: false);
    request.message = messageText;
    chatResponses.add(request);
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    chatResponses.add(
      ChatResponse(status: ChatStatus.typing, message: "Typing..."),
    );
    notifyListeners();
    await MLService.replyChat(request.message).then(
      (value) {
        ChatResponse response = ChatResponse();
        if (value == null) {
          response.status = ChatStatus.error;
        } else {
          response.message = value;
        }
        chatResponses.removeLast();
        chatResponses.add(response);
        debugPrint("${response.status}   ${response.message}");
        notifyListeners();
      },
    );
  }

  setMessgeText(String message) {
    messageText = message;
    notifyListeners();
  }

  setNearestDistrict(String district) {
    nearestDistrict = district[0].toUpperCase() + district.substring(1);
  }

  setBestCrop(String bestCrop) async {
    this.bestCrop = bestCrop;
  }

  setPHValue(double ph) {
    this.ph = ph;
  }
}
