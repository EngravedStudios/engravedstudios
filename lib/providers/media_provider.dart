import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/media_repository_interface.dart';
import '../repositories/implementations/media_repository.dart';
import '../data/datasources/remote/appwrite_datasource.dart';
import '../core/logging/logger_provider.dart';
import '../domain/usecases/upload_media_usecase.dart';

final mediaRepositoryProvider = Provider<IMediaRepository>((ref) {
  final datasource = ref.watch(appwriteDatasourceProvider);
  final logger = ref.watch(appLoggerProvider);
  return MediaRepository(datasource, logger);
});

final uploadMediaUseCaseProvider = Provider<UploadMediaUseCase>((ref) {
  final repo = ref.watch(mediaRepositoryProvider);
  return UploadMediaUseCase(repo);
});
