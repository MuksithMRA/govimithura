import 'package:dio/dio.dart';

class MLService {
  static Future<String?> predictLeaf(String filePath) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://asia-south1-ageless-aquifer-381515.cloudfunctions.net/predict-leaf";
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return data["class"];
    } on Exception catch (e) {
      print("Error  $e");
    }
    return null;
  }

  static Future<String?> predictSoil(String filePath) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://us-central1-ageless-aquifer-381515.cloudfunctions.net/predict-soil-1";
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return data["class"];
    } on Exception catch (e) {
      print("Error  $e");
    }
    return null;
  }

  static Future<String?> replyChat(String query) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://us-east1-ageless-aquifer-381515.cloudfunctions.net/chat-bot-1";
    FormData formData = FormData.fromMap({'query': query.trim()});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return data["answer"];
    } on Exception catch (e) {
      print("Error  $e");
    }
    return null;
  }
}
