import '../entities/admin_user.dart';
import '../entities/admin_models.dart';
import '../../../../core/errors/result.dart';

/// Repository interface for admin operations
abstract class IAdminRepository {
  /// Search users with optional query and filters
  Future<Result<SearchUsersResponse>> searchUsers(SearchUsersParams params);

  /// Get detailed information about a specific user
  Future<Result<AdminUser>> getUserDetails(String userId);

  /// Update user's team memberships (roles)
  Future<Result<AdminUser>> updateUserRoles(UpdateUserRolesParams params);

  /// Delete a user from the system
  Future<Result<void>> deleteUser(String userId);
}
