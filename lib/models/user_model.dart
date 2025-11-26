enum UserRole {
  admin,
  writer,
  viewer,
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.viewer,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['\$id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (map['prefs']?['role'] ?? 'viewer'),
        orElse: () => UserRole.viewer,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      // Role is stored in prefs, not directly in the user document usually, but for local use:
      'role': role.name,
    };
  }
  
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}
