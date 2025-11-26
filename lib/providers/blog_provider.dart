import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/blog_post.dart';
import '../repositories/interfaces/blog_repository_interface.dart';
import '../repositories/implementations/blog_repository.dart';
import '../services/appwrite_service.dart';
import 'auth_provider.dart';

part 'blog_provider.g.dart';

@riverpod
IBlogRepository blogRepository(BlogRepositoryRef ref) {
  final appwriteService = ref.watch(appwriteServiceProvider);
  return BlogRepository(appwriteService);
}

@riverpod
Future<List<BlogPost>> blogList(BlogListRef ref) async {
  final repository = ref.watch(blogRepositoryProvider);
  return repository.getBlogPosts();
}

@riverpod
class SelectedTag extends _$SelectedTag {
  @override
  String? build() => null;

  void setTag(String? tagName) {
    state = tagName;
  }
}

@riverpod
Future<List<BlogPost>> filteredBlogList(FilteredBlogListRef ref) async {
  final allPosts = await ref.watch(blogListProvider.future);
  final selectedTag = ref.watch(selectedTagProvider);

  if (selectedTag == null) {
    return allPosts;
  }

  return allPosts.where((post) => post.tags.contains(selectedTag)).toList();
}

@riverpod
Future<BlogPost> blogPost(BlogPostRef ref, String id) async {
  final repository = ref.watch(blogRepositoryProvider);
  return repository.getBlogPost(id);
}
