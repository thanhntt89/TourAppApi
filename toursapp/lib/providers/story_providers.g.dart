// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stories)
const storiesProvider = StoriesProvider._();

final class StoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>
        >
    with $FutureModifier<List<Story>>, $FutureProvider<List<Story>> {
  const StoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storiesHash();

  @$internal
  @override
  $FutureProviderElement<List<Story>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Story>> create(Ref ref) {
    return stories(ref);
  }
}

String _$storiesHash() => r'42401764efa3580e3f46e1d29eff7b2eb05cde4e';

@ProviderFor(storyDetail)
const storyDetailProvider = StoryDetailFamily._();

final class StoryDetailProvider
    extends $FunctionalProvider<AsyncValue<Story>, Story, FutureOr<Story>>
    with $FutureModifier<Story>, $FutureProvider<Story> {
  const StoryDetailProvider._({
    required StoryDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'storyDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storyDetailHash();

  @override
  String toString() {
    return r'storyDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Story> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Story> create(Ref ref) {
    final argument = this.argument as int;
    return storyDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storyDetailHash() => r'f41a3ca0b3660e20ea9e1970205ab8f64f279040';

final class StoryDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Story>, int> {
  const StoryDetailFamily._()
    : super(
        retry: null,
        name: r'storyDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoryDetailProvider call({required int id}) =>
      StoryDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'storyDetailProvider';
}
