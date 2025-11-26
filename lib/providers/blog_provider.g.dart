// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blogRepositoryHash() => r'68252c7ca2e806a35bf8dfb08c6b55500eb42552';

/// See also [blogRepository].
@ProviderFor(blogRepository)
final blogRepositoryProvider = AutoDisposeProvider<IBlogRepository>.internal(
  blogRepository,
  name: r'blogRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blogRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BlogRepositoryRef = AutoDisposeProviderRef<IBlogRepository>;
String _$blogListHash() => r'd302291eddef63c15569b3db2edbb89a82900980';

/// See also [blogList].
@ProviderFor(blogList)
final blogListProvider = AutoDisposeFutureProvider<List<BlogPost>>.internal(
  blogList,
  name: r'blogListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blogListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BlogListRef = AutoDisposeFutureProviderRef<List<BlogPost>>;
String _$filteredBlogListHash() => r'8eac76169e696f9a3ba29185a6c244d083c47dc5';

/// See also [filteredBlogList].
@ProviderFor(filteredBlogList)
final filteredBlogListProvider =
    AutoDisposeFutureProvider<List<BlogPost>>.internal(
      filteredBlogList,
      name: r'filteredBlogListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredBlogListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredBlogListRef = AutoDisposeFutureProviderRef<List<BlogPost>>;
String _$blogPostHash() => r'08f8a19e01d076224f28daa8a726f8b6f90d8592';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [blogPost].
@ProviderFor(blogPost)
const blogPostProvider = BlogPostFamily();

/// See also [blogPost].
class BlogPostFamily extends Family<AsyncValue<BlogPost>> {
  /// See also [blogPost].
  const BlogPostFamily();

  /// See also [blogPost].
  BlogPostProvider call(String id) {
    return BlogPostProvider(id);
  }

  @override
  BlogPostProvider getProviderOverride(covariant BlogPostProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'blogPostProvider';
}

/// See also [blogPost].
class BlogPostProvider extends AutoDisposeFutureProvider<BlogPost> {
  /// See also [blogPost].
  BlogPostProvider(String id)
    : this._internal(
        (ref) => blogPost(ref as BlogPostRef, id),
        from: blogPostProvider,
        name: r'blogPostProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$blogPostHash,
        dependencies: BlogPostFamily._dependencies,
        allTransitiveDependencies: BlogPostFamily._allTransitiveDependencies,
        id: id,
      );

  BlogPostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<BlogPost> Function(BlogPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BlogPostProvider._internal(
        (ref) => create(ref as BlogPostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BlogPost> createElement() {
    return _BlogPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BlogPostProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BlogPostRef on AutoDisposeFutureProviderRef<BlogPost> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BlogPostProviderElement
    extends AutoDisposeFutureProviderElement<BlogPost>
    with BlogPostRef {
  _BlogPostProviderElement(super.provider);

  @override
  String get id => (origin as BlogPostProvider).id;
}

String _$selectedTagHash() => r'c7a5e93eab5195494fca8e0780938aad1fe69c4d';

/// See also [SelectedTag].
@ProviderFor(SelectedTag)
final selectedTagProvider =
    AutoDisposeNotifierProvider<SelectedTag, String?>.internal(
      SelectedTag.new,
      name: r'selectedTagProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedTagHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedTag = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
