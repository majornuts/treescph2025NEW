import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/DataApi.dart';
import '../data/FT.dart';
import '../utils/Utils.dart';
import '../utils/locationProvider.dart';

class ClusterMap extends StatefulWidget {
  final List<String> filteredData;

  ClusterMap({Key? key, required this.filteredData}) : super(key: key);

  @override
  State<ClusterMap> createState() => _ClusterMapState();
}

class _ClusterMapState extends State<ClusterMap> {
  bool _dataLoaded = false;
  List<Marker> markers = [];
  List<CircleMarker> _circleMarkers = []; // New circle markers list
  LatLng? _currentCameraPosition;
  Marker? _userLocationMarker; // The users current location marker

  Future<FT> fetchdata() async {
    return await DataApi.fetchDataTreesParser();
  }

  @override
  void initState() {
    super.initState();
    _loadMapData();
    _getCurrentLocation(); // Get the current location when the map is initialized
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMapData() async {
    markers.clear();
    final value = await fetchdata();
    final newMarkers = <Marker>[];
    for (var element in value.features) {
      if (widget.filteredData.contains(element.properties.danskNavn) ||
          widget.filteredData.isEmpty) {
        newMarkers.add(
          Marker(
            height: 30,
            width: 30,
            point: LatLng(
              element.location.latitude,
              element.location.longitude,
            ),
            child: CustomMarker(element),
          ),
        );
      }
    }
    setState(() {
      markers = newMarkers;
      _dataLoaded = true;
    });
  }

  // New function to get user's location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show message
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final userLocation = LatLng(position.latitude, position.longitude);
      // create a new marker for the users current position
      setState(() {
        _userLocationMarker = Marker(
          width: 40,
          height: 40,
          point: userLocation,
          child: Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 40.0,
          ),
        );
        //create a new circle around the current location
        _circleMarkers = [
          CircleMarker(
            point: userLocation,
            color: Colors.blue.withOpacity(0.3),
            borderStrokeWidth: 2,
            borderColor: Colors.blue,
            useRadiusInMeter: true,
            radius: position.accuracy,
          ),
        ];
      });
    } catch (e) {
      print(e);
      // Handle the error (e.g., show a message)
    }
  }

  @override
  void didUpdateWidget(covariant ClusterMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filteredData != widget.filteredData) {
      _loadMapData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Scaffold(
          body: PopupScope(
            child: _dataLoaded
                ? FlutterMap(
              options: MapOptions(
                onMapEvent: (event) {
                  setState(() {
                    _currentCameraPosition = event.camera.center;
                  });

                  mapProvider.setCameraPosition(event.camera.center);
                  mapProvider.setLatitude(event.camera.center.latitude);
                  mapProvider.setLongitude(
                    event.camera.center.longitude,
                  );
                  mapProvider.setZoom(event.camera.zoom);
                },
                initialCenter: LatLng(
                  mapProvider.latitude,
                  mapProvider.longitude,
                ),
                initialZoom: mapProvider.zoom,
                maxZoom: 20,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                  InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (_circleMarkers.isNotEmpty) ...[
                  CircleLayer(
                    circles: _circleMarkers,
                  ),
                ],
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 60,
                    size: const Size(45, 45),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    maxZoom: 15,
                    disableClusteringAtZoom: 17,
                    markers: markers,
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          color: Colors.green,
                        ),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_userLocationMarker != null) ...[
                  MarkerLayer(
                    markers: [_userLocationMarker!],
                  ),
                ],
              ],
            )
                : const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}