import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/appwrite_datasource.dart';
import '../domain/repositories/cheer_repository_interface.dart';
import '../repositories/implementations/cheer_repository.dart';
import 'auth_provider.dart';

/// Provider for cheer repository
final cheerRepositoryProvider = Provider<ICheerRepository>((ref) {
  final datasource = ref.watch(appwriteDatasourceProvider);
  return CheerRepository(datasource);
});

/// Check if current user has cheered a post
final hasUserCheeredProvider = FutureProvider.family<bool, int>((ref, postId) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return false;
  
  final repository = ref.watch(cheerRepositoryProvider);
  return repository.hasUserCheered(postId, user.id);
});

/// Get cheer count for a post
final cheerCountProvider = FutureProvider.family<int, int>((ref, postId) async {
  final repository = ref.watch(cheerRepositoryProvider);
  return repository.getCheerCount(postId);
});
