import 'package:flutter/foundation.dart';

/// Admin user entity representing a user in the admin panel
@immutable
class AdminUser {
  final String userId;
  final String name;
  final String email;
  final bool emailVerified;
  final List<String> teams;
  final String createdAt;
  final String? phone;
  final Map<String, dynamic>? metadata;

  const AdminUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.teams,
    required this.createdAt,
    this.phone,
    this.metadata,
  });

  /// Get primary role based on team membership
  String getPrimaryRole() {
    // Check teams in priority order
    if (teams.contains(_getTeamId('admin'))) return 'admin';
    if (teams.contains(_getTeamId('writer'))) return 'writer';
    if (teams.contains(_getTeamId('vip'))) return 'vip';
    return 'viewer';
  }

  /// Helper to get team ID from environment
  static String _getTeamId(String role) {
    // These will be populated from environment variables
    const teamMap = {
      'admin': '692ca7080009958e8ca4',
      'writer': '692ca6f90025a66aa7ab',
      'vip': '692ca6e6003c8b692771',
      'viewer': '692ca6d1001b3450cceb',
    };
    return teamMap[role] ?? teamMap['viewer']!;
  }

  AdminUser copyWith({
    String? userId,
    String? name,
    String? email,
    bool? emailVerified,
    List<String>? teams,
    String? createdAt,
    String? phone,
    Map<String, dynamic>? metadata,
  }) {
    return AdminUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      teams: teams ?? this.teams,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      metadata: metadata ?? this.metadata,
    );
  }
}
