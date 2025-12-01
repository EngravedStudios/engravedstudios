import 'package:flutter/foundation.dart';
import 'admin_user.dart';

/// Response model for user search operations
@immutable
class SearchUsersResponse {
  final List<AdminUser> users;
  final int total;
  final bool hasMore;

  const SearchUsersResponse({
    required this.users,
    required this.total,
    required this.hasMore,
  });
}

/// Parameters for searching users
@immutable
class SearchUsersParams {
  final String query;
  final int limit;
  final int offset;
  final Map<String, dynamic>? filters;

  const SearchUsersParams({
    this.query = '',
    this.limit = 50,
    this.offset = 0,
    this.filters,
  });
}

/// Parameters for updating user roles
@immutable
class UpdateUserRolesParams {
  final String userId;
  final List<String> addTeams;
  final List<String> removeTeams;

  const UpdateUserRolesParams({
    required this.userId,
    this.addTeams = const [],
    this.removeTeams = const [],
  });
}
