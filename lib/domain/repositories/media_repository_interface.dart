import 'dart:typed_data';

import '../entities/media.dart';

abstract class IMediaRepository {
  Future<Media> uploadMedia(Uint8List fileBytes, String fileName, String mimeType);
  Future<String> getMediaUrl(String fileId);
  Future<void> deleteMedia(int mediaId);
}
