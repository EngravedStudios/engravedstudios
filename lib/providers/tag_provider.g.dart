// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagRepositoryHash() => r'f9c3542eddd8411b44558cd9c485e17f4e3cba20';

/// See also [tagRepository].
@ProviderFor(tagRepository)
final tagRepositoryProvider = AutoDisposeProvider<ITagRepository>.internal(
  tagRepository,
  name: r'tagRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagRepositoryRef = AutoDisposeProviderRef<ITagRepository>;
String _$tagListHash() => r'ac0842b980fb3fad5601e323fa2248e9501688bf';

/// See also [TagList].
@ProviderFor(TagList)
final tagListProvider =
    AutoDisposeAsyncNotifierProvider<TagList, List<Tag>>.internal(
      TagList.new,
      name: r'tagListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tagListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TagList = AutoDisposeAsyncNotifier<List<Tag>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
