import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/tag.dart';
import '../repositories/tag_repository_interface.dart';

class CreateTagUseCase {
  final ITagRepository _repository;
  final AppLogger _logger;

  CreateTagUseCase(this._repository, this._logger);

  Future<Result<void>> execute(Tag tag) async {
    try {
      await _repository.createTag(tag);
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.error('CreateTagUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
