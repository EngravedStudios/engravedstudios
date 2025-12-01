import '../repositories/admin_repository_interface.dart';
import '../../../../core/errors/result.dart';

/// Use case for deleting a user
class DeleteUserUseCase {
  final IAdminRepository _repository;

  DeleteUserUseCase(this._repository);

  Future<Result<void>> call(String userId) {
    return _repository.deleteUser(userId);
  }
}
