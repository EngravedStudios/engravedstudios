import 'package:flutter/foundation.dart';

@immutable
class Tag {
  final String id; // Appwrite Document ID
  final int tagId;
  final String tagName;
  final String slug;
  final String description;

  const Tag({
    required this.id,
    required this.tagId,
    required this.tagName,
    required this.slug,
    required this.description,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['\$id'] ?? '',
      tagId: map['tagId']?.toInt() ?? 0,
      tagName: map['tagName'] ?? '',
      slug: map['slug'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'slug': slug,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tag &&
      other.tagId == tagId &&
      other.tagName == tagName &&
      other.slug == slug &&
      other.description == description;
  }

  @override
  int get hashCode {
    return tagId.hashCode ^
      tagName.hashCode ^
      slug.hashCode ^
      description.hashCode;
  }
}
