// lib/core/constants/map_constants.dart

import 'package:latlong2/latlong.dart';

abstract class MapConstants {
  // ── Tile providers ─────────────────────────────────────────────────────────
  /// OpenStreetMap standard tile (development / fallback).
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Thunderforest Outdoors — terrain view (good for mountain roads).
  /// Requires free API key from thunderforest.com
  static const String thunderforestUrl =
      'https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey={apikey}';

  // ── Ha Giang bounds ────────────────────────────────────────────────────────
  static const LatLng haGiangCenter = LatLng(22.8025, 104.9784);

  static const LatLng haGiangSW = LatLng(22.1, 104.3); // Southwest corner
  static const LatLng haGiangNE = LatLng(23.4, 105.7); // Northeast corner

  // ── Zoom levels ────────────────────────────────────────────────────────────
  static const double zoomProvinceOverview = 9.0;
  static const double zoomDefault = 11.0;
  static const double zoomLocationGroup = 12.5;
  static const double zoomPlaceDetail = 15.0;
  static const double zoomMaxCache = 16.0; // Max zoom to cache offline tiles

  static const double zoomMin = 5.0;
  static const double zoomMax = 18.0;

  // ── Cluster thresholds ────────────────────────────────────────────────────
  /// Zoom level below which markers start clustering.
  static const double clusterZoomThreshold = 13.0;

  // ── Geofence defaults ─────────────────────────────────────────────────────
  /// Radius in meters to fetch nearby places (for map and GPS trigger).
  static const double nearbyRadiusMeters = 5000;

  // ── Tile cache ────────────────────────────────────────────────────────────
  /// Name of the tile cache store (flutter_map_tile_caching).
  static const String tileCacheStore = 'toursapp_tiles';

  /// Max age for cached tiles before refresh (days).
  static const int tileCacheMaxAgeDays = 14;
}
