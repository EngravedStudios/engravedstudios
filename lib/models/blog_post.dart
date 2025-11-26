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
  final String authorAvatarUrl;
  final DateTime publishDate;
  final int readTimeMinutes;
  final int clapCount;
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
    required this.authorAvatarUrl,
    required this.publishDate,
    required this.readTimeMinutes,
    required this.clapCount,
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
      subtitle: map['subtitle'] ?? '', // Not in DB, default empty
      content: map['content'] ?? '',
      authorName: map['authorName'] ?? '',
      authorAvatarUrl: map['authorAvatarUrl'] ?? '', // Not in DB, default empty
      publishDate: DateTime.tryParse(map['creationDate'] ?? '') ?? DateTime.now(),
      readTimeMinutes: map['readTimeMinutes'] ?? 5, // Not in DB, default 5
      clapCount: map['clapCount'] ?? 0, // Not in DB, default 0
      tags: parsedTags,
      imageUrl: map['imageUrl'], // Not in DB, default null
      isPublished: map['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'authorName': authorName,
      'creationDate': publishDate.toIso8601String(),
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
    String? authorAvatarUrl,
    DateTime? publishDate,
    int? readTimeMinutes,
    int? clapCount,
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
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      publishDate: publishDate ?? this.publishDate,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      clapCount: clapCount ?? this.clapCount,
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
      other.authorAvatarUrl == authorAvatarUrl &&
      other.publishDate == publishDate &&
      other.readTimeMinutes == readTimeMinutes &&
      other.clapCount == clapCount &&
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
      authorAvatarUrl.hashCode ^
      publishDate.hashCode ^
      readTimeMinutes.hashCode ^
      clapCount.hashCode ^
      tags.hashCode ^
      imageUrl.hashCode ^
      isPublished.hashCode;
  }
}
