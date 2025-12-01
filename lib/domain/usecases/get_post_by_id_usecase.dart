import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/blog_post.dart';
import '../repositories/blog_repository_interface.dart';

class GetPostByIdUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  GetPostByIdUseCase(this._repository, this._logger);

  Future<Result<BlogPost>> execute(String postId) async {
    try {
      final post = await _repository.getBlogPost(postId);
      return Result.success(post);
    } catch (e, stackTrace) {
      _logger.error('GetPostByIdUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
