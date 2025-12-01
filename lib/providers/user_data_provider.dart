import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/appwrite_datasource.dart';
import '../domain/repositories/user_data_repository_interface.dart';
import '../repositories/implementations/user_data_repository.dart';
import 'auth_provider.dart';

/// Provider for UserData repository
final userDataRepositoryProvider = Provider<IUserDataRepository>((ref) {
  final datasource = ref.watch(appwriteDatasourceProvider);
  return UserDataRepository(datasource);
});

/// Provider for the current user's saved post IDs
final savedPostIdsProvider = FutureProvider<List<String>>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return [];

  final repository = ref.watch(userDataRepositoryProvider);
  return repository.getSavedPostIds(user.id);
});

/// Check if a specific post is saved by the current user
final isPostSavedProvider = FutureProvider.family<bool, String>((ref, postId) async {
  final savedPosts = await ref.watch(savedPostIdsProvider.future);
  return savedPosts.contains(postId);
});
