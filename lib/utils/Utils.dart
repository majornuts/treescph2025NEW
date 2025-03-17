import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/FT.dart';

class CustomMarker extends StatelessWidget {
  final Features element;

  const CustomMarker(this.element, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(element.properties.danskNavn),
              content: Text(
                'Latin : ${element.properties.slaegt} \n'
                    'Plante år : ${element.properties.planteaar} \n'
                    'latitude : ${element.location.latitude} \nlongitude : ${element.location.longitude} \n'
                    'id : ${element.properties.id} \n',
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