import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../repositories/blog_repository_interface.dart';

class ToggleVisibilityUseCase {
  final IBlogRepository _repository;
  final AppLogger _logger;

  ToggleVisibilityUseCase(this._repository, this._logger);

  Future<Result<void>> execute(String postId, bool isPublished) async {
    try {
      await _repository.updatePublishStatus(postId, isPublished);
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.error('ToggleVisibilityUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
