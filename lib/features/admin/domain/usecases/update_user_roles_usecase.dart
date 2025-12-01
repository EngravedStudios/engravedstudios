import '../entities/admin_user.dart';
import '../entities/admin_models.dart';
import '../repositories/admin_repository_interface.dart';
import '../../../../core/errors/result.dart';

/// Use case for updating user roles (team memberships)
class UpdateUserRolesUseCase {
  final IAdminRepository _repository;

  UpdateUserRolesUseCase(this._repository);

  Future<Result<AdminUser>> call(UpdateUserRolesParams params) {
    return _repository.updateUserRoles(params);
  }
}
