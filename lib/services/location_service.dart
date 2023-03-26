import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:govimithura/models/error_model.dart';

class LocationService {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled. Please enable the services');
      throw Exception(
          "Location services are disabled. Please enable the services");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        throw Exception("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          'Location permissions are permanently denied, we cannot request permissions.');
      throw Exception(
          "Location permissions are permanently denied, please reinstall the app.");
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    Position? position;
    try {
      final hasPermission = await LocationService.handleLocationPermission();
      if (!hasPermission) return null;
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } on LocationServiceDisabledException catch (e) {
      ErrorModel.errorMessage = e.toString();
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }

    return position;
  }

  static Future<List<Placemark>?> getListOfPlaceMarks(GeoPoint geoPoint) async {
    List<Placemark>? listOfPlaceMarks;

    try {
      listOfPlaceMarks =
          await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
    } on LocationServiceDisabledException catch (e) {
      ErrorModel.errorMessage = e.toString();
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return listOfPlaceMarks;
  }
}
