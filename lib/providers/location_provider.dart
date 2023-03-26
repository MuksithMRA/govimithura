import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/services/location_service.dart';
import 'package:govimithura/services/weather_service.dart';
import 'package:govimithura/utils/utils.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  double? currentLocationTemp;
  String? currentAddress;
  Future<void> getCurrentPosition(BuildContext context) async {
    await LocationService.getCurrentPosition().then((Position? position) {
      if (position == null) {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      } else {
        currentPosition = position;
        GeoPoint geoPoint =
            GeoPoint(currentPosition!.latitude, currentPosition!.longitude);
        _getAddressFromLatLng(geoPoint, context);
        notifyListeners();
      }
    });
  }

  Future<void> getCurrentLocationTemp(BuildContext context) async {
    await getCurrentPosition(context);
    if (currentPosition != null) {
      GeoPoint geoPoint =
          GeoPoint(currentPosition!.latitude, currentPosition!.longitude);
      return await WeatherService.getCurrentTemprature(geoPoint)
          .then((currentTemp) {
        currentLocationTemp = currentTemp;
        notifyListeners();
      });
    }
  }

  Future<void> _getAddressFromLatLng(
      GeoPoint geoPoint, BuildContext context) async {
    await LocationService.getListOfPlaceMarks(geoPoint)
        .then((List<Placemark>? placemarks) {
      if (placemarks != null) {
        if (placemarks.isEmpty) {
          Utils.showSnackBar(context, "No Location found");
          return;
        }
        Placemark place = placemarks[1];
        if (place.street != null && place.street!.isNotEmpty) {
          currentAddress = place.street;
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          currentAddress = '$currentAddress, ${place.subLocality}';
        }
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          currentAddress = '$currentAddress, ${place.subAdministrativeArea}';
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          currentAddress = '$currentAddress, ${place.postalCode}';
        }
        notifyListeners();
      } else {
        Utils.showSnackBar(context, ErrorModel.errorMessage);
      }
    });
  }
}
