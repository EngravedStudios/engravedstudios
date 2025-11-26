import 'package:flutter_test/flutter_test.dart';
import 'package:blog/models/blog_post.dart';

void main() {
  group('BlogPost', () {
    final testDate = DateTime(2023, 10, 26, 12, 0, 0);
    final blogPost = BlogPost(
      id: 'test-id',
      postId: 12345,
      title: 'Test Title',
      subtitle: 'Test Subtitle',
      content: 'Test Content',
      authorName: 'Test Author',
      authorAvatarUrl: 'http://example.com/avatar.png',
      publishDate: testDate,
      readTimeMinutes: 5,
      clapCount: 10,
      tags: ['tag1', 'tag2'],
      imageUrl: 'http://example.com/image.png',
      isPublished: true,
    );

    test('toMap returns correct map', () {
      final map = blogPost.toMap();

      expect(map['postId'], 12345);
      expect(map['title'], 'Test Title');
      expect(map['content'], 'Test Content');
      expect(map['authorName'], 'Test Author');
      expect(map['creationDate'], testDate.toIso8601String());
      expect(map['isPublished'], true);
      // Tags are no longer in toMap
      expect(map.containsKey('tags'), false);
    });

    test('fromMap returns correct BlogPost from JSON string tags', () {
      final map = {
        '\$id': 'test-id',
        'postId': 12345,
        'title': 'Test Title',
        'subtitle': 'Test Subtitle',
        'content': 'Test Content',
        'authorName': 'Test Author',
        'authorAvatarUrl': 'http://example.com/avatar.png',
        'creationDate': testDate.toIso8601String(),
        'readTimeMinutes': 5,
        'clapCount': 10,
        'tags': '["tag1","tag2"]', // JSON string
        'imageUrl': 'http://example.com/image.png',
        'isPublished': true,
      };

      final result = BlogPost.fromMap(map);

      expect(result, blogPost);
    });

    test('fromMap handles legacy list tags', () {
      final map = {
        '\$id': 'test-id',
        'postId': 12345,
        'title': 'Test Title',
        'subtitle': 'Test Subtitle',
        'content': 'Test Content',
        'authorName': 'Test Author',
        'authorAvatarUrl': 'http://example.com/avatar.png',
        'creationDate': testDate.toIso8601String(),
        'readTimeMinutes': 5,
        'clapCount': 10,
        'tags': ['tag1', 'tag2'], // Legacy list
        'imageUrl': 'http://example.com/image.png',
        'isPublished': true,
      };

      final result = BlogPost.fromMap(map);

      expect(result, blogPost);
    });

    test('fromMap handles missing fields with defaults', () {
      final map = {
        '\$id': 'test-id',
        'title': 'Test Title',
        'content': 'Test Content',
        'authorName': 'Test Author',
      };

      final result = BlogPost.fromMap(map);

      expect(result.id, 'test-id');
      expect(result.postId, 0); // Default
      expect(result.title, 'Test Title');
      expect(result.isPublished, true); // Default
      expect(result.tags, isEmpty);
    });
  });
}
