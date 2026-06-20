import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_alert.freezed.dart';
part 'news_alert.g.dart';

@freezed
abstract class NewsAlert with _$NewsAlert {
  const factory NewsAlert({
    required int id,
    required String title,
    required int provinceId,
    required DateTime publishedAt,
    String? titleEn,
    String? content,
    String? contentEn,
    @Default('news') String type,
    String? imageUrl,
    @Default(true) bool isActive,
  }) = _NewsAlert;

  factory NewsAlert.fromJson(Map<String, dynamic> json) =>
      _$NewsAlertFromJson(json);
}
