// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactNotifier)
const contactProvider = ContactNotifierProvider._();

final class ContactNotifierProvider
    extends $NotifierProvider<ContactNotifier, ContactState> {
  const ContactNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactNotifierHash();

  @$internal
  @override
  ContactNotifier create() => ContactNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactState>(value),
    );
  }
}

String _$contactNotifierHash() => r'5ac3eb5f8512005c49ea861dc29f9cad47376915';

abstract class _$ContactNotifier extends $Notifier<ContactState> {
  ContactState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ContactState, ContactState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactState, ContactState>,
              ContactState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
