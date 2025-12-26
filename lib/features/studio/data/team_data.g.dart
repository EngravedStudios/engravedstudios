// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(teamMembers)
const teamMembersProvider = TeamMembersProvider._();

final class TeamMembersProvider
    extends
        $FunctionalProvider<
          List<TeamMember>,
          List<TeamMember>,
          List<TeamMember>
        >
    with $Provider<List<TeamMember>> {
  const TeamMembersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamMembersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamMembersHash();

  @$internal
  @override
  $ProviderElement<List<TeamMember>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TeamMember> create(Ref ref) {
    return teamMembers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TeamMember> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TeamMember>>(value),
    );
  }
}

String _$teamMembersHash() => r'0dc0e05aa6b804f2ff9e07e44366a9e0c9122085';
