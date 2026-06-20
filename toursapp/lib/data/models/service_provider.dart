import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_provider.freezed.dart';
part 'service_provider.g.dart';

@freezed
abstract class ServiceProvider with _$ServiceProvider {
  const factory ServiceProvider({
    required int id,
    required String name,
    required String category,
    required double lat,
    required double lng,
    String? nameEn,
    String? description,
    String? descriptionEn,
    String? address,
    String? phone,
    String? website,
    String? imageUrl,
    double? rating,
    String? priceRange,
  }) = _ServiceProvider;

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);
}
