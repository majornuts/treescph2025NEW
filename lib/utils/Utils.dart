import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/FT.dart';

class CustomMarker extends StatelessWidget {
  final Features element;

  const CustomMarker(this.element, {super.key});

  void _launchMap(double latitude, double longitude) async {
    String url;
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$latitude,$longitude';
    } else {
      // Handle other platforms or provide a fallback URL
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      print("Error launching map: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(element.properties.danskNavn),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latin : ${element.properties.slaegt} \n'
                        'Plante år : ${element.properties.planteaar} \n'
                        'latitude : ${element.location.latitude} \n'
                        'longitude : ${element.location.longitude} \n'
                        'id : ${element.properties.id} \n',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _launchMap(element.location.latitude,
                          element.location.longitude);
                    },
                    child: const Text('Open in Maps'),
                  ),
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Image.asset('assets/tree.png'),
    );
  }
}

class MapProvider with ChangeNotifier {
  LatLng? _cameraPosition;
  double _latitude = 55.6791235;
  double _longitude = 12.5884377;
  double _cameraPositionZoom = 14;

  LatLng? get cameraPosition => _cameraPosition;

  double get latitude => _latitude;

  double get longitude => _longitude;

  double get zoom => _cameraPositionZoom;

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
}