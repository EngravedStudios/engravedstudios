import '../entities/admin_user.dart';
import '../repositories/admin_repository_interface.dart';
import '../../../../core/errors/result.dart';

/// Use case for getting detailed user information
class GetUserDetailsUseCase {
  final IAdminRepository _repository;

  GetUserDetailsUseCase(this._repository);

  Future<Result<AdminUser>> call(String userId) {
    return _repository.getUserDetails(userId);
  }
}
