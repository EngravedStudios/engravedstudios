import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../../../../services/appwrite_service.dart';
import '../../data/datasources/admin_functions_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository_interface.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../domain/usecases/get_user_details_usecase.dart';
import '../../domain/usecases/update_user_roles_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/admin_models.dart';

// Datasource provider
final adminFunctionsDatasourceProvider =
    Provider<AdminFunctionsDatasource>((ref) {
  final appwriteService = ref.watch(appwriteServiceProvider);
  return AdminFunctionsDatasource(
    Functions(appwriteService.client),
    Account(appwriteService.client),
  );
});

// Repository provider
final adminRepositoryProvider = Provider<IAdminRepository>((ref) {
  final datasource = ref.watch(adminFunctionsDatasourceProvider);
  return AdminRepository(datasource);
});

// Use case providers
final searchUsersUseCaseProvider = Provider<SearchUsersUseCase>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return SearchUsersUseCase(repository);
});

final getUserDetailsUseCaseProvider = Provider<GetUserDetailsUseCase>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return GetUserDetailsUseCase(repository);
});

final updateUserRolesUseCaseProvider = Provider<UpdateUserRolesUseCase>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return UpdateUserRolesUseCase(repository);
});

final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return DeleteUserUseCase(repository);
});

// Search query state
final userSearchQueryProvider = StateProvider<String>((ref) => '');

// All users provider
final adminUsersProvider =
    FutureProvider<List<AdminUser>>((ref) async {
  final useCase = ref.watch(searchUsersUseCaseProvider);
  final result = await useCase(const SearchUsersParams(
    query: '',
    limit: 1000, // Get all users for now
  ));

  return result.fold(
    (failure) => throw failure,
    (response) => response.users,
  );
});

// Filtered users based on search query
final filteredUsersProvider = Provider<AsyncValue<List<AdminUser>>>((ref) {
  final usersAsync = ref.watch(adminUsersProvider);
  final query = ref.watch(userSearchQueryProvider);

  return usersAsync.when(
    data: (users) {
      if (query.isEmpty) {
        return AsyncValue.data(users);
      }

      final lowerQuery = query.toLowerCase();
      final filtered = users.where((user) {
        return user.name.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Selected user for viewing/editing
final selectedUserProvider = StateProvider<AdminUser?>((ref) => null);

// Delete user action provider
final deleteUserActionProvider =
    StateNotifierProvider<DeleteUserNotifier, AsyncValue<void>>((ref) {
  return DeleteUserNotifier(ref);
});

class DeleteUserNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  DeleteUserNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> deleteUser(String userId) async {
    state = const AsyncValue.loading();

    final useCase = _ref.read(deleteUserUseCaseProvider);
    final result = await useCase(userId);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Refresh users list
        _ref.invalidate(adminUsersProvider);
        state = const AsyncValue.data(null);
      },
    );
  }
}

// Update user roles action provider
final updateUserRolesActionProvider =
    StateNotifierProvider<UpdateUserRolesNotifier, AsyncValue<void>>((ref) {
  return UpdateUserRolesNotifier(ref);
});

class UpdateUserRolesNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  UpdateUserRolesNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> updateRoles(UpdateUserRolesParams params) async {
    state = const AsyncValue.loading();

    final useCase = _ref.read(updateUserRolesUseCaseProvider);
    final result = await useCase(params);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (updatedUser) {
        // Update selected user
        _ref.read(selectedUserProvider.notifier).state = updatedUser;
        // Refresh users list
        _ref.invalidate(adminUsersProvider);
        state = const AsyncValue.data(null);
      },
    );
  }
}
