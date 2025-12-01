import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository_interface.dart';

class UpdatePostUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  UpdatePostUseCase(this._repository, this._logger);

  Future<Result<void>> execute(BlogPost post) async {
    try {
      await _repository.updateBlogPost(post);
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.error('UpdatePostUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
