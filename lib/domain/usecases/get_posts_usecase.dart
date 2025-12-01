import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository_interface.dart';

class GetPostsUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  GetPostsUseCase(this._repository, this._logger);

  Future<Result<List<BlogPost>>> execute() async {
    try {
      final posts = await _repository.getBlogPosts();
      return Result.success(posts);
    } catch (e, stackTrace) {
      _logger.error('GetPostsUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
