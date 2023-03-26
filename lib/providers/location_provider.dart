import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:govimithura/services/location_service.dart';
import 'package:govimithura/services/weather_service.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  double? currentLocationTemp;
  String? currentAddress;
  Future<void> getCurrentPosition() async {
    final hasPermission = await LocationService.handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getCurrentLocationTemp() async {
    await getCurrentPosition();
    if (currentPosition != null) {
      GeoPoint geoPoint =
          GeoPoint(currentPosition!.latitude, currentPosition!.longitude);
      return await WeatherService.getCurrentTemprature(geoPoint)
          .then((currentTemp) {
        currentLocationTemp = currentTemp;
        _getAddressFromLatLng();
        notifyListeners();
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
