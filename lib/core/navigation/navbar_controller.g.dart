// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navbar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NavbarController)
const navbarControllerProvider = NavbarControllerProvider._();

final class NavbarControllerProvider
    extends $NotifierProvider<NavbarController, bool> {
  const NavbarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navbarControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navbarControllerHash();

  @$internal
  @override
  NavbarController create() => NavbarController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$navbarControllerHash() => r'78b6c47f4fcc5416765bdd53c70b56d16fe50fa2';

abstract class _$NavbarController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
