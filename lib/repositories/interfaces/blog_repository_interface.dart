import '../../models/blog_post.dart';

abstract class IBlogRepository {
  Future<List<BlogPost>> getBlogPosts();
  Future<BlogPost> getBlogPost(String id);
  Future<void> createBlogPost(BlogPost post);
  Future<void> addTagsToPost(int postId, List<int> tagIds);
}
