import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin.freezed.dart';
part 'checkin.g.dart';

@freezed
abstract class Checkin with _$Checkin {
  const factory Checkin({
    required int id,
    required int placeId,
    required String method,
    required DateTime createdAt,
    String? placeName,
    @Default(0) int flowersEarned,
    double? lat,
    double? lng,
  }) = _Checkin;

  factory Checkin.fromJson(Map<String, dynamic> json) =>
      _$CheckinFromJson(json);
}
