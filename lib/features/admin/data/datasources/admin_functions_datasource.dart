import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../../domain/entities/admin_models.dart';
import '../models/admin_user_model.dart';
import '../models/search_users_response_model.dart';
import '../../../../core/errors/exceptions.dart';

/// Datasource for admin operations via Appwrite Functions
class AdminFunctionsDatasource {
  final Functions _functions;
  final Account _account;

  AdminFunctionsDatasource(this._functions, this._account);

  /// Search users via cloud function
  Future<SearchUsersResponseModel> searchUsers(
      SearchUsersParams params) async {
    try {
      final jwt = await _account.createJWT();

      final execution = await _functions.createExecution(
        functionId: 'searchUsers',
        body: jsonEncode({
          'query': params.query,
          'limit': params.limit,
          'offset': params.offset,
          if (params.filters != null) 'filters': params.filters,
        }),
        xasync: false,
        headers: {
          'Authorization': 'Bearer ${jwt.jwt}',
        },
      );

      if (execution.responseStatusCode != null &&
          execution.responseStatusCode! >= 400) {
        throw AppException(
          execution.responseBody,
          execution.responseStatusCode.toString(),
        );
      }

      final response = jsonDecode(execution.responseBody);
      return SearchUsersResponseModel.fromJson(response);
    } on AppwriteException catch (e) {
      throw AppException(
        e.message ?? 'Unknown error',
        e.code?.toString(),
      );
    }
  }

  /// Get user details via cloud function
  Future<AdminUserModel> getUserDetails(String userId) async {
    try {
      final jwt = await _account.createJWT();

      final execution = await _functions.createExecution(
        functionId: 'getUserDetails',
        body: jsonEncode({'userId': userId}),
        xasync: false,
        headers: {
          'Authorization': 'Bearer ${jwt.jwt}',
        },
      );

      if (execution.responseStatusCode != null &&
          execution.responseStatusCode! >= 400) {
        throw AppException(
          execution.responseBody,
          execution.responseStatusCode.toString(),
        );
      }

      final response = jsonDecode(execution.responseBody);
      return AdminUserModel.fromJson(response);
    } on AppwriteException catch (e) {
      throw AppException(
        e.message ?? 'Failed to get user details',
        e.code.toString(),
      );
    }
  }

  /// Update user roles via cloud function
  Future<AdminUserModel> updateUserRoles(UpdateUserRolesParams params) async {
    try {
      final jwt = await _account.createJWT();

      final execution = await _functions.createExecution(
        functionId: 'updateUserRoles',
        body: jsonEncode({
          'userId': params.userId,
          'addTeams': params.addTeams,
          'removeTeams': params.removeTeams,
        }),
        xasync: false,
        headers: {
          'Authorization': 'Bearer ${jwt.jwt}',
        },
      );

      if (execution.responseStatusCode != null &&
          execution.responseStatusCode! >= 400) {
        throw AppException(
          execution.responseBody,
          execution.responseStatusCode.toString(),
        );
      }

      final response = jsonDecode(execution.responseBody);
      // Return updated user by fetching details
      return getUserDetails(params.userId);
    } on AppwriteException catch (e) {
      throw AppException(
        e.message ?? 'Failed to update user roles',
        e.code.toString(),
      );
    }
  }

  /// Delete user via cloud function
  Future<void> deleteUser(String userId) async {
    try {
      final jwt = await _account.createJWT();

      final execution = await _functions.createExecution(
        functionId: 'deleteUser',
        body: jsonEncode({'userId': userId}),
        xasync: false,
        headers: {
          'Authorization': 'Bearer ${jwt.jwt}',
        },
      );

      if (execution.responseStatusCode != null &&
          execution.responseStatusCode! >= 400) {
        throw AppException(
          execution.responseBody,
          execution.responseStatusCode.toString(),
        );
      }
    } on AppwriteException catch (e) {
      throw AppException(
        e.message ?? 'Failed to delete user',
        e.code.toString(),
      );
    }
  }
}
