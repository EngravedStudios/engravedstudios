import '../entities/blog_post.dart';

abstract class IBlogRepository {
  Future<List<BlogPost>> getBlogPosts();
  Future<BlogPost> getBlogPost(String id);
  Future<void> createBlogPost(BlogPost post);
  Future<void> updateBlogPost(BlogPost post);
  Future<void> addTagsToPost(int postId, List<int> tagIds);
  Future<void> updateTagsForPost(int postId, List<int> tagIds);
  Future<void> deleteBlogPost(String id);
  Future<void> updatePublishStatus(String id, bool isPublished);
}
