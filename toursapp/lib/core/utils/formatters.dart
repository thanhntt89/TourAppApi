import 'package:intl/intl.dart';

abstract final class Formatters {
  static String distance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()}m';
    }
    return '${km.toStringAsFixed(1)}km';
  }

  static String duration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return remaining > 0 ? '${hours}h ${remaining}m' : '${hours}h';
  }

  static String audioDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static String flowers(int count) => '$count';

  static String date(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  static String dateTime(DateTime dt) =>
      DateFormat('dd/MM/yyyy HH:mm').format(dt);

  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
