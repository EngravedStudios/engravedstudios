import '../entities/admin_models.dart';
import '../repositories/admin_repository_interface.dart';
import '../../../../core/errors/result.dart';

/// Use case for searching users
class SearchUsersUseCase {
  final IAdminRepository _repository;

  SearchUsersUseCase(this._repository);

  Future<Result<SearchUsersResponse>> call(SearchUsersParams params) {
    return _repository.searchUsers(params);
  }
}
