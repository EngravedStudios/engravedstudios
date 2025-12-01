import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/logging/logger_provider.dart';
import '../../../../services/appwrite_service.dart';

/// Interface for the Appwrite remote data source
abstract class IAppwriteDatasource {
  Future<DocumentList> listDocuments({
    required String collectionId,
    List<String>? queries,
  });

  Future<Document> getDocument({
    required String collectionId,
    required String documentId,
  });

  Future<Document> createDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<Document> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  });

  /// Upload a file to a bucket
  Future<File> createFile({
    required String bucketId,
    required Uint8List fileBytes,
    required String fileId,
    required String mimeType,
    required String fileName,
  });

  /// Get a file preview URL (view) for a file
  Future<String> getFileView({
    required String bucketId,
    required String fileId,
  });

  /// Delete a file from storage bucket
  Future<void> deleteFile({
    required String bucketId,
    required String fileId,
  });
}

/// Implementation of the Appwrite remote data source
class AppwriteDatasource implements IAppwriteDatasource {
  final AppwriteService _appwriteService;
  final AppLogger _logger;

  AppwriteDatasource(this._appwriteService, this._logger);

  Databases get _databases => _appwriteService.databases;

  @override
  Future<DocumentList> listDocuments({
    required String collectionId,
    List<String>? queries,
  }) async {
    try {
      return await _databases.listDocuments(
        databaseId: AppConfig.databaseId,
        collectionId: collectionId,
        queries: queries,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite listDocuments failed: $collectionId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in listDocuments: $collectionId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Document> getDocument({
    required String collectionId,
    required String documentId,
  }) async {
    try {
      return await _databases.getDocument(
        databaseId: AppConfig.databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite getDocument failed: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in getDocument: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Document> createDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Ensure project ID is set (defensive)
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);

      return await _databases.createDocument(
        databaseId: AppConfig.databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite createDocument failed: $collectionId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in createDocument: $collectionId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Document> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);

      return await _databases.updateDocument(
        databaseId: AppConfig.databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite updateDocument failed: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in updateDocument: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    try {
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);

      await _databases.deleteDocument(
        databaseId: AppConfig.databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite deleteDocument failed: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in deleteDocument: $collectionId/$documentId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }



  @override
  Future<File> createFile({
    required String bucketId,
    required Uint8List fileBytes,
    required String fileId,
    required String mimeType,
    required String fileName,
  }) async {
    try {
      // Ensure project is set
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);
      return await _appwriteService.storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: InputFile.fromBytes(
          bytes: fileBytes,
          filename: fileName,
        ),
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite createFile failed: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in createFile: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }



  @override
  Future<String> getFileView({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);
      // Construct URL manually as getFileView returns bytes
      return '${AppConfig.appwriteEndpoint}/storage/buckets/$bucketId/files/$fileId/view?project=${AppConfig.appwriteProjectId}';
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite getFileView failed: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in getFileView: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteFile({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      _appwriteService.client.setProject(AppConfig.appwriteProjectId);
      await _appwriteService.storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId,
      );
    } on AppwriteException catch (e, stackTrace) {
      _logger.error('Appwrite deleteFile failed: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.message ?? 'Unknown Appwrite error', e.code.toString());
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in deleteFile: $bucketId/$fileId', e, stackTrace);
      throw ServerException(e.toString());
    }
  }
}

final appwriteDatasourceProvider = Provider<IAppwriteDatasource>((ref) {
  final appwriteService = ref.watch(appwriteServiceProvider);
  final logger = ref.watch(appLoggerProvider);
  return AppwriteDatasource(appwriteService, logger);
});
