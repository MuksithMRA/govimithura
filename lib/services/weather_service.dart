import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<double?> getCurrentTemprature(GeoPoint geoPoint) async {
    String api =
        'https://api.open-meteo.com/v1/forecast?latitude=${geoPoint.latitude}&longitude=${geoPoint.longitude}&current_weather=true';
    double? currentTemprature;
    try {
      var response = await http.get(Uri.parse(api));
      var body = jsonDecode(response.body);
      currentTemprature = body['current_weather']['temperature'];
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return currentTemprature;
  }
}
