import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
abstract class Story with _$Story {
  const factory Story({
    required int id,
    required String title,
    String? titleEn,
    String? titleKo,
    String? content,
    String? contentEn,
    String? imageUrl,
    int? readTimeMinutes,
    @Default([]) List<int> relatedPlaceIds,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
