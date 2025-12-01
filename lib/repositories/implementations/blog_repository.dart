import 'package:appwrite/appwrite.dart';

import '../../core/config/app_config.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/blog_post.dart';
import '../../data/datasources/remote/appwrite_datasource.dart';
import '../../domain/repositories/blog_repository_interface.dart';

class BlogRepository implements IBlogRepository {
  final IAppwriteDatasource _datasource;
  final AppLogger _logger;

  BlogRepository(this._datasource, this._logger);

  @override
  Future<List<BlogPost>> getBlogPosts() async {
    try {
      // 1. Fetch Blog Posts
      final postsResult = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdBlogPosts,
        queries: [
          Query.orderDesc('creationDate'),
        ],
      );

      // 2. Fetch All Tags
      final tagsResult = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdTags,
        queries: [Query.limit(100)], // Adjust limit as needed
      );
      
      final tagMap = {
        for (var doc in tagsResult.documents) 
          doc.data['tagId']: doc.data['tagName'] as String
      };

      // 3. Fetch All Post-Tag Mappings
      final mappingsResult = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostTags,
        queries: [Query.limit(1000)], // Adjust limit as needed
      );

      // 4. Map Tags to Posts
      final postTagsMap = <int, List<String>>{};
      for (var doc in mappingsResult.documents) {
        final postId = doc.data['postId'] as int;
        final tagId = doc.data['tagId'] as int;
        
        if (tagMap.containsKey(tagId)) {
          postTagsMap.putIfAbsent(postId, () => []).add(tagMap[tagId]!);
        }
      }

      // 5. Create BlogPosts with Tags
      return postsResult.documents.map((doc) {
        final post = BlogPost.fromMap(doc.data);
        final tags = postTagsMap[post.postId] ?? [];
        tags.sort(); // Sort tags alphabetically
        return post.copyWith(tags: tags);
      }).toList();

    } catch (e, stackTrace) {
      _logger.error('Failed to fetch blog posts', e, stackTrace);
      return [];
    }
  }

  @override
  Future<BlogPost> getBlogPost(String id) async {
    try {
      // 1. Fetch Blog Post
      final doc = await _datasource.getDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: id,
      );
      
      var post = BlogPost.fromMap(doc.data);

      // 2. Fetch Mappings for this Post
      final mappingsResult = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostTags,
        queries: [
          Query.equal('postId', post.postId),
        ],
      );

      if (mappingsResult.documents.isEmpty) {
        return post;
      }

      // 3. Fetch Related Tags
      final tagIds = mappingsResult.documents.map((d) => d.data['tagId']).toList();
      final tags = <String>[];

      // Note: Appwrite doesn't support "whereIn" for array of values efficiently in one query 
      // without specific indexes or multiple queries. For simplicity/MVP:
      // We'll fetch all tags (cached ideally) or fetch individually if list is small.
      // Optimization: Fetch all tags once if list is small, or use multiple queries.
      // Here, let's fetch all tags to be safe and simple for now, or filter client side if we had them.
      // Better approach for specific IDs:
      for (var tagId in tagIds) {
         final tagDocs = await _datasource.listDocuments(
          collectionId: AppConfig.collectionIdTags,
          queries: [Query.equal('tagId', tagId)],
        );
        if (tagDocs.documents.isNotEmpty) {
          tags.add(tagDocs.documents.first.data['tagName']);
        }
      }
      
      tags.sort(); // Sort tags alphabetically
      return post.copyWith(tags: tags);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch blog post by ID', e, stackTrace);
      throw Exception('Error fetching blog post: $e');
    }
  }

  @override
  Future<void> updateBlogPost(BlogPost post) async {
    try {
      await _datasource.updateDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: post.id,
        data: post.toMap(),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to update blog post', e, stackTrace);
      throw Exception('Error updating blog post: $e');
    }
  }

  @override
  Future<void> createBlogPost(BlogPost post) async {
    try {
      await _datasource.createDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: ID.unique(),
        data: post.toMap(),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to create blog post', e, stackTrace);
      throw Exception('Error creating blog post: $e');
    }
  }
  @override
  Future<void> addTagsToPost(int postId, List<int> tagIds) async {
    try {
      for (final tagId in tagIds) {
        await _datasource.createDocument(
          collectionId: AppConfig.collectionIdPostTags,
          documentId: ID.unique(),
          data: {
            'postId': postId,
            'tagId': tagId,
          },
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to add tags to post', e, stackTrace);
      throw Exception('Error adding tags to post: $e');
    }
  }

  @override
  Future<void> updateTagsForPost(int postId, List<int> tagIds) async {
    try {
      // 1. Get existing tags for this post
      final existingMappings = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostTags,
        queries: [Query.equal('postId', postId)],
      );

      // 2. Delete existing mappings
      for (var doc in existingMappings.documents) {
        await _datasource.deleteDocument(
          collectionId: AppConfig.collectionIdPostTags,
          documentId: doc.$id,
        );
      }

      // 3. Add new tags
      await addTagsToPost(postId, tagIds);
    } catch (e, stackTrace) {
      _logger.error('Failed to update tags for post', e, stackTrace);
      throw Exception('Error updating tags for post: $e');
    }
  }

  @override
  Future<void> deleteBlogPost(String id) async {
    try {
      // First, get the post to find its postId
      final doc = await _datasource.getDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: id,
      );
      
      final postId = doc.data['postId'] as int;

      // Delete all tag mappings for this post
      final mappings = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostTags,
        queries: [Query.equal('postId', postId)],
      );

      for (var mapping in mappings.documents) {
        await _datasource.deleteDocument(
          collectionId: AppConfig.collectionIdPostTags,
          documentId: mapping.$id,
        );
      }

      // Delete the post itself
      await _datasource.deleteDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: id,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to delete blog post', e, stackTrace);
      throw Exception('Error deleting blog post: $e');
    }
  }

  @override
  Future<void> updatePublishStatus(String id, bool isPublished) async {
    try {
      await _datasource.updateDocument(
        collectionId: AppConfig.collectionIdBlogPosts,
        documentId: id,
        data: {'isPublished': isPublished},
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to update publish status', e, stackTrace);
      throw Exception('Error updating publish status: $e');
    }
  }
}
