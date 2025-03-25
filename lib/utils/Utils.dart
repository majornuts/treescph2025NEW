import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/FT.dart';

class CustomMarker extends StatelessWidget {
  final Features element;

  const CustomMarker(this.element, {super.key});

  void _launchMap(double latitude, double longitude) async {
    String url;
    if (Platform.isAndroid) {
      url =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$latitude,$longitude';
    } else {
      // Handle other platforms or provide a fallback URL
      url =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
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
                      _launchMap(
                        element.location.latitude,
                        element.location.longitude,
                      );
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
