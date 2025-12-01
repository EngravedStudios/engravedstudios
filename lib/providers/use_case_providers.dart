import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logging/logger_provider.dart';
import '../domain/usecases/create_post_usecase.dart';
import '../domain/usecases/create_tag_usecase.dart';
import '../domain/usecases/delete_post_usecase.dart';
import '../domain/usecases/get_post_by_id_usecase.dart';
import '../domain/usecases/get_posts_usecase.dart';
import '../domain/usecases/get_tags_usecase.dart';
import '../domain/usecases/toggle_visibility_usecase.dart';
import '../domain/usecases/update_post_usecase.dart';
import 'blog_provider.dart';
import 'tag_provider.dart';

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return GetPostsUseCase(repository, logger);
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return CreatePostUseCase(repository, logger);
});

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return UpdatePostUseCase(repository, logger);
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return DeletePostUseCase(repository, logger);
});

final toggleVisibilityUseCaseProvider = Provider<ToggleVisibilityUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return ToggleVisibilityUseCase(repository, logger);
});

final getPostByIdUseCaseProvider = Provider<GetPostByIdUseCase>((ref) {
  final repository = ref.watch(blogRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return GetPostByIdUseCase(repository, logger);
});

final getTagsUseCaseProvider = Provider<GetTagsUseCase>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return GetTagsUseCase(repository, logger);
});

final createTagUseCaseProvider = Provider<CreateTagUseCase>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  return CreateTagUseCase(repository, logger);
});

