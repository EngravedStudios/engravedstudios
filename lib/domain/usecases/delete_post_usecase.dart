import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../repositories/blog_repository_interface.dart';

class DeletePostUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  DeletePostUseCase(this._repository, this._logger);

  Future<Result<void>> execute(String postId) async {
    try {
      await _repository.deleteBlogPost(postId);
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.error('DeletePostUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
