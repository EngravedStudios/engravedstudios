import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../entities/tag.dart';
import '../repositories/tag_repository_interface.dart';

class GetTagsUseCase {
  final ITagRepository _repository;
  final AppLogger _logger;

  GetTagsUseCase(this._repository, this._logger);

  Future<Result<List<Tag>>> execute() async {
    try {
      final tags = await _repository.getTags();
      return Result.success(tags);
    } catch (e, stackTrace) {
      _logger.error('GetTagsUseCase failed', e, stackTrace);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
