import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stoneecho/core/constants/api_constants.dart';
import 'package:stoneecho/core/network/api_client.dart';
import 'package:stoneecho/data/models/story.dart';

part 'story_providers.g.dart';

@riverpod
Future<List<Story>> stories(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(ApiConstants.stories);
  final data = response.data!;
  return (data['data'] as List)
      .map((e) => Story.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<Story> storyDetail(Ref ref, {required int id}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '${ApiConstants.stories}/$id',
  );
  final data = response.data!;
  return Story.fromJson(data['data'] as Map<String, dynamic>);
}
