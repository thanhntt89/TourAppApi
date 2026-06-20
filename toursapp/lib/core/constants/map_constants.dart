import 'package:latlong2/latlong.dart';

abstract final class MapConstants {
  // Ha Giang bounding box
  static const haGiangSouthLat = 22.5;
  static const haGiangNorthLat = 23.5;
  static const haGiangWestLng = 104.3;
  static const haGiangEastLng = 105.6;

  static const haGiangCenter = LatLng(22.82, 104.98);
  static const defaultZoom = 10.0;
  static const minZoom = 8.0;
  static const maxZoom = 18.0;

  // Offline tile download
  static const offlineMinZoom = 8;
  static const offlineMaxZoom = 15;
  static const tileParallelThreads = 3;

  // OSM tile URL
  static const osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
