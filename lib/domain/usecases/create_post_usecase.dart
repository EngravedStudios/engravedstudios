import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository_interface.dart';

class CreatePostUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  CreatePostUseCase(this._repository, this._logger);

  Future<Result<void>> execute(BlogPost post) async {
    try {
      await _repository.createBlogPost(post);
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.error('CreatePostUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
