import 'dart:typed_data';

import '../../domain/entities/media.dart';
import '../../domain/repositories/media_repository_interface.dart';

class UploadMediaUseCase {
  final IMediaRepository _mediaRepository;

  UploadMediaUseCase(this._mediaRepository);

  Future<Media> call(Uint8List fileBytes, String fileName, String mimeType) async {
    return await _mediaRepository.uploadMedia(fileBytes, fileName, mimeType);
  }
}
