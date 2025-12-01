import 'dart:typed_data';

import '../../domain/entities/media.dart';
import '../../domain/repositories/media_repository_interface.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/remote/appwrite_datasource.dart';
import '../../core/logging/app_logger.dart';

class MediaRepository implements IMediaRepository {
  final IAppwriteDatasource _datasource;
  final AppLogger _logger;

  MediaRepository(this._datasource, this._logger);

  @override
  Future<Media> uploadMedia(Uint8List fileBytes, String fileName, String mimeType) async {
    try {
      final fileId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Upload file to Storage bucket (noted_media-storage)
      await _datasource.createFile(
        bucketId: AppConfig.bucketIdMedia,
        fileBytes: fileBytes,
        fileId: fileId,
        mimeType: mimeType,
        fileName: fileName,
      );
      
      // Get the file URL from storage
      final url = await getMediaUrl(fileId);
      final isVideo = mimeType.startsWith('video');
      
      // Create Media entity with only required fields
      final media = Media(
        mediaId: int.parse(fileId),
        fileUrl: url,
        mediaType: isVideo ? MediaType.video : MediaType.image,
        mediaTitle: fileName,
      );
      
      // Save metadata to database table (noted_media)
      await _datasource.createDocument(
        collectionId: AppConfig.collectionIdMedia,
        documentId: fileId,
        data: media.toJson(), // Only includes: mediaId, fileUrl, mediaType, mediaTitle
      );
      
      _logger.info('Media uploaded to storage and saved to database: $fileId');
      return media;
    } catch (e, stack) {
      _logger.error('Failed to upload media', e, stack);
      rethrow;
    }
  }

  @override
  Future<String> getMediaUrl(String fileId) async {
    return await _datasource.getFileView(bucketId: AppConfig.bucketIdMedia, fileId: fileId);
  }

  @override
  Future<void> deleteMedia(int mediaId) async {
    try {
      final fileId = mediaId.toString();
      
      // Delete from database first
      await _datasource.deleteDocument(
        collectionId: AppConfig.collectionIdMedia,
        documentId: fileId,
      );
      
      // Then delete from storage bucket
      await _datasource.deleteFile(
        bucketId: AppConfig.bucketIdMedia,
        fileId: fileId,
      );
      
      _logger.info('Media deleted from database and storage: $mediaId');
    } catch (e, stack) {
      _logger.error('Failed to delete media: $mediaId', e, stack);
      rethrow;
    }
  }
}
