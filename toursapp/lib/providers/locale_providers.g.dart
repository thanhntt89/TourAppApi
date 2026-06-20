// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls the UI language (app chrome, labels, buttons).

@ProviderFor(UiLocale)
const uiLocaleProvider = UiLocaleProvider._();

/// Controls the UI language (app chrome, labels, buttons).
final class UiLocaleProvider extends $NotifierProvider<UiLocale, Locale> {
  /// Controls the UI language (app chrome, labels, buttons).
  const UiLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uiLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uiLocaleHash();

  @$internal
  @override
  UiLocale create() => UiLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$uiLocaleHash() => r'02d206717cd6028b9b178c5fb60c3aeadd0dc0a4';

/// Controls the UI language (app chrome, labels, buttons).

abstract class _$UiLocale extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Controls the content/audio language (stories, narration, descriptions).
/// This can differ from the UI language — e.g., Vietnamese UI but English
/// audio for a Korean tourist who speaks English.

@ProviderFor(ContentLanguage)
const contentLanguageProvider = ContentLanguageProvider._();

/// Controls the content/audio language (stories, narration, descriptions).
/// This can differ from the UI language — e.g., Vietnamese UI but English
/// audio for a Korean tourist who speaks English.
final class ContentLanguageProvider
    extends $NotifierProvider<ContentLanguage, String> {
  /// Controls the content/audio language (stories, narration, descriptions).
  /// This can differ from the UI language — e.g., Vietnamese UI but English
  /// audio for a Korean tourist who speaks English.
  const ContentLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentLanguageHash();

  @$internal
  @override
  ContentLanguage create() => ContentLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$contentLanguageHash() => r'71fa6ea139083559f272a5feb5438335f9a8279f';

/// Controls the content/audio language (stories, narration, descriptions).
/// This can differ from the UI language — e.g., Vietnamese UI but English
/// audio for a Korean tourist who speaks English.

abstract class _$ContentLanguage extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
