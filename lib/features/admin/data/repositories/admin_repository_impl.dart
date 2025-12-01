import '../../domain/entities/admin_user.dart';
import '../../domain/entities/admin_models.dart';
import '../../domain/repositories/admin_repository_interface.dart';
import '../datasources/admin_functions_datasource.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';

/// Implementation of admin repository
class AdminRepository implements IAdminRepository {
  final AdminFunctionsDatasource _datasource;

  AdminRepository(this._datasource);

  @override
  Future<Result<SearchUsersResponse>> searchUsers(
      SearchUsersParams params) async {
    try {
      final response = await _datasource.searchUsers(params);
      return Result.success(response);
    } on AppException catch (e) {
      return Result.failure(ServerFailure(e.message, e.code));
    } catch (e) {
      return Result.failure(
        ServerFailure(e.toString(), 'UNKNOWN_ERROR'),
      );
    }
  }

  @override
  Future<Result<AdminUser>> getUserDetails(String userId) async {
    try {
      final user = await _datasource.getUserDetails(userId);
      return Result.success(user.toEntity());
    } on AppException catch (e) {
      return Result.failure(ServerFailure(e.message, e.code));
    } catch (e) {
      return Result.failure(
        ServerFailure(e.toString(), 'UNKNOWN_ERROR'),
      );
    }
  }

  @override
  Future<Result<AdminUser>> updateUserRoles(
      UpdateUserRolesParams params) async {
    try {
      final user = await _datasource.updateUserRoles(params);
      return Result.success(user.toEntity());
    } on AppException catch (e) {
      return Result.failure(ServerFailure(e.message, e.code));
    } catch (e) {
      return Result.failure(
        ServerFailure(e.toString(), 'UNKNOWN_ERROR'),
      );
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      await _datasource.deleteUser(userId);
      return Result.success(null);
    } on AppException catch (e) {
      return Result.failure(ServerFailure(e.message, e.code));
    } catch (e) {
      return Result.failure(
        ServerFailure(e.toString(), 'UNKNOWN_ERROR'),
      );
    }
  }
}
