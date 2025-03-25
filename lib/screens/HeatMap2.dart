import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:flutter_map_heatmap/flutter_map_heatmap.dart" ;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/DataApi.dart';
import '../data/FT.dart';
import '../utils/Utils.dart';
import '../utils/locationProvider.dart';

class HeatMap2 extends StatefulWidget {
  final List<String> filteredData;

  const HeatMap2({Key? key, required this.filteredData}) : super(key: key);

  @override
  State<HeatMap2> createState() => _HeatMap2State();
}

class _HeatMap2State extends State<HeatMap2> {
  bool _dataLoaded = false;
  LatLng? _lastCameraPosition;
  LatLng? _currentCameraPosition;

  Future<FT> fetchdata() async {
    return await DataApi.fetchDataTreesParser();
  }

  @override
  void didUpdateWidget(covariant HeatMap2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filteredData != widget.filteredData) {
      _loadData();
    }
  }

  List<Map<double, MaterialColor>> gradients = [
    HeatMapOptions.defaultGradient,
    {
      0.25: Colors.blue,
      0.55: Colors.red,
      0.85: Colors.pink,
      1.0: Colors.purple,
    },
  ];
  List<WeightedLatLng> data = [];
  var index = 0;

  @override
  initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    data.clear();
    final value = await fetchdata();
    List<WeightedLatLng> tempPoints = [];
    for (final tree in value.features) {
      if (widget.filteredData.contains(tree.properties.danskNavn) ||
          widget.filteredData.isEmpty) {
        final heatMarker = WeightedLatLng(
          LatLng(
            tree.geometry.coordinates!.last,
            tree.geometry.coordinates!.first,
          ),
          0.2,
        );
        tempPoints.add(heatMarker);
      } else {
        continue;
      }
    }
    setState(() {
      data = tempPoints;
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        final map =
            _dataLoaded
                ? FlutterMap(
                  options: MapOptions(
                    onMapEvent: (event) {
                      setState(() {
                        _currentCameraPosition = event.camera.center;
                      });

                      if (event.source == MapEventSource.dragStart) {
                        setState(() {
                          _lastCameraPosition = _currentCameraPosition;
                        });
                      }
                      mapProvider.setCameraPosition(event.camera.center);
                      mapProvider.setLatitude(event.camera.center.latitude);
                      mapProvider.setLongitude(event.camera.center.longitude);
                      mapProvider.setZoom(event.camera.zoom);
                    },
                    backgroundColor: Colors.transparent,
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
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    if (data.isNotEmpty)
                      HeatMapLayer(
                        heatMapDataSource: InMemoryHeatMapDataSource(
                          data: data,
                        ),
                      ),
                  ],
                )
                : const Center(child: CircularProgressIndicator());
        return Center(child: Container(child: map));
      },
    );
  }
}
