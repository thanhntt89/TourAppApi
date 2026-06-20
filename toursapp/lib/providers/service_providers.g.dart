// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Services, optionally filtered by category.
/// When [category] is null, returns all services.

@ProviderFor(services)
const servicesProvider = ServicesFamily._();

/// Services, optionally filtered by category.
/// When [category] is null, returns all services.

final class ServicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceProvider>>,
          List<ServiceProvider>,
          FutureOr<List<ServiceProvider>>
        >
    with
        $FutureModifier<List<ServiceProvider>>,
        $FutureProvider<List<ServiceProvider>> {
  /// Services, optionally filtered by category.
  /// When [category] is null, returns all services.
  const ServicesProvider._({
    required ServicesFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'servicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesHash();

  @override
  String toString() {
    return r'servicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ServiceProvider>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServiceProvider>> create(Ref ref) {
    final argument = this.argument as String?;
    return services(ref, category: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesHash() => r'b01b28f9d705fe55fd77f4f2292b833629a3a9b0';

/// Services, optionally filtered by category.
/// When [category] is null, returns all services.

final class ServicesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ServiceProvider>>, String?> {
  const ServicesFamily._()
    : super(
        retry: null,
        name: r'servicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Services, optionally filtered by category.
  /// When [category] is null, returns all services.

  ServicesProvider call({String? category}) =>
      ServicesProvider._(argument: category, from: this);

  @override
  String toString() => r'servicesProvider';
}

@ProviderFor(serviceDetail)
const serviceDetailProvider = ServiceDetailFamily._();

final class ServiceDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceProvider>,
          ServiceProvider,
          FutureOr<ServiceProvider>
        >
    with $FutureModifier<ServiceProvider>, $FutureProvider<ServiceProvider> {
  const ServiceDetailProvider._({
    required ServiceDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'serviceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceDetailHash();

  @override
  String toString() {
    return r'serviceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceProvider> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceProvider> create(Ref ref) {
    final argument = this.argument as int;
    return serviceDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceDetailHash() => r'd904c5424d17124135c28a3c848818dd28cbd0cc';

final class ServiceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceProvider>, int> {
  const ServiceDetailFamily._()
    : super(
        retry: null,
        name: r'serviceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ServiceDetailProvider call({required int id}) =>
      ServiceDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'serviceDetailProvider';
}
