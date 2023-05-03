import 'dart:math';

import 'package:dio/dio.dart';
import 'package:govimithura/models/error_model.dart';

class MLService {
  static Future<int?> predictSoil(String filePath) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://us-central1-ageless-aquifer-381515.cloudfunctions.net/predict-soil-1";
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return int.tryParse(data["class"]);
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }

  static Future<int?> predictCrop(int soilId) async {
    // Dio dio = Dio();
    // const String apiUrl =
    //     "https://us-central1-ageless-aquifer-381515.cloudfunctions.net/predict-soil-1";
    // FormData formData =
    //     FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      // Response response = await dio.post(apiUrl, data: formData);
      // Map<String, dynamic> data = response.data;
      List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
      Random random = Random();
      int randomIndex = random.nextInt(numbers.length);
      int randomNumber = numbers[randomIndex];
      return randomNumber;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }

  static Future<int?> predictInsect(String filePath) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/ra-predict-pest";
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return int.tryParse(data["class"]);
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }

  static Future<int?> predictLeaf(String filePath) async {
    Dio dio = Dio();
    const String apiUrl =
        "https://asia-south1-ageless-aquifer-381515.cloudfunctions.net/predict-leaf";
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return int.tryParse(data["class"]);
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }

  static Future<int?> predictDisease(String filePath, int leafId) async {
    Dio dio = Dio();
    String apiUrl = _diseaseApiPipe(leafId);
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    try {
      Response response = await dio.post(apiUrl, data: formData);
      Map<String, dynamic> data = response.data;
      return int.tryParse(data["class"]);
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }

  static String _diseaseApiPipe(int leafId) {
    switch (leafId) {
      case 0:
        return 'https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/sa-predict-beans';
      case 1:
        return 'https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/sa-predict-cassava';
      case 2:
        return 'https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/sa-predict-corn';
      case 3:
        return 'https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/sa-predict-okra';
      case 4:
        return 'https://asia-southeast1-ageless-aquifer-381515.cloudfunctions.net/sa-predict-tomato';
      default:
        return '';
    }
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
      ErrorModel.errorMessage = e.toString();
    }
    return null;
  }
}
