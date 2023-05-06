// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CropRequestModel {
  String soilType;
  String district;
  double temperature;
  double humidity;
  double ph;
  double rainfall;
  double eveporation;
  CropRequestModel({
    this.soilType = '',
    this.district = '',
    this.temperature = 0,
    this.humidity = 0,
    this.ph = 0,
    this.rainfall = 0,
    this.eveporation = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'SoilType': soilType,
      'District': district,
      'temperature': temperature,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall,
      'eveporation': eveporation,
    };
  }

  factory CropRequestModel.fromMap(Map<String, dynamic> map) {
    return CropRequestModel(
      soilType: map['soilType'] as String,
      district: map['district'] as String,
      temperature: map['temperature'] as double,
      humidity: map['humidity'] as double,
      ph: map['ph'] as double,
      rainfall: map['rainfall'] as double,
      eveporation: map['eveporation'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropRequestModel.fromJson(String source) =>
      CropRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
