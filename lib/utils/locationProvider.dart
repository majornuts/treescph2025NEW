import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapProvider with ChangeNotifier {
  LatLng? _cameraPosition;
  double _latitude = 55.6791235;
  double _longitude = 12.5884377;
  double _cameraPositionZoom = 14;
  bool _isLoadingCurrentPosition = false;
  bool _locationPermissionGranted = false;

  LatLng? get cameraPosition => _cameraPosition;

  double get latitude => _latitude;

  double get longitude => _longitude;

  double get zoom => _cameraPositionZoom;

  bool get isLoadingCurrentPosition => _isLoadingCurrentPosition;

  bool get locationPermissionGranted => _locationPermissionGranted;
  Future<void>? _locationFuture;

  MapProvider() {
    _locationFuture = determinePosition();
  }

  void setCameraPosition(LatLng position) {
    _cameraPosition = position;
    notifyListeners();
  }

  void setLatitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  void setLongitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  void setZoom(double zoom) {
    _cameraPositionZoom = zoom;
    notifyListeners();
  }

  Future<void> determinePosition() async {
    _isLoadingCurrentPosition = true;
    notifyListeners();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _isLoadingCurrentPosition = false;
      _locationPermissionGranted = false;
      notifyListeners();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _isLoadingCurrentPosition = false;
        _locationPermissionGranted = false;
        notifyListeners();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _isLoadingCurrentPosition = false;
      _locationPermissionGranted = false;
      notifyListeners();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _locationPermissionGranted = true;
    final position = await Geolocator.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;
    _isLoadingCurrentPosition = false;
    notifyListeners();
  }

  Future<void> goToCurrentLocation() async {
    if (_locationPermissionGranted) {
      final position = await Geolocator.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
      notifyListeners();
    }
  }
  Future<void> get locationFuture async {
    return _locationFuture as Future<void>;
  }
}