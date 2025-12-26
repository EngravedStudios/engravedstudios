// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soundService)
const soundServiceProvider = SoundServiceProvider._();

final class SoundServiceProvider
    extends $FunctionalProvider<SoundService, SoundService, SoundService>
    with $Provider<SoundService> {
  const SoundServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundServiceHash();

  @$internal
  @override
  $ProviderElement<SoundService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundService create(Ref ref) {
    return soundService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundService>(value),
    );
  }
}

String _$soundServiceHash() => r'94ea0fc41e440f69ffcad9e4ff8e5600169750ae';
