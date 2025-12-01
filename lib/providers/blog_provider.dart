import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/blog_post.dart';
import '../domain/repositories/blog_repository_interface.dart';
import '../repositories/implementations/blog_repository.dart';
import '../data/datasources/remote/appwrite_datasource.dart';
import '../core/logging/logger_provider.dart';
import '../domain/entities/user.dart';
import 'auth_provider.dart';
import 'user_data_provider.dart';

part 'blog_provider.g.dart';

@riverpod
IBlogRepository blogRepository(Ref ref) {
  final datasource = ref.watch(appwriteDatasourceProvider);
  final logger = ref.watch(appLoggerProvider);
  return BlogRepository(datasource, logger);
}

@riverpod
Future<List<BlogPost>> blogList(Ref ref) async {
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
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
Future<List<BlogPost>> visibleBlogList(Ref ref) async {
  final allPosts = await ref.watch(blogListProvider.future);
  final currentUser = ref.watch(authStateProvider).valueOrNull;
  
  return allPosts.where((post) {
    // Show if published OR if user is the author (or admin)
    if (post.isPublished) return true;
    if (currentUser == null) return false;
    
    return post.authorId == currentUser.id || 
           currentUser.role == UserRole.admin;
  }).toList();
}

@riverpod
Future<List<BlogPost>> filteredBlogList(Ref ref) async {
  final visiblePosts = await ref.watch(visibleBlogListProvider.future);
  final selectedTag = ref.watch(selectedTagProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  // Apply tag filter
  var filtered = visiblePosts;
  if (selectedTag == 'SAVED') {
    final savedPostIds = await ref.watch(savedPostIdsProvider.future);
    filtered = filtered.where((post) => savedPostIds.contains(post.id)).toList();
  } else if (selectedTag != null) {
    filtered = filtered.where((post) => post.tags.contains(selectedTag)).toList();
  }

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((post) {
      final titleMatch = post.title.toLowerCase().contains(searchQuery);
      final subtitleMatch = post.subtitle.toLowerCase().contains(searchQuery);
      final contentMatch = post.content.toLowerCase().contains(searchQuery);
      final authorMatch = post.authorName.toLowerCase().contains(searchQuery);
      return titleMatch || subtitleMatch || contentMatch || authorMatch;
    }).toList();
  }

  return filtered;
}

@riverpod
Future<BlogPost> blogPost(Ref ref, String id) async {
  final repository = ref.watch(blogRepositoryProvider);
  return repository.getBlogPost(id);
}
