// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// News items for the currently selected province.

@ProviderFor(news)
const newsProvider = NewsProvider._();

/// News items for the currently selected province.

final class NewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NewsAlert>>,
          List<NewsAlert>,
          FutureOr<List<NewsAlert>>
        >
    with $FutureModifier<List<NewsAlert>>, $FutureProvider<List<NewsAlert>> {
  /// News items for the currently selected province.
  const NewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsHash();

  @$internal
  @override
  $FutureProviderElement<List<NewsAlert>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NewsAlert>> create(Ref ref) {
    return news(ref);
  }
}

String _$newsHash() => r'8461237a7fec8b63c5f3ba51241004e1a8b62a31';
