import 'package:flutter/material.dart';
import 'package:govimithura/models/chat_response.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/services/ml_service.dart';
import 'package:govimithura/utils/utils.dart';

class MLProvider extends ChangeNotifier {
  ImageUtilProvider? pImage;
  List<ChatResponse> chatResponses = [];
  String messageText = "";

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

  Future<int> predictSoil(BuildContext context) async {
    if (pImage?.imagePath != null) {
      int? response = await MLService.predictSoil(pImage?.imagePath ?? '').then(
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
    } else {
      ErrorModel.errorMessage = "Please choose an image";
      Utils.showSnackBar(context, ErrorModel.errorMessage);
    }
    return 0;
  }

  Future<int> predictCrop(BuildContext context) async {
    int? response = await predictSoil(context).then((soilId) async {
      int? response = await MLService.predictCrop(soilId).then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(context, ErrorModel.errorMessage);
          } else {
            return value;
          }
          return null;
        },
      );
      return response ?? -1;
    });
    return response ?? -1;
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
}
