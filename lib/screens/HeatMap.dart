// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../data/DataApi.dart';
// import '../data/FT.dart';
//
// class HeatMap extends StatefulWidget {
//   final List<String> filteredData;
//
//   const HeatMap({Key? key, required this.filteredData}) : super(key: key);
//
//   @override
//   State<HeatMap> createState() => _HeatMapState();
// }
//
// class _HeatMapState extends State<HeatMap> {
//   List<WeightedLatLng> enabledPoints = <WeightedLatLng>[];
//   final _center = LatLng(55.6791235, 12.5884377);
//   bool _dataLoaded = false;
//   bool _showHeatmap = true; // Track heatmap visibility
//   Set<Heatmap> _currentHeatmaps = {};
//   double _currentZoom = 14; // Track the current zoom level
//
//   Future<void> _onMapCreated(GoogleMapController controller) async {}
//
//   Future<FT> fetchdata() async {
//     return await DataApi.fetchDataTreesParser();
//   }
//
//   Future<void> _loadHeatmapData() async {
//     final value = await fetchdata();
//     List<WeightedLatLng> tempPoints = [];
//     for (final tree in value.features) {
//       if (widget.filteredData.contains(tree.properties.danskNavn) ||
//           widget.filteredData.isEmpty) {
//         final heatMarker = WeightedLatLng(
//           LatLng(
//             tree.geometry.coordinates!.last,
//             tree.geometry.coordinates!.first,
//           ),
//         );
//         tempPoints.add(heatMarker);
//       } else {
//         continue;
//       }
//     }
//     setState(() {
//       enabledPoints = tempPoints;
//       _dataLoaded = true;
//       _updateMapElements();
//     });
//   }
//
//   void _updateMapElements() {
//     if (_dataLoaded) {
//       _currentHeatmaps =
//           _showHeatmap
//               ? {
//                 Heatmap(
//                   heatmapId: const HeatmapId('test'),
//                   data: enabledPoints,
//                   maxIntensity: 6,
//                   radius: HeatmapRadius.fromPixels(
//                     kIsWeb
//                         ? 10
//                         : (defaultTargetPlatform == TargetPlatform.android
//                             ? 20
//                             : 40),
//                   ),
//                 ),
//               }
//               : {};
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadHeatmapData();
//   }
//
//   @override
//   void didUpdateWidget(covariant HeatMap oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.filteredData != widget.filteredData) {
//       _loadHeatmapData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           _dataLoaded
//               ? GoogleMap(
//                 rotateGesturesEnabled: false,
//                 buildingsEnabled: true,
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: _center,
//                   zoom: _currentZoom,
//                 ),
//                 heatmaps: _currentHeatmaps,
//                 onCameraMove: (CameraPosition position) {
//                   _currentZoom = position.zoom;
//                   _updateMapElements();
//                 },
//               )
//               : const Center(
//                 child: CircularProgressIndicator(color: Colors.green),
//               ),
//     );
//   }
// }
