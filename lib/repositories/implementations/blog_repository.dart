import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../constants/appwrite_constants.dart';
import '../../models/blog_post.dart';
import '../../services/appwrite_service.dart';
import '../interfaces/blog_repository_interface.dart';

class BlogRepository implements IBlogRepository {
  final AppwriteService _appwriteService;

  BlogRepository(this._appwriteService);

  @override
  Future<List<BlogPost>> getBlogPosts() async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) return [];

      // 1. Fetch Blog Posts
      final postsResult = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdBlogPosts,
        queries: [
          Query.orderDesc('creationDate'),
        ],
      );

      // 2. Fetch All Tags
      final tagsResult = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdTags,
        queries: [Query.limit(100)], // Adjust limit as needed
      );
      
      final tagMap = {
        for (var doc in tagsResult.documents) 
          doc.data['tagId']: doc.data['tagName'] as String
      };

      // 3. Fetch All Post-Tag Mappings
      final mappingsResult = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdPostTags,
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
        return post.copyWith(tags: tags);
      }).toList();

    } catch (e) {
      print('Error fetching blog posts: $e');
      return [];
    }
  }

  @override
  Future<BlogPost> getBlogPost(String id) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) throw Exception('Database not initialized');

      // 1. Fetch Blog Post
      final doc = await databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdBlogPosts,
        documentId: id,
      );
      
      var post = BlogPost.fromMap(doc.data);

      // 2. Fetch Mappings for this Post
      final mappingsResult = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdPostTags,
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
         final tagDocs = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.collectionIdTags,
          queries: [Query.equal('tagId', tagId)],
        );
        if (tagDocs.documents.isNotEmpty) {
          tags.add(tagDocs.documents.first.data['tagName']);
        }
      }

      return post.copyWith(tags: tags);
    } catch (e) {
      print('Error fetching blog post: $e');
      rethrow;
    }
  }

  @override
  Future<void> createBlogPost(BlogPost post) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) throw Exception('Database not initialized');

      // Ensure Project ID is set (defensive fix for 401 error)
      _appwriteService.client.setProject(AppwriteConstants.projectId);

      await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdBlogPosts,
        documentId: ID.unique(),
        data: post.toMap(),
      );
    } catch (e) {
      print('Error creating blog post: $e');
      rethrow;
    }
  }
  @override
  Future<void> addTagsToPost(int postId, List<int> tagIds) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) throw Exception('Database not initialized');

      // Ensure Project ID is set (defensive fix for 401 error)
      _appwriteService.client.setProject(AppwriteConstants.projectId);

      for (final tagId in tagIds) {
        await databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.collectionIdPostTags,
          documentId: ID.unique(),
          data: {
            'postId': postId,
            'tagId': tagId,
          },
        );
      }
    } catch (e) {
      print('Error adding tags to post: $e');
      rethrow;
    }
  }
}
