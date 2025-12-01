import 'package:flutter/foundation.dart';

@immutable
class UserData {
  final String userId;
  final List<String> savedPosts;
  final List<String> favouriteTags;

  const UserData({
    required this.userId,
    required this.savedPosts,
    required this.favouriteTags,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] as String,
      savedPosts: (json['savedPosts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      favouriteTags: (json['favouriteTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'savedPosts': savedPosts,
      'favouriteTags': favouriteTags,
    };
  }

  UserData copyWith({
    String? userId,
    List<String>? savedPosts,
    List<String>? favouriteTags,
  }) {
    return UserData(
      userId: userId ?? this.userId,
      savedPosts: savedPosts ?? this.savedPosts,
      favouriteTags: favouriteTags ?? this.favouriteTags,
    );
  }
}
