// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CursorState)
const cursorStateProvider = CursorStateProvider._();

final class CursorStateProvider
    extends $NotifierProvider<CursorState, CursorType> {
  const CursorStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cursorStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cursorStateHash();

  @$internal
  @override
  CursorState create() => CursorState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CursorType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CursorType>(value),
    );
  }
}

String _$cursorStateHash() => r'e975204a1dca81800e88352e7b87a7276e6572aa';

abstract class _$CursorState extends $Notifier<CursorType> {
  CursorType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CursorType, CursorType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CursorType, CursorType>,
              CursorType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
