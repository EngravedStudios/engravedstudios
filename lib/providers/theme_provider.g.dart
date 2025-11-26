// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeSchemaHash() =>
    r'81840cfbb6a553b02db2a23e1bb8a7efd73a37c7';

/// See also [currentThemeSchema].
@ProviderFor(currentThemeSchema)
final currentThemeSchemaProvider =
    AutoDisposeProvider<AppThemeColorSchema>.internal(
      currentThemeSchema,
      name: r'currentThemeSchemaProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentThemeSchemaHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThemeSchemaRef = AutoDisposeProviderRef<AppThemeColorSchema>;
String _$themeNotifierHash() => r'68caed1bddf0bf5a91670e865370db2fc5f24e2d';

/// See also [ThemeNotifier].
@ProviderFor(ThemeNotifier)
final themeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ThemeNotifier, AppThemeType>.internal(
      ThemeNotifier.new,
      name: r'themeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeNotifier = AutoDisposeAsyncNotifier<AppThemeType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
