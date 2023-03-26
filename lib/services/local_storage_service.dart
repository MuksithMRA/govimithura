import 'package:govimithura/models/error_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<bool?> setStringValue(String key, String value) async {
    bool? isDone;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isDone = await pref.setString(key, value);
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return isDone;
  }
}
