import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class BlogPost {
  final String id;
  final int postId;
  final String title;
  final String subtitle;
  final String content;
  final String authorName;
  final String authorId; // New field
  final String authorAvatarUrl;
  final DateTime publishDate;
  final int readTimeMinutes;
  final List<String> tags;
  final String? imageUrl;
  final bool isPublished;

  const BlogPost({
    required this.id,
    required this.postId,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.authorName,
    required this.authorId, // New field
    required this.authorAvatarUrl,
    required this.publishDate,
    required this.readTimeMinutes,
    required this.tags,
    this.imageUrl,
    required this.isPublished,
  });

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    List<String> parsedTags = [];
    if (map['tags'] != null) {
      if (map['tags'] is String) {
        try {
          // Try parsing as JSON string
          final decoded = jsonDecode(map['tags']);
          if (decoded is List) {
            parsedTags = List<String>.from(decoded);
          }
        } catch (e) {
          // Fallback: treat as comma-separated string or single tag if not JSON
          parsedTags = [map['tags']];
        }
      } else if (map['tags'] is List) {
        parsedTags = List<String>.from(map['tags']);
      }
    }

    return BlogPost(
      id: map['\$id'] ?? '', // Appwrite Document ID
      postId: map['postId'] ?? 0,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      content: map['content'] ?? '',
      authorName: map['authorName'] ?? '',
      authorId: map['authorId']?.toString() ?? '', // Handle int or String safely
      authorAvatarUrl: map['authorAvatarUrl'] ?? '', 
      publishDate: DateTime.tryParse(map['creationDate'] ?? '') ?? DateTime.now(),
      readTimeMinutes: map['readTimeMinutes'] ?? 1, // Use database value, default 1 if missing
      tags: parsedTags,
      imageUrl: map['imageUrl'], // Not in DB, default null
      isPublished: map['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'authorName': authorName,
      'authorId': authorId,
      'creationDate': publishDate.toIso8601String(),
      'readTimeMinutes': readTimeMinutes,
      'isPublished': isPublished,
    };
  }

  BlogPost copyWith({
    String? id,
    int? postId,
    String? title,
    String? subtitle,
    String? content,
    String? authorName,
    String? authorId, // New field
    String? authorAvatarUrl,
    DateTime? publishDate,
    int? readTimeMinutes,
    List<String>? tags,
    String? imageUrl,
    bool? isPublished,
  }) {
    return BlogPost(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorId: authorId ?? this.authorId, // New field
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      publishDate: publishDate ?? this.publishDate,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BlogPost &&
      other.id == id &&
      other.postId == postId &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.content == content &&
      other.authorName == authorName &&
      other.authorId == authorId && // New field
      other.authorAvatarUrl == authorAvatarUrl &&
      other.publishDate == publishDate &&
      other.readTimeMinutes == readTimeMinutes &&
      listEquals(other.tags, tags) &&
      other.imageUrl == imageUrl &&
      other.isPublished == isPublished;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      postId.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      content.hashCode ^
      authorName.hashCode ^
      authorId.hashCode ^ // New field
      authorAvatarUrl.hashCode ^
      publishDate.hashCode ^
      readTimeMinutes.hashCode ^
      tags.hashCode ^
      imageUrl.hashCode ^
      isPublished.hashCode;
  }
}
