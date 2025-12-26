// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gamesRepository)
const gamesRepositoryProvider = GamesRepositoryProvider._();

final class GamesRepositoryProvider
    extends
        $FunctionalProvider<GamesRepository, GamesRepository, GamesRepository>
    with $Provider<GamesRepository> {
  const GamesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamesRepositoryHash();

  @$internal
  @override
  $ProviderElement<GamesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GamesRepository create(Ref ref) {
    return gamesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamesRepository>(value),
    );
  }
}

String _$gamesRepositoryHash() => r'dec96fec01de8e508c92daf9dfd9916437689edb';

@ProviderFor(allGames)
const allGamesProvider = AllGamesProvider._();

final class AllGamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameModel>>,
          List<GameModel>,
          FutureOr<List<GameModel>>
        >
    with $FutureModifier<List<GameModel>>, $FutureProvider<List<GameModel>> {
  const AllGamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allGamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allGamesHash();

  @$internal
  @override
  $FutureProviderElement<List<GameModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameModel>> create(Ref ref) {
    return allGames(ref);
  }
}

String _$allGamesHash() => r'23dc9a0a9a897a93aee9b334910e767d53f2779c';
