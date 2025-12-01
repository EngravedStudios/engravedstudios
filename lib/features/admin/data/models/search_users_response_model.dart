import '../../domain/entities/admin_models.dart';
import 'admin_user_model.dart';

/// Data model for SearchUsersResponse
class SearchUsersResponseModel extends SearchUsersResponse {
  const SearchUsersResponseModel({
    required super.users,
    required super.total,
    required super.hasMore,
  });

  factory SearchUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchUsersResponseModel(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users
          .map((u) => AdminUserModel(
                userId: u.userId,
                name: u.name,
                email: u.email,
                emailVerified: u.emailVerified,
                teams: u.teams,
                createdAt: u.createdAt,
                phone: u.phone,
                metadata: u.metadata,
              ).toJson())
          .toList(),
      'total': total,
      'hasMore': hasMore,
    };
  }
}
