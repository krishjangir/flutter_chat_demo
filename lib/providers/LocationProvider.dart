import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/data_models/UserLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {

  //constructor
  LocationProvider() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
            notifyListeners();
          }
        });
      }
    });
  }

  UserLocation _currentLocation;
  var location = Location();
  var _currentLocationAddress;

  //locationStream
  StreamController<UserLocation> _locationController =
  StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;


  //currentLocation getter
  get currentLocation => _currentLocation;

  //currentLocationAddress getter
  get currentLocationAddress => _currentLocationAddress;

 //get current lat long method
  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    notifyListeners();
    return _currentLocation;
  }

//get currentLocationAddress method
  Future getLocationAddress() async {
    try {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      _currentLocationAddress="${placemark[0].thoroughfare},${placemark[0].subThoroughfare},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].country}";
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    notifyListeners();
  }
}