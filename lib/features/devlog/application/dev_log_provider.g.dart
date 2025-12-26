// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(devLogPosts)
const devLogPostsProvider = DevLogPostsProvider._();

final class DevLogPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DevLogPost>>,
          List<DevLogPost>,
          FutureOr<List<DevLogPost>>
        >
    with $FutureModifier<List<DevLogPost>>, $FutureProvider<List<DevLogPost>> {
  const DevLogPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devLogPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devLogPostsHash();

  @$internal
  @override
  $FutureProviderElement<List<DevLogPost>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DevLogPost>> create(Ref ref) {
    return devLogPosts(ref);
  }
}

String _$devLogPostsHash() => r'14658289ca854f9ce7e89a96a47705521bf5f65e';
