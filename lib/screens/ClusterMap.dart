import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/DataApi.dart';
import '../data/FT.dart';
import '../utils/Utils.dart';

class ClusterMap extends StatefulWidget {
  final List<String> filteredData;

  ClusterMap({Key? key, required this.filteredData}) : super(key: key);

  @override
  State<ClusterMap> createState() => _ClusterMapState();
}

class _ClusterMapState extends State<ClusterMap> {
  bool _dataLoaded = false;
  List<Marker> markers = [];
  // LatLng? _currentCameraPosition;

  Future<FT> fetchdata() async {
    return await DataApi.fetchDataTreesParser();
  }

  @override
  void initState() {
    super.initState();
    _loadMapData();
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
            child:
                _dataLoaded
                    ? FlutterMap(
                      options: MapOptions(
                        onMapEvent: (event) {
                          // setState(() {
                          //   // _currentCameraPosition = event.camera.center;
                          // });

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
                          flags:
                              InteractiveFlag.pinchZoom |
                              InteractiveFlag.drag |
                              InteractiveFlag.doubleTapZoom,
                        ),
                      ),
                      children: <Widget>[
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
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
