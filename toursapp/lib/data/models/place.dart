import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
abstract class Place with _$Place {
  const factory Place({
    required int id,
    required int locationId,
    required String name,
    required String slug,
    required double lat,
    required double lng,
    String? nameEn,
    String? nameKo,
    String? nameZh,
    String? description,
    String? descriptionEn,
    String? imageUrl,
    @Default([]) List<String> galleryUrls,
    String? audioUrlVi,
    String? audioUrlEn,
    String? audioUrlKo,
    String? audioUrlZh,
    @Default(0) int audioDuration,
    String? category,
    String? difficulty,
    String? openingHours,
    String? entranceFee,
    String? tips,
    String? tipsEn,
    @Default(5) int flowerCost,
    String? qrCode,
    String? status,
    String? visitDuration,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
