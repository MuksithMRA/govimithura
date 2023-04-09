import 'package:flutter/material.dart';
import 'package:govimithura/models/chat_response.dart';
import 'package:govimithura/providers/img_util_provider.dart';
import 'package:govimithura/services/ml_service.dart';
import 'package:govimithura/utils/utils.dart';

class MLProvider extends ChangeNotifier {
  ImageUtilProvider? pImage;
  List<ChatResponse> chatResponses = [];
  String messageText = "";

  MLProvider({this.pImage});

  Future<void> predictLeaf(BuildContext context) async {
    if (pImage?.imagePath != null) {
      String? response =
          await MLService.predictLeaf(pImage?.imagePath ?? '').then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(
                context, "Something went wrong , please try again");
          } else {
            return value;
          }
          return null;
        },
      );

      debugPrint(response);
    }
  }

  Future<void> predictSoil(BuildContext context) async {
    if (pImage?.imagePath != null) {
      String? response =
          await MLService.predictSoil(pImage?.imagePath ?? '').then(
        (value) {
          if (value == null) {
            Utils.showSnackBar(
                context, "Something went wrong , please try again");
          } else {
            return value;
          }
          return null;
        },
      );

      debugPrint(response);
    } else {
      Utils.showSnackBar(context, "Please choose an image");
    }
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
    await MLService.replyChat(pImage?.imagePath ?? '').then(
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
