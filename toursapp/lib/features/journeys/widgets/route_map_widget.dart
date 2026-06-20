import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stoneecho/core/constants/map_constants.dart';

class RouteMapWidget extends StatelessWidget {
  const RouteMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load stops from journeyDetailProvider and draw polyline
    return FlutterMap(
      options: const MapOptions(
        initialCenter: MapConstants.haGiangCenter,
        initialZoom: MapConstants.defaultZoom,
        minZoom: MapConstants.minZoom,
        maxZoom: MapConstants.maxZoom,
      ),
      children: [
        TileLayer(urlTemplate: MapConstants.osmTileUrl),
        // TODO: PolylineLayer + MarkerLayer for route stops
      ],
    );
  }
}
