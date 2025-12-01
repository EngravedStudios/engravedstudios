import '../../domain/entities/admin_user.dart';

/// Data model for AdminUser with JSON serialization
class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.emailVerified,
    required super.teams,
    required super.createdAt,
    super.phone,
    super.metadata,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      phone: json['phone'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'teams': teams,
      'createdAt': createdAt,
      if (phone != null) 'phone': phone,
      if (metadata != null) 'metadata': metadata,
    };
  }

  AdminUser toEntity() {
    return AdminUser(
      userId: userId,
      name: name,
      email: email,
      emailVerified: emailVerified,
      teams: teams,
      createdAt: createdAt,
      phone: phone,
      metadata: metadata,
    );
  }
}
